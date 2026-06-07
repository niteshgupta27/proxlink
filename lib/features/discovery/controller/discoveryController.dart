import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

// import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide Cluster;
import 'package:proxlink/Utill/Apputills.dart';
import 'package:proxlink/Utill/app_colors.dart';
import 'package:proxlink/Utill/app_storage.dart';
import 'package:proxlink/features/discovery/model/discovery_Model.dart';
import 'package:proxlink/features/discovery/services/discoveryService.dart';

import '../../Chat/controller/chatController.dart';
import '../view/discoveryView.dart';

class DiscoveryController extends GetxController {
  final appStorage = Get.find<AppStorage>();
  final discoveryservice = Get.find<Discoveryservice>();
  final chatController = Get.find<ChatController>();

  GoogleMapController? mapController;

  // Observables for UI state
  var markers = <Marker>{}.obs;
  var selectedMarkerId = "".obs;
  var isLoading = false.obs;
  var isLocationReady = false.obs;
  LatLng? initialLatLng;

  // Data sets
  RxList<Cluster> clusterList = <Cluster>[].obs;
  var groupedUsers = <String, List<GroupedUser>>{}.obs;

  // Search logic
  var searchQuery = "".obs;
  final TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Check if location is already available in storage
    if (appStorage.current_lat.value != 0.0) {
      initialLatLng = LatLng(appStorage.current_lat.value, appStorage.current_lng.value);
      isLocationReady.value = true;
      _initData();
    }

    _handleLocationAndService();
    searchTextController.addListener(() {
      searchQuery.value = searchTextController.text;
    });
    _setupSearchDebounce();

    // Listen to location changes and update map position & data
    everAll([appStorage.current_lat, appStorage.current_lng], (_) {
      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLng(LatLng(appStorage.current_lat.value, appStorage.current_lng.value)));
      }
      if (isLocationReady.value) {
        _initData();
      }
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// Check permission and handle location
  Future<void> _handleLocationAndService() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If service is disabled, we still want to try to load data with what we have
      if (isLocationReady.value) _initData();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    try {
      Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));

      // If we didn't have location yet, set it as initial
      if (!isLocationReady.value) {
        initialLatLng = LatLng(position.latitude, position.longitude);
        appStorage.current_lng.value = position.longitude;
        appStorage.current_lat.value = position.latitude;
        isLocationReady.value = true;
        _initData();
      } else {
        appStorage.current_lng.value = position.longitude;
        appStorage.current_lat.value = position.latitude;
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  /// Initial data load
  void _initData() {
    fetchDiscoveryUsers(lat: appStorage.current_lat.value, lng: appStorage.current_lng.value, profession: searchTextController.text);
  }

  /// Manages the debounced search logic
  void _setupSearchDebounce() {
    debounce(searchQuery, (String value) {
      if (isLocationReady.value) {
        _initData();
      }
    }, time: const Duration(milliseconds: 600));
  }

  /// Main function to fetch discovery data and handle state
  Future<void> fetchDiscoveryUsers({required double lat, required double lng, String activeMinutes = "", String maxPerGroup = "", String profession = "", String rangeKm = ""}) async {
    isLoading.value = true;

    final body = {
      "api_key": appStorage.loggedInUserToken,
      "user_id": appStorage.loggedInUserId?.toString() ?? "0",
      "payload": {"active_minutes": activeMinutes, "lat": lat.toString(), "lng": lng.toString(), "max_per_group": maxPerGroup, "profession": profession, "range_km": rangeKm},
    };

    try {
      final response = await discoveryservice.getDiscovery(body: body);
      await _handleDiscoveryResponse(response);
    } catch (err) {
      isLoading.value = false;
      debugPrint("Discovery fetch error: $err");
    }
  }

  /// Handles the response dataset and updates state
  Future<void> _handleDiscoveryResponse(DiscoveryModelResponse response) async {
    markers.clear();
    if (response.status == "success") {
      clusterList.value = response.clusters;
      groupedUsers.value = response.groupedUsers;
      await updateMarkers();
    } else {
      Set<Marker> newMarkers = {};
      markers.assignAll(newMarkers);
      AppUtils.showSnackbar("Failed to fetch discovery data", "Info");
    }
    isLoading.value = false;
  }

  /// Updates map markers based on current cluster dataset
  Future<void> updateMarkers() async {
    Set<Marker> newMarkers = {};

    for (var cluster in clusterList) {
      bool isSelected = selectedMarkerId.value == cluster.groupId;
      final icon = await _createCustomMarkerIcon(text: cluster.count.toString(), color: isSelected ? AppColors.green : AppColors.primaryColor);

      newMarkers.add(
        Marker(
          markerId: MarkerId(cluster.groupId),
          position: LatLng(cluster.lat, cluster.lng),
          icon: icon,
          onTap: () {
            selectedMarkerId.value = cluster.groupId;
            updateMarkers();
            _showContactBottomSheet(cluster.groupId);
          },
        ),
      );
    }
    markers.assignAll(newMarkers);
    markers.refresh();
  }

  Future<BitmapDescriptor> _createCustomMarkerIcon({required String text, required Color color}) async {
    const double width = 34;
    const double height = 42;
    const double radius = 10;

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final centerX = width / 2;
    final centerY = radius;

    // Pin shape - Single continuous path to ensure no transparency gaps
    final path = Path();
    // Start at the bottom tip
    path.moveTo(centerX, height);
    // Curve to the left side of the circle
    path.quadraticBezierTo(
      centerX - radius,
      height * 0.6,
      centerX - radius,
      centerY,
    );
    // Draw the top circular arc
    path.arcTo(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      math.pi,
      math.pi,
      false,
    );
    // Curve back down to the bottom tip
    path.quadraticBezierTo(
      centerX + radius,
      height * 0.6,
      centerX,
      height,
    );
    path.close();

    canvas.drawPath(path, paint);
    // Inner white circle
    canvas.drawCircle(Offset(centerX, centerY), 7.5, whitePaint);
    // Count text
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: text.length >= 2 ? 10 : 12),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2));
    final image = await recorder.endRecording().toImage(width.toInt(), height.toInt());
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  // Future<BitmapDescriptor> _createCustomMarkerIcon({required String text, required Color color}) async {
  //   const double size = 30; // Small marker
  //
  //   final PictureRecorder recorder = PictureRecorder();
  //   final Canvas canvas = Canvas(recorder);
  //
  //   final Paint outerPaint = Paint()
  //     ..color = color
  //     ..style = PaintingStyle.fill;
  //
  //   final Paint innerPaint = Paint()
  //     ..color = Colors.white
  //     ..style = PaintingStyle.fill;
  //
  //   // Outer circle
  //   canvas.drawCircle(Offset(size / 2, size / 2), size / 2, outerPaint);
  //
  //   // Inner circle
  //   canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, innerPaint);
  //
  //   // Text
  //   final textPainter = TextPainter(
  //     text: TextSpan(
  //       text: text,
  //       style: const TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
  //     ),
  //     textDirection: TextDirection.ltr,
  //   );
  //   textPainter.layout();
  //   textPainter.paint(canvas, Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2));
  //   final image = await recorder.endRecording().toImage(size.toInt(), size.toInt());
  //   final byteData = await image.toByteData(format: ImageByteFormat.png);
  //
  //   return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  // }

  void _showContactBottomSheet(String groupId) {
    final users = groupedUsers[groupId] ?? [];
    Get.bottomSheet(ContactBottomSheet(users: users), isDismissible: true, enableDrag: true, backgroundColor: Colors.transparent);
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide Cluster;
import 'package:proxlink/Utill/app_colors.dart';
import 'package:proxlink/Utill/app_storage.dart';
import 'package:proxlink/features/discovery/model/discovery_Model.dart';
import 'package:proxlink/features/discovery/services/discoveryService.dart';
import 'package:proxlink/Utill/Apputills.dart';

import '../view/discoveryView.dart';

class DiscoveryController extends GetxController {
  final appStorage = Get.find<AppStorage>();
  final discoveryservice = Get.find<Discoveryservice>();

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
  var searchProfession = "".obs;
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
    _setupSearchDebounce();
    
    // Listen to location changes and update map position & data
    everAll([appStorage.current_lat, appStorage.current_lng], (_) {
      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLng(
          LatLng(appStorage.current_lat.value, appStorage.current_lng.value),
        ));
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
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
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
    fetchDiscoveryUsers(
      lat: appStorage.current_lat.value,
      lng: appStorage.current_lng.value,
      profession: searchProfession.value,
    );
  }

  /// Manages the debounced search logic
  void _setupSearchDebounce() {
    debounce(searchProfession, (String value) {
      _initData();
    }, time: const Duration(milliseconds: 800));
  }

  /// Main function to fetch discovery data and handle state
  Future<void> fetchDiscoveryUsers({
    required double lat,
    required double lng,
    String activeMinutes = "",
    String maxPerGroup = "",
    String profession = "",
    String rangeKm = "",
  }) async {
    isLoading.value = true;

    final body = {
      "api_key": appStorage.loggedInUserToken,
      "user_id": appStorage.loggedInUserId?.toString() ?? "0",
      "payload": {
        "active_minutes": activeMinutes,
        "lat": lat.toString(),
        "lng": lng.toString(),
        "max_per_group": maxPerGroup,
        "profession": profession,
        "range_km": rangeKm
      }
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
   markers.value= <Marker>{};
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
      final icon = await _createCustomMarkerIcon(
        cluster.count.toString(),
        isSelected ? AppColors.green : AppColors.primaryColor,
      );

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

  Future<BitmapDescriptor> _createCustomMarkerIcon(String label, Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const size = Size(110, 160);

    final Paint paint = Paint()..color = color;
    final Path path = Path();
    path.moveTo(size.width / 2, size.height);
    path.quadraticBezierTo(0, size.height * 0.4, 0, size.width / 2);
    path.arcToPoint(Offset(size.width, size.width / 2), radius: Radius.circular(size.width / 2));
    path.quadraticBezierTo(size.width, size.height * 0.4, size.width / 2, size.height);
    canvas.drawPath(path, paint);

    canvas.drawCircle(Offset(size.width / 2, size.width / 2), size.width / 2.8, Paint()..color = Colors.white);

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(color: color, fontSize: 40, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, (size.width / 2 - textPainter.height / 2)));

    final img = await pictureRecorder.endRecording().toImage(size.width.toInt(), size.height.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  void _showContactBottomSheet(String groupId) {
    final users = groupedUsers[groupId] ?? [];
    Get.bottomSheet(
      ContactBottomSheet(users: users),
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}

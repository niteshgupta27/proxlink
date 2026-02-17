import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide Cluster;
import 'package:proxlink/LocationService.dart';
import 'package:proxlink/Utill/AppConstants.dart';
import 'package:proxlink/Utill/app_colors.dart';
import 'package:proxlink/Utill/app_storage.dart';
import 'package:proxlink/features/discovery/model/discovery_Model.dart';
import 'package:proxlink/features/discovery/services/discoveryService.dart';
import 'package:proxlink/features/network/controller/NetworkController.dart';

import '../../../Utill/Apputills.dart';
import '../../../main.dart';
import '../view/discoveryView.dart';

class DiscoveryController extends GetxController {
  final appStorage = Get.find<AppStorage>();
  final discoveryservice = Get.find<Discoveryservice>();

  // Observables for UI state
  var markers = <Marker>{}.obs;
  var selectedMarkerId = "".obs;
  var isLoading = false.obs;

  // Data sets
  RxList<Cluster> clusterList = <Cluster>[].obs;
  var groupedUsers = <String, List<GroupedUser>>{}.obs;

  // Search logic
  var searchProfession = "".obs;
  final TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _handleLocationAndService();
    _initData();
    _setupSearchDebounce();
  }

  /// Check permission and start service
  Future<void> _handleLocationAndService() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppUtils.showSnackbar("Location services are disabled.", "Info");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AppUtils.showSnackbar("Location permissions are denied", "Error");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AppUtils.showSnackbar("Location permissions are permanently denied", "Error");
      return;
    }

    // If we have permission, initialize and start the service
    await initializeService();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
     // timeLimit: const Duration(seconds: 10),
    );
    appStorage.current_lng.value=position.longitude;
    appStorage.current_lat.value=position.latitude;
    _initData();
  }

  /// Initial data load
  void _initData() {
    fetchDiscoveryUsers(
      lat: appStorage.current_lat.value,
      lng: appStorage.current_lng.value,
    );
  }

  /// Manages the debounced search logic in a separate function
  void _setupSearchDebounce() {
    String search=searchTextController.value.text.toString();
    if(search.length>3) {
      debounce(searchProfession, (_) {
        fetchDiscoveryUsers(
          lat: appStorage.current_lat.value,
          lng: appStorage.current_lng.value,
          profession: searchProfession.value,
        );
      }, time: const Duration(seconds: 1));
    }
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
      _handleDiscoveryResponse(response);
    } catch (err) {
      isLoading.value = false;
      AppUtils.showSnackbar("Something went wrong: $err", "Oops");
    }
  }

  /// Handles the response dataset and updates state
  void _handleDiscoveryResponse(DiscoveryModelResponse response) {
    isLoading.value = false;
    if (response.status == "success") {
      clusterList.value = response.clusters;
      groupedUsers.value = response.groupedUsers;
      updateMarkers();
    } else {
      AppUtils.showSnackbar("Failed to fetch discovery data", "Info");
    }
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
            updateMarkers(); // Refresh to change colors
            _showContactBottomSheet(cluster.groupId);
          },
        ),
      );
    }
    markers.assignAll(newMarkers);
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
    //searchTextController.dispose();
    super.onClose();
  }
}



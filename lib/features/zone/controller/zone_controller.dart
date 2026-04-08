import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide Cluster;
import 'package:proxlink/Utill/app_colors.dart';
import 'package:proxlink/Utill/app_storage.dart';
import 'package:proxlink/features/zone/model/zone_model.dart' as model;
import 'package:proxlink/features/zone/service/zone_service.dart';
import 'package:proxlink/routes/app_pages.dart';
import '../view/zone_view.dart';
import 'package:collection/collection.dart';

class ZoneController extends GetxController {
  final appStorage = Get.find<AppStorage>();
  final zoneService = Get.find<ZoneService>();
  GoogleMapController? mapController;

  var markers = <Marker>{}.obs;
  var selectedMarkerId = "".obs;
  var isLoading = false.obs;
  var isListView = false.obs;
  
  // Membership and Ownership counts
  var membershipCount = 0.obs;
  var ownershipCount = 0.obs;
  
  // Data sets
  RxList<model.Cluster> clusterList = <model.Cluster>[].obs;
  var groupedZones = <String, List<model.ZoneData>>{}.obs;
  RxList<model.ZoneData> allZoneList = <model.ZoneData>[].obs;

  @override
  void onInit() {
    super.onInit();
    _handleLocationAndService();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void toggleView() {
    isListView.toggle();
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
      
      appStorage.current_lat.value = position.latitude;
      appStorage.current_lng.value = position.longitude;
      
      fetchZoneMapRealtime();
    } catch (e) {
      debugPrint("Error getting location: $e");
      fetchZoneMapRealtime(); // Fetch anyway if we have stored location or default
    }
  }

  Future<void> fetchZoneMapRealtime() async {
    isLoading.value = true;

    final body = {
      "user_id": appStorage.loggedInUserId?.toString() ?? "0",
      "api_key": appStorage.loggedInUserToken,
      "payload": {
        "lat": appStorage.current_lat.value,
        "lng": appStorage.current_lng.value,
        "zoom": 12,
        "range_km": 25
      }
    };

    try {
      final response = await zoneService.getZoneMapRealtime(body: body);
      if (response.status == "success") {
        clusterList.value = response.clusters;
        groupedZones.value = response.groupedZones;
        membershipCount.value = response.membershipCount;
        ownershipCount.value = response.ownershipCount;
        
        // Flatten grouped zones for the list view
        List<model.ZoneData> flattened = [];
        response.groupedZones.forEach((key, value) {
          flattened.addAll(value);
        });
        allZoneList.value = flattened;

        await updateMarkers();
      }
    } catch (err) {
      debugPrint("Zone map fetch error: $err");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMarkers() async {
    Set<Marker> newMarkers = {};

    for (var cluster in clusterList) {
      bool isSelected = selectedMarkerId.value == cluster.groupId;
      final icon = await _createZoneMarkerIcon(
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
            _showZoneDetailsBottomSheet(cluster.groupId);
          },
        ),
      );
    }
    markers.assignAll(newMarkers);
  }

  Future<BitmapDescriptor> _createZoneMarkerIcon(String count, Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double size = 150.0;
    
    final Paint ringPaint1 = Paint()..color = color.withOpacity(0.2);
    final Paint ringPaint2 = Paint()..color = color.withOpacity(0.4);
    final Paint solidPaint = Paint()..color = color;

    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, ringPaint1);
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2.8, ringPaint2);
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 4, solidPaint);

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: count,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
    );

    final img = await pictureRecorder.endRecording().toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  void _showZoneDetailsBottomSheet(String groupId) {
    final zones = groupedZones[groupId] ?? [];
    if (zones.isNotEmpty) {
      Get.bottomSheet(
        ZoneDetailsBottomSheet(zones: zones),
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
      );
    }
  }
}

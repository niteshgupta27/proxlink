import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proxlink/Utill/app_colors.dart';
import 'package:proxlink/Utill/app_storage.dart';

class ZoneController extends GetxController {
  final appStorage = Get.find<AppStorage>();
  GoogleMapController? mapController;

  var markers = <Marker>{}.obs;
  var isLoading = false.obs;
  
  // Membership and Ownership counts
  var membershipCount = 5.obs;
  var ownershipCount = 5.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialLocation();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addMockMarkers();
  }

  Future<void> _loadInitialLocation() async {
    if (appStorage.current_lat.value == 0.0) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        appStorage.current_lat.value = position.latitude;
        appStorage.current_lng.value = position.longitude;
      } catch (e) {
        debugPrint("Error getting location: $e");
      }
    }
  }

  void _addMockMarkers() async {
    final lat = appStorage.current_lat.value;
    final lng = appStorage.current_lng.value;
    if (lat == 0.0) return;

    Set<Marker> newMarkers = {};
    
    // Example data based on image
    final mockData = [
      {'id': '1', 'lat': lat + 0.005, 'lng': lng + 0.002, 'count': '10'},
      {'id': '2', 'lat': lat + 0.003, 'lng': lng + 0.006, 'count': '5'},
      {'id': '3', 'lat': lat + 0.001, 'lng': lng + 0.001, 'count': '3'},
      {'id': '4', 'lat': lat - 0.004, 'lng': lng - 0.005, 'count': '7'},
      {'id': '5', 'lat': lat - 0.007, 'lng': lng + 0.001, 'count': '2'},
      {'id': '6', 'lat': lat - 0.010, 'lng': lng - 0.004, 'count': '3'},
      {'id': '7', 'lat': lat - 0.005, 'lng': lng + 0.009, 'count': '1'},
    ];

    for (var data in mockData) {
      final icon = await _createZoneMarkerIcon(data['count'] as String);
      newMarkers.add(
        Marker(
          markerId: MarkerId(data['id'] as String),
          position: LatLng(data['lat'] as double, data['lng'] as double),
          icon: icon,
        ),
      );
    }
    markers.value = newMarkers;
  }

  Future<BitmapDescriptor> _createZoneMarkerIcon(String count) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double size = 150.0;
    
    // Draw rings (glow effect)
    final Paint ringPaint1 = Paint()..color = AppColors.primaryColor.withOpacity(0.2);
    final Paint ringPaint2 = Paint()..color = AppColors.primaryColor.withOpacity(0.4);
    final Paint solidPaint = Paint()..color = AppColors.primaryColor;

    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, ringPaint1);
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2.8, ringPaint2);
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 4, solidPaint);

    // Draw text
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
}

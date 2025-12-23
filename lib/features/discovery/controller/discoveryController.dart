import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proxlink/Utill/app_colors.dart';

import '../../../Utill/dialog_helper.dart';
import '../view/discoveryView.dart';

class DiscoveryController extends GetxController {
  var markers = <Marker>{}.obs;
  var selectedMarkerId = "".obs;

  // Mock Data
  final List<Map<String, dynamic>> locations = [
    {"id": "1", "lat": 13.0827, "lng": 80.2707, "count": "6"},
    {"id": "2", "lat": 13.0850, "lng": 80.2850, "count": "3"},
  ];

  @override
  void onInit() {
    super.onInit();
    updateMarkers(); // Initial load
  }

  // Generate markers with custom drawing
  Future<void> updateMarkers() async {
    Set<Marker> newMarkers = {};

    for (var loc in locations) {
      bool isSelected = selectedMarkerId.value == loc['id'];
      final icon = await _createCustomMarkerIcon(
        loc['count'],
        isSelected ? AppColors.green : AppColors.primaryColor,
      );

      newMarkers.add(
        Marker(
          markerId: MarkerId(loc['id']),
          position: LatLng(loc['lat'], loc['lng']),
          icon: icon,
          onTap: () {
            selectedMarkerId.value = loc['id'];
            updateMarkers(); // Refresh to change colors
            _showContactBottomSheet(loc['count']);
          },
        ),
      );
    }
    markers.value = newMarkers;
  }

  // Draw the custom marker matching your image
  Future<BitmapDescriptor> _createCustomMarkerIcon(String label, Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const size = Size(110, 160);

    final Paint paint = Paint()..color = color;

    // 1. Draw Pin Shape
    final Path path = Path();
    path.moveTo(size.width / 2, size.height);
    path.quadraticBezierTo(0, size.height * 0.4, 0, size.width / 2);
    path.arcToPoint(Offset(size.width, size.width / 2), radius: Radius.circular(size.width / 2));
    path.quadraticBezierTo(size.width, size.height * 0.4, size.width / 2, size.height);
    canvas.drawPath(path, paint);

    // 2. Draw White Inner Circle
    canvas.drawCircle(Offset(size.width / 2, size.width / 2), size.width / 2.8, Paint()..color = Colors.white);

    // 3. Draw Count Text
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

  void _showContactBottomSheet(String count) {
    Get.bottomSheet(
      ContactBottomSheet(count: count),
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
    );
  }
}
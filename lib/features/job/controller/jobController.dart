import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide Cluster;
import 'package:proxlink/Utill/app_colors.dart';
import 'package:proxlink/Utill/app_storage.dart';
import 'package:proxlink/features/job/services/jobService.dart';
import '../model/JobResponse.dart';
import '../../../Utill/Apputills.dart';
import '../view/jobView.dart';

class JobController extends GetxController {
  final appStorage = Get.find<AppStorage>();
  final jobService = Get.find<JobService>();

  GoogleMapController? mapController;

  // Observables for UI state
  var markers = <Marker>{}.obs;
  var selectedMarkerId = "".obs;
  var isLoading = true.obs;
  
  // Data sets
  RxList<Cluster> clusterList = <Cluster>[].obs;
  var groupedDetails = <String, List<JobDetail>>{}.obs;

  // Search logic
  var searchQuery = "".obs;
  final TextEditingController searchTextController = TextEditingController();
  var suggestions = <String>[].obs;
  var showSuggestions = false.obs;
  bool _isSelection = false;

  final List<String> allSuggestions = [
    "Software Engineer",
    "Product Manager",
    "Data Scientist",
    "Designer",
    "Marketing Manager",
    "Sales Executive",
    "HR Manager",
    "Accountant",
    "Doctor",
    "Teacher",
    "Flutter Developer",
    "React Native Developer",
    "Full Stack Developer",
    "UI/UX Designer",
    "Graphic Designer",
    "Digital Marketer",
    "Content Writer",
    "Customer Support",
  ];

  @override
  void onInit() {
    super.onInit();
    _handleLocation();
    
    searchTextController.addListener(() {
      searchQuery.value = searchTextController.text;
    });
    
    _setupSearchDebounce();

    // Listen to location changes and update map camera position & markers
    everAll([appStorage.current_lat, appStorage.current_lng], (_) {
      _moveCameraToCurrentLocation();
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _moveCameraToCurrentLocation();
  }

  void _moveCameraToCurrentLocation() {
    if (mapController != null && appStorage.current_lat.value != 0.0) {
      mapController!.animateCamera(CameraUpdate.newLatLng(
        LatLng(appStorage.current_lat.value, appStorage.current_lng.value),
      ));
    }
  }

  Future<void> _handleLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isLoading.value = false;
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isLoading.value = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      isLoading.value = false;
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      appStorage.current_lng.value = position.longitude;
      appStorage.current_lat.value = position.latitude;
      fetchJobs();
    } catch (e) {
      debugPrint("Error getting initial location: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectSuggestion(String suggestion) {
    _isSelection = true;
    searchTextController.text = suggestion;
    showSuggestions.value = false;
    // fetchJobs is called by debounce
  }

  /// Manages the debounced search logic
  void _setupSearchDebounce() {
    debounce(searchQuery, (String value) {
      if (_isSelection) {
        _isSelection = false;
        showSuggestions.value = false;
        fetchJobs(keywords: value);
        return;
      }

      if (value.isNotEmpty) {
        suggestions.value = allSuggestions
            .where((element) => element.toLowerCase().contains(value.toLowerCase()))
            .toList();
        showSuggestions.value = suggestions.isNotEmpty;
      } else {
        showSuggestions.value = false;
      }
      fetchJobs(keywords: value);
    }, time: const Duration(milliseconds: 600));
  }

  Future<void> fetchJobs({
    String excludeApplied = "",
    String jobType = "",
    String keywords = "",
    String maxPerGroup = "",
    String profession = "",
    String rangeM = "",
    String skills = "",
    String salaryMin = "",
    String salaryMax = "",
  }) async {
    if (appStorage.current_lat.value == 0.0) return;
    
    isLoading.value = true;

    final body = {
      "api_key": appStorage.loggedInUserToken,
      "user_id": appStorage.loggedInUserId?.toString() ?? "0",
      "payload": {
        "exclude_applied": excludeApplied,
        "job_type": jobType,
        "keywords": keywords,
        "lat": appStorage.current_lat.value.toString(),
        "lng": appStorage.current_lng.value.toString(),
        "max_per_group": maxPerGroup,
        "profession": profession,
        "range_km": rangeM,
        "skills": skills,
        "salary_min": salaryMin,
        "salary_max": salaryMax
      }
    };
print(body);
    try {
      final response = await jobService.getJobsMap(body: body);
      await _handleJobResponse(response);
    } catch (err) {
      isLoading.value = false;
      debugPrint("Fetch jobs error: $err");
    }
  }

  Future<void> _handleJobResponse(JobResponse response) async {
    markers.clear();
    if (response.status == "success") {
      clusterList.value = response.clusters;
      groupedDetails.value = response.groupedDetails;
      await updateMarkers();
    }
    isLoading.value = false;
  }

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
            _showJobDetailsBottomSheet(cluster.groupId);
          },
        ),
      );
    }
    markers.assignAll(newMarkers);
    markers.refresh();
  }

  Future<BitmapDescriptor> _createCustomMarkerIcon(String label, Color color) async {
    const double width = 34;
    const double height = 42;
    const double radius = 10;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    final paint = ui.Paint()
      ..color = color
      ..style = ui.PaintingStyle.fill;

    final whitePaint = ui.Paint()
      ..color = Colors.white
      ..style = ui.PaintingStyle.fill;

    final centerX = width / 2;
    final centerY = radius;

    // Pin shape - Single continuous path to ensure no transparency gaps
    final path = ui.Path();
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
        text: label,
        style: TextStyle(
          color: color,
          fontSize: (label.length >= 2 ? 10 : 12),
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, ui.Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2));

    final img = await recorder.endRecording().toImage(width.toInt(), height.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  void _showJobDetailsBottomSheet(String groupId) {
    final jobs = groupedDetails[groupId] ?? [];
    Get.bottomSheet(
      JobDetailsBottomSheet(users: jobs),
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

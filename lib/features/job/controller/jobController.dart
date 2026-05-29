import 'dart:async';
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

  /// Manages the debounced search logic
  void _setupSearchDebounce() {
    debounce(searchQuery, (String value) {
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
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const size = Size(50, 70);

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
        style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, (size.width / 2 - textPainter.height / 2)));

    final img = await pictureRecorder.endRecording().toImage(size.width.toInt(), size.height.toInt());
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

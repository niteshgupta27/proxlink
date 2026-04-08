import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proxlink/Utill/Apputills.dart';
import 'package:proxlink/Utill/app_storage.dart';
import 'package:proxlink/features/zone/service/zone_service.dart';

class CreateZoneController extends GetxController {
  final appStorage = Get.find<AppStorage>();
  final zoneService = Get.find<ZoneService>();

  final nameController = TextEditingController();
  final purposeController = TextEditingController();
  final skillController = TextEditingController();
  final locationController = TextEditingController().obs;
   // Reactive string for location

  var skills = <String>[].obs;
  var moveWithOwner = false.obs;
  var isLoading = false.obs;

  var selectedLat = 0.0.obs;
  var selectedLng = 0.0.obs;
  var selectedAddress = "".obs;

  @override
  void onInit() {
    super.onInit();
    // Set default location to current location if available
    selectedLat.value = appStorage.current_lat.value;
    selectedLng.value = appStorage.current_lng.value;
  }

  void addSkill(String skill) {
    if (skill.isNotEmpty && !skills.contains(skill)) {
      skills.add(skill);
      skillController.clear();
    }
  }

  void removeSkill(String skill) {
    skills.remove(skill);
  }

  Future<void> createZone() async {
    if (nameController.text.isEmpty || purposeController.text.isEmpty || skills.isEmpty || selectedLat.value == 0) {
      AppUtils.showSnackbar("Please fill all fields and select location", "Error");
      return;
    }

    isLoading.value = true;

    final body = {
      "user_id": appStorage.loggedInUserId ?? 786,
      "api_key": appStorage.loggedInUserToken.isNotEmpty ? appStorage.loggedInUserToken : "API_KEY",
      "payload": {
        "name": nameController.text,
        "purpose": purposeController.text,
        "skills": skills.toList(),
        "lat": selectedLat.value,
        "lng": selectedLng.value,
        "move_with_owner": moveWithOwner.value ? 1 : 0
      }
    };

    try {
      final response = await zoneService.createZone(body: body);
      if (response['status'] == 'success') {
        Get.back(result: true);
        AppUtils.showSnackbar(response['message'] ?? "Zone created successfully", "Success");
      } else {
        AppUtils.showSnackbar(response['message'] ?? "Failed to create zone", "Error");
      }
    } catch (e) {
      AppUtils.showSnackbar("Something went wrong", "Error");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    purposeController.dispose();
    skillController.dispose();
    locationController.value.dispose();
    super.onClose();
  }
}

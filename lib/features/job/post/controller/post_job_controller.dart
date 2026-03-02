import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Utill/Apputills.dart';
import '../../../../Utill/app_storage.dart';
import '../../services/jobService.dart';

class PostJobController extends GetxController {
  final jobService = Get.find<JobService>();
  final appStorage = Get.find<AppStorage>();

  final companyNameController = TextEditingController();
  final jobTitleController = TextEditingController();
  final experienceController = TextEditingController();
  final educationController = TextEditingController();
  final salaryController = TextEditingController();
  final skillInputController = TextEditingController();
  final officeLocationController = TextEditingController();

  var selectedJobType = 'Full Time'.obs;
  var skills = <String>[].obs;
  var isLoading = false.obs;

  void addSkill(String skill) {
    String trimmedSkill = skill.trim();
    if (trimmedSkill.isNotEmpty) {
      if (skills.length >= 5) {
        AppUtils.showSnackbar("Error", "You can only add up to 5 skills.");
        return;
      }
      if (!skills.contains(trimmedSkill)) {
        skills.add(trimmedSkill);
        skillInputController.clear();
      } else {
        AppUtils.showSnackbar("Info", "Skill already added.");
      }
    }
  }

  void removeSkill(String skill) {
    skills.remove(skill);
  }

  Future<void> submitJob() async {
    if (!_validateFields()) return;

    isLoading.value = true;

    final body = {
      "api_key": appStorage.loggedInUserToken,
      "user_id": appStorage.loggedInUserId?.toString() ?? "0",
      "payload": {
        "address": officeLocationController.text,
        "city": "", // Can be extracted if needed
        "company_name": companyNameController.text,
        "description": "", // Add a controller if description is needed
        "experience_max": "", 
        "experience_min": experienceController.text,
        "job_type": selectedJobType.value,
        "lat": appStorage.current_lat.value.toString(),
        "lng": appStorage.current_lng.value.toString(),
        "profession": "", 
        "salary_currency": "INR",
        "salary_max": "",
        "salary_min": salaryController.text,
        "skills": skills.join(","),
        "state": "",
        "title": jobTitleController.text
      }
    };

    try {
      final response = await jobService.postJob(body: body);
      print("object${response.status}");
      if (response.status == "success") {
        Get.back();
        AppUtils.showSnackbar("Success", "Job posted successfully");

      } else {
        AppUtils.showSnackbar("Error",  "Failed to post job");
      }
    } catch (err) {
      AppUtils.showSnackbar("Error", "Something went wrong: $err");
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateFields() {
    if (companyNameController.text.isEmpty) {
      AppUtils.showSnackbar("Error", "Please enter company name");
      return false;
    }
    if (jobTitleController.text.isEmpty) {
      AppUtils.showSnackbar("Error", "Please enter job title");
      return false;
    }
    if (experienceController.text.isEmpty) {
      AppUtils.showSnackbar("Error", "Please enter experience");
      return false;
    }
    if (educationController.text.isEmpty) {
      AppUtils.showSnackbar("Error", "Please enter education");
      return false;
    }
    if (salaryController.text.isEmpty) {
      AppUtils.showSnackbar("Error", "Please enter salary");
      return false;
    }
    if (skills.isEmpty) {
      AppUtils.showSnackbar("Error", "Please add at least one skill");
      return false;
    }
    if (officeLocationController.text.isEmpty) {
      AppUtils.showSnackbar("Error", "Please enter office location");
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    companyNameController.dispose();
    jobTitleController.dispose();
    experienceController.dispose();
    educationController.dispose();
    salaryController.dispose();
    skillInputController.dispose();
    officeLocationController.dispose();
    super.onClose();
  }
}

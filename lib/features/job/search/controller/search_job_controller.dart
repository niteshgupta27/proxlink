import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchJobController extends GetxController {
  // Job Type
  var selectedJobType = 'Full Time'.obs;

  // Job Title
  final jobTitleController = TextEditingController();

  // Experience & Education
  var selectedExperience = RxnString();
  var selectedEducation = RxnString();
  final List<String> experienceOptions = ['0-1 years', '2-3 years', '4-5 years', '5+ years'];
  final List<String> educationOptions = ['High School', 'Bachelor\'s', 'Master\'s', 'PhD'];

  // Salary Expectation
  var salaryRange = const RangeValues(50000, 80000).obs;

  // Skill Sets
  var skills = <String>[
    'Java',
    '.NET',
    'Marketing',
    'Prompt Expert',
    'Digital Marketing',
    'CRM'
  ].obs;
  final skillInputController = TextEditingController();

  void addSkill(String skill) {
    if (skill.isNotEmpty && !skills.contains(skill)) {
      skills.add(skill);
      skillInputController.clear();
    }
  }

  void removeSkill(String skill) {
    skills.remove(skill);
  }

  // Work Location
  var selectedWorkLocation = 'WFH'.obs;

  void applyFilter() {
    Map<String, dynamic> filters = {
      "job_type": selectedJobType.value,
      "keywords": jobTitleController.text,
      "experience": selectedExperience.value ?? "",
      "education": selectedEducation.value ?? "",
      "salary_min": salaryRange.value.start.toString(),
      "salary_max": salaryRange.value.end.toString(),
      "skills": skills.join(","),
      "work_location": selectedWorkLocation.value,
    };
    Get.back(result: filters);
  }

  @override
  void onClose() {
    jobTitleController.dispose();
    skillInputController.dispose();
    super.onClose();
  }
}

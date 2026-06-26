import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchJobController extends GetxController {
  // Job Type
  var selectedJobType = 'Full Time'.obs;

  // Job Title
  final jobTitleController = TextEditingController();
  var searchQuery = "".obs;
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
    jobTitleController.addListener(() {
      searchQuery.value = jobTitleController.text;
    });
    _setupSearchDebounce();
  }

  void selectSuggestion(String suggestion) {
    _isSelection = true;
    jobTitleController.text = suggestion;
    showSuggestions.value = false;
  }

  void _setupSearchDebounce() {
    debounce(searchQuery, (String value) {
      if (_isSelection) {
        _isSelection = false;
        showSuggestions.value = false;
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
    }, time: const Duration(milliseconds: 600));
  }

  // Experience & Education
  var selectedExperience = RxnString();
  var selectedEducation = RxnString();
  final List<String> experienceOptions = ['0-1 years', '2-3 years', '4-5 years', '5+ years'];
  final List<String> educationOptions = ['High School', 'Bachelor\'s', 'Master\'s', 'PhD'];

  // Salary Expectation
  var salaryRange = const RangeValues(50000, 80000).obs;

  // Skill Sets
  var skills = <String>[].obs;
  final skillInputController = TextEditingController();
  final skillFocusNode = FocusNode();

  @override
  void onReady() {
    super.onReady();
    if (skills.isEmpty) {
      skillFocusNode.requestFocus();
    }
  }

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


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../Utill/AppConstants.dart';
import '../../../../Utill/Apputills.dart';

import '../../../../Utill/app_storage.dart';
import '../../../../routes/app_pages.dart';
import '../../services/auth_services.dart';

class SignUpController extends GetxController {
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();

  RxString gender = "Male".obs;
  RxString profession = "Working Professional".obs;
  RxString organization = "Company Name / College Name".obs;

  RxBool agree = false.obs;

  final formKey = GlobalKey<FormState>();

  void submit() {
    if (!agree.value) {
      Get.snackbar("Error", "Please accept Terms & Conditions");
      return;
    }
    if (formKey.currentState!.validate()) {
      Get.offNamed(Routes.BOTTOM_NAVIGATION ); // change route
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    super.onClose();
  }}
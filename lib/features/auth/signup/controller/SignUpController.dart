

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../Utill/AppConstants.dart';
import '../../../../Utill/Apputills.dart';

import '../../../../Utill/app_storage.dart';
import '../../../../main.dart';
import '../../../../routes/app_pages.dart';
import '../../services/auth_services.dart';

class SignUpController extends GetxController {
  final professionCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final organizationCtrl = TextEditingController();
  RxBool isLoading = false.obs;

  RxString gender = "Male".obs;
  RxString profession = "Working Professional".obs;
  var appStorage = Get.find<AppStorage>();

  RxBool agree = false.obs;

  final formKey = GlobalKey<FormState>();
  var loginServices = Get.find<AuthServices>();

  @override
  void onInit() {
    super.onInit();
    if (Get.parameters['name'] != null) {
      nameCtrl.text = Get.parameters['name']!;
    }
  }

  void submit() {
    if (!agree.value) {
      Get.snackbar("Error", "Please accept Terms & Conditions");
      return;
    }
    if (formKey.currentState!.validate()) {
      register(); // change route
    }
  }
  Future<void> register() async {
    isLoading.value = true;

    var requestBody = {
      "api_key": appStorage.loggedInUserToken,
      "user_id": appStorage.loggedInUserId?.toString() ?? "0",
      "payload": {
        "age": ageCtrl.text.toString(),
        "full_name": nameCtrl.text.toString(),
        "gender": gender.value,
        "organization_name": organizationCtrl.text.toString(),
        "profession": professionCtrl.text.toString(),
        "terms_accepted": agree.value,
        "user_category":profession.value
      }
    };

    loginServices.register(body: requestBody).then((value) async {
      isLoading.value = false;
      if (value.status == "success") {

       // appStorage.loggedInUserToken = value.apiKey!;
        await appStorage.write(AppConstants.loginUserInformationToken, appStorage.loggedInUserToken);
       // appStorage.loggedInUserId = value.userId;
        await appStorage.write(AppConstants.loginUserId, appStorage.loggedInUserId);
        initializeService();
        Get.offAllNamed(Routes.BOTTOM_NAVIGATION);
      } else {
        AppUtils.showSnackbar(value.message ?? "Authentication failed", "Info");
      }
    }).catchError((err) {
      isLoading.value = false;
      AppUtils.showSnackbar("Something went wrong", "Oops");
    });
  }

  @override
  void onClose() {
    professionCtrl.dispose();
    nameCtrl.dispose();
    ageCtrl.dispose();
    organizationCtrl.dispose();
    super.onClose();
  }
}
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../Utill/Images.dart';
import '../../../Utill/app_colors.dart';
import '../controller/SplashController.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing 'controller' here triggers Get.lazyPut if it hasn't been created yet.
    // This will cause SplashController's onInit to run.
    final _ = controller; 

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SizedBox.expand(
        child: Image.asset(
          Images.networkbg,
          filterQuality: FilterQuality.high,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

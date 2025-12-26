import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:proxlink/features/discovery/controller/discoveryController.dart';

import '../../../Utill/Images.dart';
import '../../../Utill/app_colors.dart';
import '../../../Utill/app_required.dart';
import '../../../common/widget/custom_loader_widget.dart';
import '../controller/jobController.dart';



class JobView extends GetView<JobController> {
  const JobView({super.key});

  @override
  Widget build(BuildContext context) {

    return Obx(()=>Scaffold(
      backgroundColor: AppColors.primaryColor,
      body:controller.isLoading==true?  Center(child: CustomLoaderWidget(color: AppColors.primaryColor,)) :SizedBox.expand(
        child:controller.localImagePath.value.isNotEmpty
            ?Image.file(
          File(controller.localImagePath.value),
          filterQuality: FilterQuality.high,
          fit: BoxFit.cover, // Ensures the image covers the entire screen
        )
        : Image.asset(
          Images.splash,
          filterQuality: FilterQuality.high,
          fit: BoxFit.cover, // Ensures the image covers the entire screen
        ),
      ),
    ));
  }
}

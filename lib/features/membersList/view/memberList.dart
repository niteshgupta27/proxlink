import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:proxlink/features/discovery/controller/discoveryController.dart';

import '../../../Utill/AppConstants.dart';
import '../../../Utill/Images.dart';
import '../../../Utill/app_colors.dart';
import '../../../Utill/app_required.dart';
import '../../../common/widget/custom_loader_widget.dart';
import '../controller/memberListController.dart';
import '../model/NetworkModel.dart';



class MemberListview extends GetView<MemberListController> {
  const MemberListview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:AppColors.primaryColor,
        elevation: 0,
        leading: Center(
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              width: 40,  // Increased size; 16 is too small for a finger tap
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_back_ios_new, // "new" version is more centered
                color: AppColors.primaryColor,
               // size: 18, // Smaller icon inside the box
              ),
            ),
          ),
        ),
        title: Text("Members", style: TextStyle(fontSize:22, fontWeight: FontWeight.bold,fontFamily: AppConstants.fontFamily_Acre,color: AppColors.whites)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Text(
              "Select a network to view members",
              style: TextStyle(fontSize:22, fontWeight: FontWeight.bold,fontFamily: AppConstants.fontFamily_Acre,color: AppColors.black),
            ),
          ),
          Expanded(
            child: Obx(() => GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.85,
              ),
              itemCount: controller.networks.length,
              itemBuilder: (context, index) {
                return _buildNetworkCard(controller.networks[index]);
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkCard(NetworkModel network) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1),
        ],
      ),
      child: Column(
        children: [
          // Blue Header with Profile Image
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
              Positioned(
                bottom: -25,
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(network.imageUrl),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 35),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              network.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,fontFamily: AppConstants.fontFamily_Acre),
            ),
          ),
          Spacer(),
          // Footer
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Images.people_outline,
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 5),
                Text("${network.memberCount} Members", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,fontFamily: AppConstants.fontFamily_Acre)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
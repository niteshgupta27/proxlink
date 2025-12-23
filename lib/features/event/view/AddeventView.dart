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
import '../../membersList/model/NetworkModel.dart';
import '../controller/AddeventController.dart';



class AddeventView extends GetView<AddeventController> {
  const AddeventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whites,
      appBar: AppBar(
        backgroundColor:AppColors.primaryColor,
        elevation: 0,
        leading:Center(
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
        title: const Text(
          "Create a Network/Event",
          style: TextStyle(fontSize:22, fontWeight: FontWeight.bold,fontFamily: AppConstants.fontFamily_Acre,color: AppColors.whites),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputSection(),
            const SizedBox(height: 30),
            const Text(
              "Previously hosted Networks/Events",
              style: TextStyle(fontSize:22, fontWeight: FontWeight.bold,fontFamily: AppConstants.fontFamily_Acre,color: AppColors.black),
            ),
            const SizedBox(height: 15),
            _buildPreviousEventsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Network/Event Name", style: TextStyle(fontSize:14, fontWeight: FontWeight.bold,fontFamily: AppConstants.fontFamily_Acre,color: AppColors.black)),
          const SizedBox(height: 8),
          TextField(
            onChanged: (val) => controller.eventName.value = val,
            decoration: InputDecoration(
              hintText: "Type here...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
              style: TextStyle(fontFamily: AppConstants.fontFamily_Acre,fontWeight: FontWeight.normal)

          ),
          const SizedBox(height: 20),
          const Text("Description", style: TextStyle(fontSize:14, fontWeight: FontWeight.bold,fontFamily: AppConstants.fontFamily_Acre,color: AppColors.black)),
          const SizedBox(height: 8),
          TextField(
            maxLines: 4,
            onChanged: (val) => controller.description.value = val,
            decoration: InputDecoration(
              hintText: "Type here...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
              style: TextStyle(fontFamily: AppConstants.fontFamily_Acre,fontWeight: FontWeight.normal)
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousEventsList() {
    // 1. Remove Expanded (it causes the error inside a ScrollView)
    return Obx(() => GridView.builder(
      // 2. Add shrinkWrap so the GridView only takes the height it needs
      shrinkWrap: true,
      // 3. Disable internal scrolling so it works smoothly with the parent SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 4), // Adjusted for balance
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.75, // Adjusted to prevent overflow within the card
      ),
      itemCount: controller.networks.length,
      itemBuilder: (context, index) {
        return _buildNetworkCard(controller.networks[index]);
      },
    ));
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
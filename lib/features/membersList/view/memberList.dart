import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../Utill/AppConstants.dart';
import '../../../Utill/Images.dart';
import '../../../Utill/app_colors.dart';
import '../../discovery/model/discovery_Model.dart';
import '../../Chat/controller/chatController.dart';
import '../controller/memberListController.dart';

class MemberListview extends GetView<MemberListController> {
  const MemberListview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        toolbarHeight: 80,
        leadingWidth: 70,
        leading: Center(
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          "${controller.networkname} - Members",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontFamily_Acre,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 25),
          //   child: Text(
          //     "Select a network to view members",
          //     style: TextStyle(
          //       fontSize: 20,
          //       fontWeight: FontWeight.w800,
          //       fontFamily: AppConstants.fontFamily_Acre,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.networks.length,
                  itemBuilder: (context, index) {
                    return _contactCard(controller.networks[index]);
                  },
                )),
          ),
        ],
      ),
    );
  }
  Widget _contactCard(GroupedUser user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(color: AppColors.black,fontFamily: AppConstants.fontFamily_Acre,fontSize: 18,fontWeight: FontWeight.w600)),
                Text(user.profession, style: const TextStyle(color: AppColors.black,fontFamily: AppConstants.fontFamily_Acre,fontSize: 14,fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          InkWell(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.3),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: SvgPicture.asset(Images.chatsheet),
            ),
            onTap: () => Get.find<ChatController>().navigateToChat(
              otherUserId: user.userId,
              otherUserName: user.name,
            ),
          ),
        ],
      ),
    );
  }
}

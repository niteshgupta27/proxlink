import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_colors.dart';
import '../../../common/widget/custom_loader_widget.dart';
import '../../../routes/app_pages.dart';
import '../../membersList/model/NetworkModel.dart';
import '../controller/eventlistController.dart';


class EventListview extends GetView<EventListController> {
  const EventListview({super.key});

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
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
          ),
        ),
        title: const Text(
          "Members",
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Text(
              "Select a network to view members",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: AppConstants.fontFamily_Acre,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Obx(() => controller.isLoading ==true? Center(child: CustomLoaderWidget(color:AppColors.primaryColor ,)):ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.networks.length,
              itemBuilder: (context, index) {
                return _buildNetworkCard(controller.networks[index]);
              },
            )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkCard(NetworkModel network) {
    return InkWell(child: Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Top section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor, // Blue circle color
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.groups,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        network.name ?? "",
                        style: const TextStyle(
                          fontSize: 16,fontFamily: AppConstants.fontFamily_Acre,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        network.description ?? "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy",
                        style: const TextStyle(
                          fontSize: 12,fontFamily: AppConstants.fontFamily_Acre,
                          color: Colors.black54,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom section (Blue)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Members",
                      style: TextStyle(
                        fontSize: 11,fontFamily: AppConstants.fontFamily_Acre,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      "${network.totalMembers ?? 0} members",
                      style: const TextStyle(
                        fontSize: 14,fontFamily: AppConstants.fontFamily_Acre,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                // Overlapping avatars
                SizedBox(
                  width: 80,
                  height: 30,
                  child: Stack(
                    children: [
                      const Positioned(
                        right: 40,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundImage: NetworkImage("https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjUM6RjCVFkhLB_YuYGcuV2lw8Zukn6VASqzKRwM4klEhdfbGfJomXQ3oRDHurkHuHf9IaEhRkx2iYblYIlMTJgPiSfPkxndw6yuwKN8EZGDzzqHcoBoTj2Hf-iDEiZLDM8mEwjvp0Br7Ar/s1600/digital+painting+of+avtar.jpg"),
                          ),
                        ),
                      ),
                      const Positioned(
                        right: 25,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundImage: NetworkImage("https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjUM6RjCVFkhLB_YuYGcuV2lw8Zukn6VASqzKRwM4klEhdfbGfJomXQ3oRDHurkHuHf9IaEhRkx2iYblYIlMTJgPiSfPkxndw6yuwKN8EZGDzzqHcoBoTj2Hf-iDEiZLDM8mEwjvp0Br7Ar/s1600/digital+painting+of+avtar.jpg"),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC0DAFF),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "+42",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1877F2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),onTap: (){
      Get.toNamed(Routes.memebersList,arguments: {"network_id":network.networkId,"view_as":controller.view_as.value});
    },);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proxlink/Utill/AppConstants.dart';
import 'package:proxlink/Utill/app_colors.dart';
import 'package:proxlink/features/zone/controller/my_zones_controller.dart';
import '../../../routes/app_pages.dart';
import '../model/MyZoneListResponse.dart';

class MyZonesView extends GetView<MyZonesController> {
  const MyZonesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        toolbarHeight: 100,
        leadingWidth: 70,
        leading: Center(
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              width: 45,
              height: 45,
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
        ),centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Text(
              controller.title.value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: AppConstants.fontFamily_Acre,
                color: Colors.white,
              ),
            )),
            Obx(() => Text(
              "${controller.type.value == 'membership' ? 'Membership' : 'Ownership'} : ${controller.zoneList.length}",
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppConstants.fontFamily_Acre,
                color: Colors.white70,
              ),
            )),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.black54),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search Jobs",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: AppConstants.fontFamily_Acre,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
              }
              if (controller.zoneList.isEmpty) {
                return const Center(
                  child: Text(
                    "No zones found",
                    style: TextStyle(fontFamily: AppConstants.fontFamily_Acre),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: controller.zoneList.length,
                itemBuilder: (context, index) {
                  final zone = controller.zoneList[index];
                  return _buildZoneCard(zone);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneCard(ZoneList zone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => Get.toNamed(Routes.ZoneDetails, arguments: zone),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zone.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: AppConstants.fontFamily_Acre,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildChip("${zone.membersCount ?? 0} members"),
                      const SizedBox(width: 10),
                      _buildChip("0.0 KMs"),
                    ],
                  ),
                  const SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: AppConstants.fontFamily_Acre,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: (zone.purpose ?? '').length > 100 
                              ? "${(zone.purpose ?? '').substring(0, 100)}... " 
                              : "${zone.purpose ?? ''} ",
                        ),
                        const TextSpan(
                          text: "Read More",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: const BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(Icons.group, "View Members", onTap: () {
                    Get.toNamed(Routes.memebersList, arguments: zone.zoneId.toString());
                  }),
                  _buildActionButton(Icons.chat_bubble_outline, "Chat"),
                  _buildActionButton(Icons.share_outlined, "Share"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: AppConstants.fontFamily_Acre,
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 18),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: AppConstants.fontFamily_Acre,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

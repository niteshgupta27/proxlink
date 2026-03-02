import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proxlink/Utill/AppConstants.dart';
import 'package:proxlink/Utill/Dimensions.dart';
import 'package:proxlink/Utill/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controller/zone_controller.dart';

class ZoneView extends GetView<ZoneController> {
  const ZoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        toolbarHeight: 60,
        centerTitle: false,
        title: const Text(
          "Zone Near You",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontFamily_Acre,
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // Action for Post Jobs
              Get.toNamed(Routes.post_job);
            },
            child: Container(
              height: 55,
              margin: const EdgeInsets.symmetric(horizontal: 14,vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.whites,
                borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 7),

                  const Text(
                    "Create Zone",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.fontFamily_Acre,
                    ),
                  ),const SizedBox(width: 7),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          Obx(() => GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    controller.appStorage.current_lat.value,
                    controller.appStorage.current_lng.value,
                  ),
                  zoom: 14,
                ),
                markers: controller.markers,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: controller.onMapCreated,
              )),

          // Top Buttons (Membership & Ownership)
          Positioned(
            top:  10,
            left: 15,
            right: 15,
            child: Row(
              children: [
                Expanded(
                  child: _buildTopButton(
                    "Membership : ${controller.membershipCount.value}",
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildTopButton(
                    "Ownership : ${controller.ownershipCount.value}",
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),

          // Search Bar & Show List
          Positioned(
            top:  75,
            left: 15,
            right: 15,
            child: Row(
              children: [
                // Search Bar
                Expanded(
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: AppColors.Dar_Charcoal),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search Jobs",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: AppColors.textGrayColor,
                                fontFamily: AppConstants.fontFamily_Acre,
                                fontSize: Dimensions.fontSizeLarge,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Show List Button
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.format_list_bulleted, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        "Show List",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppConstants.fontFamily_Acre,
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
    );
  }

  Widget _buildTopButton(String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontFamily_Acre,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

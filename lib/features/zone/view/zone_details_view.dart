import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proxlink/Utill/AppConstants.dart';
import 'package:proxlink/Utill/app_colors.dart';
import '../controller/zone_details_controller.dart';

class ZoneDetailsView extends GetView<ZoneDetailsController> {
  const ZoneDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
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
        ),
        title: const Text(
          "Zone Detials",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontFamily_Acre,
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ElevatedButton(
              onPressed: () => controller.joinZone(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Join Zone",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontFamily_Acre,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.detailResponse.value?.zone?.name == null) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final zone = controller.detailResponse.value?.zone;
        if (zone == null) {
          return const Center(
            child: Text(
              "No details found",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Map Marker Icon with Rings
                    _buildMapMarkerWithRings(),
                    const SizedBox(height: 30),
                    
                    // Title
                    Text(
                      zone.name ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConstants.fontFamily_Acre,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        zone.purpose ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                          fontFamily: AppConstants.fontFamily_Acre,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Creator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person, color: Colors.white, size: 24),
                        const SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Create By : ",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 16,
                                  fontFamily: AppConstants.fontFamily_Acre,
                                ),
                              ),
                              const TextSpan(
                                text: "Rahul Shoil", // You can use data from API if available
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppConstants.fontFamily_Acre,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    
                    // Members Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
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
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontFamily: AppConstants.fontFamily_Acre,
                                ),
                              ),
                              Text(
                                "${zone.membersCount ?? 0} members",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppConstants.fontFamily_Acre,
                                ),
                              ),
                            ],
                          ),
                          _buildMemberAvatars(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // Bottom Join Button
            Container(
              width: double.infinity,
              height: 70,
              color: Colors.white,
              child: TextButton(
                onPressed: () => controller.joinZone(),
                child: controller.isLoading.value 
                  ? const CircularProgressIndicator(color: AppColors.primaryColor)
                  : Text(
                      controller.detailResponse.value?.isMember == 1 ? "Exit Zone" : "Join Zone",
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConstants.fontFamily_Acre,
                      ),
                    ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMapMarkerWithRings() {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Rings
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          // Inner White Circle
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(
              Icons.location_on,
              color: AppColors.primaryColor,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberAvatars() {
    return SizedBox(
      width: 100,
      height: 40,
      child: Stack(
        children: [
          _avatar(0, "https://i.pravatar.cc/150?u=1"),
          _avatar(25, "https://i.pravatar.cc/150?u=2"),
          Positioned(
            left: 50,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              alignment: Alignment.center,
              child: const Text(
                "+42",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(double left, String url) {
    return Positioned(
      left: left,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

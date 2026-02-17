import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proxlink/Utill/app_colors.dart';
import '../../../Utill/AppConstants.dart';
import '../../../Utill/Images.dart';
import '../../../common/widget/custom_loader_widget.dart';
import '../controller/discoveryController.dart';
import '../model/discovery_Model.dart';

class DiscoveryView extends GetView<DiscoveryController> {
  DiscoveryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        toolbarHeight: 50,
        leadingWidth: 70,

        title: Text(
          "Discovery",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontFamily_Acre,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Google Map
          Obx(() => GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                controller.appStorage.current_lat.value,
                controller.appStorage.current_lng.value
              ),
              zoom: 18
            ),
            markers: controller.markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController mapController) {
              // You can store mapController if needed
            },
          )),

          // Loading Indicator
          Obx(() => controller.isLoading.value
              ?  Center(child: CustomLoaderWidget(color:AppColors.primaryColor))
              : const SizedBox.shrink()),

          // Search Bar Overlay
          Positioned(
            top: 10,
            left: 20,
            right: 20,
            child:Column(children: [Text(
              "Professionals near you",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: AppConstants.fontFamily_Acre,
                color: AppColors.black,
              ),
            ),SizedBox(height: 10,),Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.Dar_Charcoal),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller.searchTextController,
                      onChanged: (value) => controller.searchProfession.value = value,
                      decoration: const InputDecoration(
                        hintText: "Search by profession, skill",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: AppColors.Dar_Charcoal,
                          fontFamily: AppConstants.fontFamily_Acre,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: const TextStyle(
                        color: AppColors.Dar_Charcoal,
                        fontFamily: AppConstants.fontFamily_Acre,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),],)
          ),
        ],
      ),
    );
  }
}

class ContactBottomSheet extends StatelessWidget {
  final List<GroupedUser> users;
  const ContactBottomSheet({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Contacts Available (${users.length})",
                  style: const TextStyle(color: AppColors.black,fontFamily: AppConstants.fontFamily_Acre,fontSize: 18,fontWeight: FontWeight.w600)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Contact List
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                return _contactCard(users[index]);
              },
            ),
          ),
          const SizedBox(height: 20),
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
                Text(user.profession, style: const TextStyle(color: AppColors.black,fontFamily: AppConstants.fontFamily_Acre,fontSize: 18,fontWeight: FontWeight.w600)),
                Text("${user.age}, ${user.gender}, ${user.companyname}", style: const TextStyle(color: AppColors.black,fontFamily: AppConstants.fontFamily_Acre,fontSize: 14,fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.3),
              shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0)
            ),
            child: SvgPicture.asset(Images.chatsheet,),
          )
        ],
      ),
    );
  }
}

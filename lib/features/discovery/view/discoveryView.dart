import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proxlink/Utill/app_colors.dart';
import '../../../Utill/AppConstants.dart';
import '../../../Utill/Images.dart';
import '../controller/discoveryController.dart';

class DiscoveryView extends GetView<DiscoveryController> {
  DiscoveryView({super.key});

  final LatLng center = const LatLng(12.9716, 77.5946);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          Obx(() => GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(13.0827, 80.2707), zoom: 14),
            markers: controller.markers.value,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          )),

          // Search Bar Overlay
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Container(
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColors.Dar_Charcoal),
                  SizedBox(width: 10),
                  Text("Search Profession here", style: TextStyle(color: AppColors.Dar_Charcoal,fontFamily: AppConstants.fontFamily_Acre,fontSize: 14,fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
class ContactBottomSheet extends StatelessWidget {
  final String count;
  const ContactBottomSheet({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Contacts Available ($count)",
                  style:  TextStyle(color: AppColors.black,fontFamily: AppConstants.fontFamily_Acre,fontSize: 18,fontWeight: FontWeight.w600)),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Contact List
          ...List.generate(3, (index) => _contactCard()),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _contactCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(15),
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
                Text("Software Engineer", style: TextStyle(color: AppColors.black,fontFamily: AppConstants.fontFamily_Acre,fontSize: 18,fontWeight: FontWeight.w600)),
                Text("25, Tech Solution", style: TextStyle(color: AppColors.black,fontFamily: AppConstants.fontFamily_Acre,fontSize: 14,fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
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
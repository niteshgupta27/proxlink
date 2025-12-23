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
import '../../../routes/app_pages.dart';
import '../controller/NetworkController.dart';



class NetworkView extends GetView<NetworkController> {
  const NetworkView({super.key});


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [Color(0xFF0066FF), Color(0xFF0044CC)],
          //   ),
          // ),
          child: Stack(
            children: [
              // Background Globe Image
              // Positioned(
              //   bottom: -50,
              //   left: 0,
              //   right: 0,
              //   child:Image.asset(
              //     Images.networkbg, // Replace with your asset
              //     fit: BoxFit.cover,
              //   ),
              // ),
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Images.networkbg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            _buildSectionHeader("Your networks as a Guest"),
                            _buildMenuCard([
                              _buildMenuItem(Images.qr_code_scanner, "Scan to Join","0"),
                              _buildMenuItem(Images.people_outline, "Network members","1"),
                            ]),
                            SizedBox(height: 30),
                            _buildSectionHeader("Your networks as a Host"),
                            _buildMenuCard([
                              _buildMenuItem(Images.calendar_today_outlined, "Create a Network / Event","2"),
                              _buildMenuItem(Images.event_note, "Past Networks / Events","3"),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

      );
    }

    Widget _buildHeader() {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  Images.logo,
                  width: 41,
                  height: 41,
                ),
                const SizedBox(width: 8),
                const Text(
                  'ProxiLink',
                  style: TextStyle(
                    fontFamily: AppConstants.fontFamily_ADLaM_Display,
                    fontSize: 23,
                    fontWeight: FontWeight.normal,
                    color: AppColors.whites,
                    height: 1.6,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.notifications, color: AppColors.primaryColor),),
                SizedBox(width: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: AppColors.primaryColor, size: 20),
                      SizedBox(width: 5),
                      Text("John", style: TextStyle(fontFamily: AppConstants.fontFamily_Acre,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                      Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      );
    }

    Widget _buildSectionHeader(String title) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: AppColors.whites,fontFamily: AppConstants.fontFamily_Acre,
                fontSize: 14,
                fontWeight: FontWeight.normal),
            children: [
              TextSpan(text: title.split(" ").sublist(0, title.split(" ").length - 1).join(" ") + " "),
              TextSpan(text: title.split(" ").last, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    }

    Widget _buildMenuCard(List<Widget> children) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.whites,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(children: children),
      );
    }

    Widget _buildMenuItem(String icon, String title,String Actioncode) {
      return InkWell(child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
            ),
            // Icon(icon, color: AppColors.primaryColor, size: 28),
            SizedBox(width: 15),
            Expanded(child: Text(title, style: TextStyle(fontSize: 16,fontFamily: AppConstants.fontFamily_Acre,

                fontWeight: FontWeight.w500))),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(5)),
              child: Icon(Icons.arrow_forward, color: Colors.white, size: 18),
            )
          ],
        ),
      ),onTap: (){
        if(Actioncode=="0"){
          _showCustomBottomSheet(Get.context!);
        }else if(Actioncode=="1"){
          Get.toNamed(Routes.memebersList);

        }else if(Actioncode=="2"){
          Get.toNamed(Routes.Addevent);

        }
      },);
    }
  void _showCustomBottomSheet(BuildContext context) {
      String title="Your networks as a Guest";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to expand beyond half-screen
      backgroundColor: Colors.transparent, // Required if you want custom shapes/blur
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Fits the sheet to its content
          children: [
            // Drag Handle (The little bar at the top)
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(title, style: TextStyle(fontSize: 22,fontFamily: AppConstants.fontFamily_Acre,

                fontWeight: FontWeight.w600)
          )),


            Container(width: 373,height: 368,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.qr),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (){
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: const Text("Scan to join the network", style:
                  const TextStyle(fontSize:18, fontWeight: FontWeight.bold,fontFamily: AppConstants.fontFamily_Acre)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  }

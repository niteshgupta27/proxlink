import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:proxlink/Utill/AppConstants.dart';
import 'package:proxlink/Utill/Apputills.dart';
import '../../../Utill/Dimensions.dart';
import '../../../Utill/Images.dart';
import '../../../Utill/app_colors.dart';
import '../../../Utill/app_required.dart';
import '../../../Utill/app_storage.dart';
import '../../../main.dart';
import '../controllers/bottom_navigation_controller.dart';

class BottomNavigationView extends GetView<BottomNavigationController> {
  Widget? child;
  final appStorage = Get.find<AppStorage>();
  BottomNavigationView({super.key, this.child});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:LayoutBuilder(
            builder: (context, constraints) {
              // 👈 same breakpoint
             return  Navigation_for_mobile(context);})
    );
  }
  Widget Navigation_for_mobile(BuildContext context){
    return Obx(
          () => Scaffold(backgroundColor:AppColors.primaryColor,
        body: child ?? controller.pages[controller.currentIndex],
        bottomNavigationBar: Container(
            decoration: BoxDecoration(color: AppColors.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Shadow color
                  offset: Offset(0, -3), // Offset to show shadow at the top
                  blurRadius: 6, // Blur for the shadow
                ),
              ],
            ),
            child:   BottomNavigationBar(backgroundColor:  AppColors.primaryColor,
                    currentIndex: controller.currentIndex,
                    items: [

                      _buildNavItem(
                        context,
                        iconPath: Images.Discover,
                        label: 'Discover',
                        index: 0,
                      ),
                      _buildNavItem(
                        context,
                        iconPath: Images.Network,
                        label: 'Network',
                        index: 1,
                      ),
                      _buildNavItem(
                        context,
                        iconPath: Images.Jobs,
                        label: 'Jobs',
                        index: 2,
                      ),
                      _buildNavItem(
                        context,
                        iconPath: Images.chat,
                        label: 'Chat',
                        index: 3,
                      ),
                    ],
                    selectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: Dimensions.fontSizeDefault,
                      fontFamily: AppConstants.fontFamily_Acre
                    ),
                    selectedItemColor: AppColors.whites,
                    type: BottomNavigationBarType.fixed,
                    unselectedItemColor: AppColors.whites,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    selectedFontSize: 18,
                    unselectedFontSize: 14,
                    unselectedLabelStyle:  TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: Dimensions.fontSizeDefault,
                        fontFamily: AppConstants.fontFamily_Acre
                    ),
                    onTap: (v) async {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      child = null;
                      controller.changeIndex(v);
                    },
                  )
        ),
      ),
    );
  }

  /// Build Bottom Navigation Item with Active Line
  BottomNavigationBarItem _buildNavItem(
      BuildContext context, {
        required String iconPath,
        required String label,
        required int index,
      }) {
    bool isActive = controller.currentIndex == index;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: isActive ? AppColors.whites : AppColors.whites.withOpacity(0.1),
              borderRadius: BorderRadius.circular(22.5),
            ),child:Padding(padding: EdgeInsets.all(10),child: SvgPicture.asset(
            iconPath,
            color: isActive
                ? AppColors.primaryColor
                : AppColors.whites,
          ),)
          ),
          const SizedBox(height: 4),

          // Icon

        ],
      ),
      label: label,
    );
  }


}

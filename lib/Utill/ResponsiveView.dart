import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:proxlink/Utill/Apputills.dart';
import 'app_required.dart';
import 'package:universal_html/html.dart' as html;

class ResponsiveView {
static double webwidth=1300;
  static bool isMobilePhone() {
    if (!kIsWeb) {
      return true;
    }else {
      return false;
    }
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isMobile() {
    final size = MediaQuery.of(Get.context!).size.width;
   // print("ddssdsdsdsdsdsdsdsd$size");
    if (size < 600) {
      //print("size $size true");
      return true;
    } else {
      //print("size $size false");
      return false;
    }
  }

  static bool isTab(context) {
    final size = MediaQuery
        .of(context)
        .size
        .width;
    if (size < 1300 && size >= 660) {
      return true;
    } else {
      return false;
    }
  }

  static bool isDesktop(context) {
    final size = MediaQuery
        .of(context)
        .size
        .width;
    if (size >= 1300) {
      return true;
    } else {
      return false;
    }
  }

  static void showDialogOrBottomSheet(BuildContext context, Widget view, {bool isScrollControlled = false}) {
    if(ResponsiveView.isDesktop(context)) {
      showDialog(context: context, builder: (ctx)=> view);
    }else{
      showModalBottomSheet(backgroundColor: Colors.transparent, isScrollControlled: isScrollControlled, context: context, builder: (ctx)=> view);
    }
  }
  static bool isIphone() {
    if (Platform.isIOS) {
      // Optionally add more logic here to differentiate between iPhone and iPad if needed
      return true; // It's an iOS device, assume it's an iPhone.
    }
    return false;
  }
static bool isMobileWeb() {
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  //AppUtils.showSnackbar("message", userAgent);
  print("======s$userAgent");
  return userAgent.contains("iphone") ||
      userAgent.contains("android") ||
      userAgent.contains("ipad");

}
}
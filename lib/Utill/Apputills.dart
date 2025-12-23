
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proxlink/Utill/styles.dart';

import '../utill/app_colors.dart';
import 'AppConstants.dart';
import 'Dimensions.dart';
import 'ResponsiveView.dart';
import 'app_base_client.dart';
import 'app_required.dart';

class AppUtils {
  AppUtils._();
  static Rx<Color> currentHeaderThemeColor = AppColors.primaryColor.obs;
  // Method to update the color dynamically using a hex string

  static String FcmToken="";
  static void updateHeaderColor(String colorCode) {
    currentHeaderThemeColor.value = getColorFromHex(colorCode) ;
  }
  static showSnackbar( String message,String Title) {
    Get.snackbar(
      Title, // Title
      message, // Message
      snackPosition: SnackPosition.TOP, // Position of the SnackBar
      backgroundColor: Colors.black, // Background color
      colorText: Colors.white, // Text color
      duration: Duration(seconds: 2), // Duration for how long the SnackBar stays
    );
  }
 static Future<bool> checkInternetConnectivity() async {
//     final connectivityResult = await (Connectivity().checkConnectivity());
//     print("sdd$connectivityResult");
//     if (connectivityResult == ConnectivityResult.mobile) {
//       debugPrint("User is connected to mobile network");
//       return true;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       debugPrint("User is connected to wifi network");
//       return true;
//     } else {
// //showToast("Check Internet Connectivity");
//       return false;
//     }
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

// This condition is for demo purposes only to explain every connection type.
// Use conditions which work for your requirements.
   if (connectivityResult.contains(ConnectivityResult.mobile)) {
     // Mobile network available.
     return true;
   } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
     return true;
   } else {
//showToast("Check Internet Connectivity");
     return false;
   }
  }
 static Color getColorFromHex(String hexColor) {
    // Remove the '#' symbol if it is there
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    // If the color doesn't have an alpha value (e.g., #RRGGBB), add "FF" for full opacity
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    // Convert the hex string to an integer and create the color
    return Color(int.parse(hexColor, radix: 16));
  }
  static String stripHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').replaceAll('&nbsp;', ' ').trim();
  }
  static void showCustomSnackBarHelper(String message, {bool isError = true, Duration? duration, Widget? content, EdgeInsetsGeometry? margin, Color? backgroundColor, EdgeInsetsGeometry? padding}) {
    ScaffoldMessenger.of(Get.context!).clearSnackBars();
    final double width = MediaQuery.of(Get.context!).size.width;
    ScaffoldMessenger.of(Get.context!)..hideCurrentSnackBar()..showSnackBar(SnackBar(key: UniqueKey(), content: content ??  Text(message, style: Styles.inriaSansLight.copyWith(color: Colors.white),),
      margin: ResponsiveView.isDesktop(Get.context!) ? margin ??  EdgeInsets.only(
        right: width * 0.75, bottom: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeExtraSmall,
      ) : null,
      duration: duration ?? const Duration(milliseconds: 4000),
      behavior: ResponsiveView.isDesktop(Get.context!) ? SnackBarBehavior.floating : SnackBarBehavior.fixed ,
      dismissDirection: DismissDirection.down,
      backgroundColor: backgroundColor ?? (isError ? Colors.red : Colors.green),
      padding: padding,

    ),
    );
  }
  static double calculateDistance({
    required double venderlat,
    required double venderlon,
    required double lat,
    required double lon,
  }) {
    const double earthRadiusKm = 6371.0; // Earth's radius in kilometers

    // Convert degrees to radians
    double toRadians(double degree) => degree * pi / 180;

    double dLat = toRadians(lat - venderlat);
    double dLon = toRadians(lon - venderlon);

    double a = pow(sin(dLat / 2), 2) +
        cos(toRadians(venderlat)) * cos(toRadians(lat)) * pow(sin(dLon / 2), 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }
 static Future<Uri> createDynamicLink(String path, String section_id) async {

   String link="https://proxlink.com/$path/${section_id.toString()}";

    return Uri.parse(link);
  }
  static void saveTokenToServer(String token,bool login) async {
    // send token to your backend API
    FcmToken=token;
if(login) {
//print(FcmToken);
  var requestBody = {
    'token':FcmToken,

    // await http.MultipartFile.fromPath("image", image),
  };
  try {
    final response = await BaseClient.sharedClient.postRequest(
      endPoint: AppConstants.updateToken,
      body: requestBody,
    );
    // print("response=====$response");
    //print("response=====$response");

  } catch (exception) {
   // print("response=====$exception");
    rethrow;
  }
}
  }

  static Future<void> initFCM(bool login) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) saveTokenToServer(token,login);
//print(token);
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      saveTokenToServer(token, login);
    });
  }

  static bool isValidMobileNumber(String number) {
    String regexPattern = r'^[6-9]\d{9}$';
    RegExp regExp = RegExp(regexPattern);
    return regExp.hasMatch(number);
  }

  static Future<String> getFilePathFromAssets(String assetPath, String filename) async {
    // Load asset as byte data
    final byteData = await rootBundle.load(assetPath);

    // Get temp directory
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');

    // Write the data
    await file.writeAsBytes(
      byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file.path;
  }


}
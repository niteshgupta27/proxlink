
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utill/app_colors.dart';
import 'AppConstants.dart';

class AppTheme {
  static ThemeData getproxlinkTheme() {
    return ThemeData(
      fontFamily: AppConstants.fontFamily_Acre,
      primaryColor: AppColors.primaryColor,
      useMaterial3: false,
      appBarTheme: const AppBarTheme(elevation: 5.0,centerTitle: true,color: AppColors.primaryColor),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
      }),
      // TODO FOR BUTTON GLOBALLY decoration
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
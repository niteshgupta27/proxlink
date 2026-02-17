import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utill/app_colors.dart';
import 'AppConstants.dart';

class AppTheme {
  static ThemeData getproxlinkTheme() {
    return ThemeData(
      fontFamily: AppConstants.fontFamily_Acre,
      primaryColor: AppColors.primaryColor,
      useMaterial3: false,
      appBarTheme: const AppBarTheme(
        elevation: 5.0,
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryColor, // Android
          statusBarIconBrightness: Brightness.light, // Android icons
          statusBarBrightness: Brightness.dark, // iOS icons
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
      }),
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

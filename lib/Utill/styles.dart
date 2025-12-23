import 'package:flutter/material.dart';
import 'package:proxlink/Utill/AppConstants.dart';

import '../utill/app_colors.dart';
import 'Dimensions.dart';


class Styles {

  static const inriaSansLight = TextStyle(
    fontFamily: AppConstants.fontFamily_Acre,
    fontWeight: FontWeight.w300,
  );

  static const inriaSansRegular = TextStyle(
    fontFamily: AppConstants.fontFamily_Acre,
    fontWeight: FontWeight.w400,
  );

  static const inriaSansBold = TextStyle(
    fontFamily: AppConstants.fontFamily_Acre,
    fontWeight: FontWeight.w700,
  );
  static const PageTitle = TextStyle(
    fontFamily: AppConstants.fontFamily_Acre,
    fontWeight: FontWeight.w700,
    color: AppColors.whites,
    fontSize: Dimensions.fontSizeOverLarge
  );
  static const searchKey = TextStyle(
      fontFamily: AppConstants.fontFamily_Acre,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
      fontSize: Dimensions.fontSizeSmallDefault
  );
  static const headerTitel = TextStyle(
      fontFamily: AppConstants.fontFamily_Acre,
      fontWeight: FontWeight.w700,
      color: AppColors.black,
      fontSize: Dimensions.fontSizeLarge17
  );

  static const inriaBold = TextStyle(
    fontFamily: AppConstants.fontFamily_Acre,
    fontWeight: FontWeight.bold,
  );
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:proxlink/Utill/Dimensions.dart';
import 'package:proxlink/Utill/app_required.dart';
import 'package:proxlink/Utill/styles.dart';
import 'package:proxlink/features/auth/Login/controller/login_controller.dart';
import 'package:proxlink/features/auth/Otp/controller/Otpcontroller.dart';

import '../../../../Utill/Images.dart';
import '../../../../Utill/ResponsiveView.dart';
import '../../../../Utill/app_colors.dart';
import '../../../../common/widget/custom_loader_widget.dart';


class OtpView extends StatefulWidget {
  const OtpView({super.key});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  var controller = Get.find<OtpController>();

  var _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
   // bool isKeyboardOpen = bottomInsets != 0;
    return Obx(() =>Scaffold(
      backgroundColor:ResponsiveView.isMobile()? AppColors.primaryColor:AppColors.appBackground,
      resizeToAvoidBottomInset: true,
      body: ResponsiveView.isMobile() ?  Stack(
        children: [


          Positioned(
            top: 0,
            left: 0,
            right: 0,

            child: Image.asset(Images.logo),
          ),
          if( controller.localImagePath.value.isNotEmpty)
            Positioned(top: 0,
                left: 0,
                right: 0,
                child:Image.file(
                  File(controller.localImagePath.value),
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover, // Ensures the image covers the entire screen
                )),
          Positioned(
            top: 60,
            left: 0,
            child: IconButton(
                color: Colors.white,
                iconSize: Dimensions.x26,
                onPressed: () {
                  Get.back();
                },
                icon: SvgPicture.asset(
                  Images.logo,
                  height: Dimensions.x26,
                )),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height * 0.4)-bottomInsets, // Adjust this based on your UI
            left: 0,
            right: 0,
            bottom: 0, // Ensures that the form takes up all available space
            child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.whites,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,child: Obx(() =>controller.isLoading.value ?const Center(child: CustomLoaderWidget(color: AppColors.primaryColor,)) :Column(
                    children: [
                      const SizedBox(height: Dimensions.x50),

                      // Login or Signup title

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    thickness: 1.5,
                                    color: AppColors.black.withOpacity(0.2))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Verify OTP',
                                style: Styles.inriaSansBold.copyWith(
                                    fontSize: Dimensions.fontSizeLarge17,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Expanded(
                                child: Divider(
                                    thickness: 1.5,
                                    color: AppColors.black.withOpacity(0.2))),
                          ],
                        ),
                      ),

                      const SizedBox(height: Dimensions.x34),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text.rich(
                          TextSpan(
                            text:
                            'We have send an 4 digit one time password to your mobile number ',
                            style: Styles.inriaSansBold.copyWith(
                                fontSize: Dimensions.fontSizeMedium,
                                color: AppColors.black,
                                fontWeight: FontWeight.w400),
                            children: [
                              TextSpan(
                                text: controller.phonenumber.value,
                                style: Styles.inriaSansBold.copyWith(
                                    fontSize: Dimensions.fontSizeOverLarge,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Phone number input field
                      Padding(
                          padding: const EdgeInsets.only(left: 64, right: 64, top: 26),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Text(
                              //   controller.otpvalue,
                              //   style: Styles.inriaSansBold.copyWith(
                              //       fontSize: Dimensions.fontSizeMedium,
                              //       color: AppColors.primaryColor,
                              //       fontWeight: FontWeight.w700
                              //   ),
                              // ),
                              Text(
                                'Enter OTP',
                                style: Styles.inriaSansBold.copyWith(
                                    fontSize: Dimensions.fontSizeMedium,
                                    color: Color(0xFF626262),
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                              const SizedBox(height: Dimensions.x0_6,),

                              OtpPinField(

                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                maxLength: 4,
                                fieldWidth: 58.0,
                                fieldHeight: 58.0,
                                otpPinFieldDecoration: OtpPinFieldDecoration.custom,
                                otpPinFieldStyle: OtpPinFieldStyle(
                                    textStyle: Styles.inriaSansBold.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                    fieldBorderRadius: Dimensions.radiusSizeSmall,
                                    activeFieldBorderColor: Colors.black,
                                    defaultFieldBackgroundColor: const Color(0xFFF2F2F2),
                                    activeFieldBackgroundColor: const Color(0xFFF2F2F2),
                                    filledFieldBackgroundColor: const Color(0xFFF2F2F2)
                                ),
                                autoFillEnable: true,
                                keyboardType: TextInputType.number,
                                onSubmit: (String pin) {
                                  print("OTP Entered: $pin");
                                },
                                onChange: (String text) {
                                  controller.otpvalue=text;
                                },
                              )
                            ],
                          )),

                      const SizedBox(height: 60),

                      // Continue button

                      Container(
                        height: 60,
                        width: double.maxFinite,
                        margin: const EdgeInsets.symmetric(horizontal: 100),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 4.0,
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
                            ),
                          ),
                          onPressed: () {
                            // Get.toNamed(Routes.SignUpSCREEN);
                            controller.validateAndProcess(controller.otpvalue.toString());
                          },
                          child: Text(
                            'Verify',
                            style: Styles.inriaSansBold.copyWith(
                              fontSize: Dimensions.fontSizeOverLarge,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 38),

                      // OR continue with text
                      // Text(
                      //   'Need help!',
                      //   textAlign: TextAlign.center,
                      //   style: Styles.inriaSansRegular.copyWith(
                      //     fontSize: Dimensions.fontSizeMedium,
                      //     color: const Color(0xFF626262),
                      //   ),
                      // ),
                    ],
                  ))),)
            ),
          )
        ],
      ):Center(child:  Container(
          width: width > 600 ? 600 : width * 0.9,
          height: 600,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
                    child: SingleChildScrollView(
                       child: Form(
                      key: _formKey,child: controller.isLoading.value ?const Center(child: CustomLoaderWidget(color: AppColors.primaryColor,)) :Column(
                        children: [
                          Container(
                              decoration:  BoxDecoration(image: DecorationImage(
                                image: FileImage(File(Images.logo)),
                                fit: BoxFit.fill,
                              ),
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                              ),
                              child:Center(child:controller.localImagePath.value.isNotEmpty?  Image.file(
                                File(controller.localImagePath.value),
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover, // Ensures the image covers the entire screen
                              ):Image.asset(Images.logo,width: 200,),)),
                          // Login or Signup title
                          Center(
                            child: Text(
                              'Verify OTP',
                              style: Styles.inriaSansBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge17,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),

                          const SizedBox(height: Dimensions.x36),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text.rich(
                              TextSpan(
                                text:
                                'We have send an 4 digit one time password to your mobile number ',
                                style: Styles.inriaSansBold.copyWith(
                                    fontSize: Dimensions.fontSizeMedium,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w400),
                                children: [
                                  TextSpan(
                                    text: controller.phonenumber.value,
                                    style: Styles.inriaSansBold.copyWith(
                                        fontSize: Dimensions.fontSizeOverLarge,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Phone number input field
                          Padding(
                              padding: const EdgeInsets.only(left: 64, right: 64, top: 26),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   controller.otpvalue,
                                  //   style: Styles.inriaSansBold.copyWith(
                                  //       fontSize: Dimensions.fontSizeMedium,
                                  //       color: AppColors.primaryColor,
                                  //       fontWeight: FontWeight.w700
                                  //   ),
                                  // ),
                                  Text(
                                    'Enter OTP',
                                    style: Styles.inriaSansBold.copyWith(
                                        fontSize: Dimensions.fontSizeMedium,
                                        color: Color(0xFF626262),
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.x0_6,),

                                  OtpPinField(

                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    maxLength: 4,
                                    fieldWidth: 58.0,
                                    fieldHeight: 58.0,
                                    otpPinFieldDecoration: OtpPinFieldDecoration.custom,
                                    otpPinFieldStyle: OtpPinFieldStyle(
                                        textStyle: Styles.inriaSansBold.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                        fieldBorderRadius: Dimensions.radiusSizeSmall,
                                        activeFieldBorderColor: Colors.black,
                                        defaultFieldBackgroundColor: const Color(0xFFF2F2F2),
                                        activeFieldBackgroundColor: const Color(0xFFF2F2F2),
                                        filledFieldBackgroundColor: const Color(0xFFF2F2F2)
                                    ),
                                    autoFillEnable: true,
                                    keyboardType: TextInputType.number,
                                    onSubmit: (String pin) {
                                      print("OTP Entered: $pin");
                                    },
                                    onChange: (String text) {
                                      controller.otpvalue=text;
                                    },
                                  )
                                ],
                              )),

                          const SizedBox(height: 60),

                          // Continue button

                          Container(
                            height: 60,
                            width: double.maxFinite,
                            margin: const EdgeInsets.symmetric(horizontal: 100),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 4.0,
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
                                ),
                              ),
                              onPressed: () {
                                // Get.toNamed(Routes.SignUpSCREEN);
                                controller.validateAndProcess(controller.otpvalue.toString());
                              },
                              child: Text(
                                'Verify',
                                style: Styles.inriaSansBold.copyWith(
                                  fontSize: Dimensions.fontSizeOverLarge,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 38),

                          // OR continue with text
                          // Text(
                          //   'Need help!',
                          //   textAlign: TextAlign.center,
                          //   style: Styles.inriaSansRegular.copyWith(
                          //     fontSize: Dimensions.fontSizeMedium,
                          //     color: const Color(0xFF626262),
                          //   ),
                          // ),
                        ],
                      )),)
                ),


      )),



    );
  }
}

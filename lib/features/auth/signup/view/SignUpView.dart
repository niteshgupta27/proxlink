import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:proxlink/Utill/Dimensions.dart';
import 'package:proxlink/features/auth/signup/controller/SignUpController.dart';

import '../../../../Utill/AppConstants.dart';
import '../../../../Utill/Images.dart';
import '../../../../Utill/ResponsiveView.dart';
import '../../../../Utill/app_colors.dart';
import '../../../../Utill/app_required.dart';
import '../../../../Utill/styles.dart';
import '../../../../common/widget/custom_loader_widget.dart';
import '../../../../routes/app_pages.dart';



class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(appBar: AppBar(title:  Row(
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
    ),),
      body: Stack(
        children: [
          /// Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Overlay
        //  Container(color: Colors.white.withOpacity(0.95)),

          SafeArea(
            child: Column(
              children: [
               // _header(),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40,),
                          const Text(
                            "Let Us know more about you",
                            style: TextStyle(fontFamily: AppConstants.fontFamily_Acre,
                                fontSize: 23,
                                fontWeight: FontWeight.w700),
                          ),

                          _label("What do you do? *"),
                          _infoBox(),

                          _label("Name *"),
                          _textField(
                            controller.nameCtrl,
                            "John Doe",
                            validator: (v) =>
                            v!.isEmpty ? "Name required" : null,
                          ),

                          _label("Age *"),
                          _textField(
                            controller.ageCtrl,
                            "25",
                            keyboard: TextInputType.number,
                            validator: (v) =>
                            v!.isEmpty ? "Age required" : null,
                          ),

                          _label("Gender *"),
                          _genderDropdown(),

                          _label("What best describe you? *"),
                          _professionDropdown(),

                          _label("Company Name / College Name"),
                          _organizationDropdown(),

                          const SizedBox(height: 17),
                          _terms(),

                          //const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Bottom Button
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: controller.submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: const Text("Next", style:
                      const TextStyle(fontSize:18, fontWeight: FontWeight.bold,fontFamily: AppConstants.fontFamily_Acre)),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// ---------------- UI Widgets ----------------

  Widget _header() {
    return Container(
      height: 70,
      color: const Color(0xFF0D6EFD),
      alignment: Alignment.center,
      child: const Text(
        "✔ ProxiLink",
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 17, bottom: 6),
      child: Text(text,
          style:
          const TextStyle(fontSize:18, fontWeight: FontWeight.bold,fontFamily: AppConstants.fontFamily_Acre)),
    );
  }

  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _box(),
      child: const Text(
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
        style: TextStyle(fontSize: 14,fontFamily: AppConstants.fontFamily_Acre,fontWeight: FontWeight.normal),
      ),
    );
  }

  Widget _textField(
      TextEditingController ctrl,
      String hint, {
        TextInputType keyboard = TextInputType.text,
        String? Function(String?)? validator,
      }) {
    return Container(
      decoration: _box(),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),style: TextStyle(fontFamily: AppConstants.fontFamily_Acre,fontWeight: FontWeight.normal),
      ),
    );
  }

  Widget _genderDropdown() {
    return Obx(() => Container(width: double.infinity,
      decoration: _box(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.gender.value,
          items: ["Male", "Female", "Other"]
              .map((e) =>
              DropdownMenuItem(value: e, child: Text(e,style:TextStyle(fontFamily: AppConstants.fontFamily_Acre,fontWeight: FontWeight.normal) ,)))
              .toList(),
          onChanged: (v) => controller.gender.value = v!,
        ),
      ),
    ));
  }

  Widget _professionDropdown() {
    return Obx(() => Container(width: double.infinity,
      decoration: _box(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.profession.value,
          items: [
            "Working Professional",
            "Student",
            "Business Owner"
          ]
              .map((e) =>
              DropdownMenuItem(value: e, child: Text(e,style: TextStyle(fontFamily: AppConstants.fontFamily_Acre,fontWeight: FontWeight.normal))))
              .toList(),
          onChanged: (v) => controller.profession.value = v!,
        ),
      ),
    ));
  }

  Widget _organizationDropdown() {
    return Obx(() => Container(width: double.infinity,
      decoration: _box(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.organization.value,
          items: [
            "Company Name / College Name",
            "Google",
            "IIT Delhi"
          ]
              .map((e) =>
              DropdownMenuItem(value: e, child: Text(e,style: TextStyle(fontFamily: AppConstants.fontFamily_Acre,fontWeight: FontWeight.normal),)))
              .toList(),
          onChanged: (v) => controller.organization.value = v!,
        ),
      ),
    ));
  }

  Widget _terms() {
    return Obx(() => Row(
      children: [
        Checkbox(
          value: controller.agree.value,
          onChanged: (v) => controller.agree.value = v!,
        ),
        Expanded(
          child: RichText(
            text: const TextSpan(
              style: TextStyle(color: AppColors.black, fontSize: 14,fontFamily: AppConstants.fontFamily_Acre,fontWeight: FontWeight.normal),
              children: [
                TextSpan(text: "I agree to "),
                TextSpan(
                    text: "Terms & Conditions",
                    style: TextStyle(color: AppColors.primaryColor)),
                TextSpan(text: " and "),
                TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(color: AppColors.primaryColor)),
              ],
            ),
          ),
        )
      ],
    ));
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
        )
      ],
    );
  }
}

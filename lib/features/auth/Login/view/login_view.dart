import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:proxlink/Utill/AppConstants.dart';
import 'package:proxlink/Utill/app_required.dart';
import 'package:proxlink/features/auth/Login/controller/login_controller.dart';

import '../../../../Utill/Dimensions.dart';
import '../../../../Utill/Images.dart';
import '../../../../Utill/ResponsiveView.dart';
import '../../../../Utill/app_colors.dart';
import '../../../../Utill/styles.dart';
import '../../../../common/widget/custom_loader_widget.dart';
import '../../../../routes/app_pages.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var controller = Get.find<LoginController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.32, -0.82),
            radius: 0.5,
            colors: [
              Color(0xFF32A5FC),
              Color(0xFF3C3EFC),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Blurred background circle
            Positioned(
              top: -68,
              left: 27,
              child: Transform.rotate(
                angle: 30 * 3.14159 / 180,
                child: Container(
                  width: 736,
                  height: 736,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5E7EFF).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(368),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 117.73, sigmaY: 117.73),
                    child: Container(),
                  ),
                ),
              ),
            ),

            // Wave circle background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                Images.wave_circle,
                height: 366,
                fit: BoxFit.cover,
              ),
            ),

            // Main illustration with profile pictures
            Positioned(
              top: 38,
              left: 48,
              child: Image.asset(
                Images.illustration,
                width: 392,
                height: 373,
              ),
            ),

            // Content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 5),

                  // Logo + App name in a row (CENTERED)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        Images.logo,
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'ProxiLink',
                        style: TextStyle(
                          fontFamily: AppConstants.fontFamily_ADLaM_Display,
                          fontSize: 36,
                          fontWeight: FontWeight.normal,
                          color: AppColors.whites,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: Dimensions.x30),

                  // Welcome text
                  const Text(
                    'Welcome to ProxiLink',
                    style: TextStyle(
                      fontFamily: AppConstants.fontFamily_Acre,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whites,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  const Opacity(
                    opacity: 0.7,
                    child: Text(
                      'Connect with professionals around you',
                      style: TextStyle(
                        fontFamily: AppConstants.fontFamily_Acre,
                        fontSize: 19,
                        fontWeight: FontWeight.normal,
                        color: AppColors.whites,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: Dimensions.x40),

                  // Google Login Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: SocialLoginButton(
                      text: 'Log In with Google',
                      iconPath: Images.google,
                      backgroundColor: AppColors.whites,
                      textColor: const Color(0xFF2D2D37),
                      onPressed: () {
                        // Handle Google login
                      },
                    ),
                  ),

                  const SizedBox(height: Dimensions.x16),

                  // Facebook Login Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: SocialLoginButton(
                      text: 'Log In with Facebook',
                      iconPath: Images.facebook,
                      backgroundColor:AppColors.whites,
                      textColor: AppColors.primaryColor,
                      borderColor: AppColors.primaryColor,
                      onPressed: () {
                        // Handle Facebook login

                        Get.offNamed(Routes.SignUpSCREEN );
                      },
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Terms and Privacy
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 42),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: AppConstants.fontFamily_Acre,
                          fontSize: 19,
                          color: AppColors.whites,
                          height: 1.6,
                        ),
                        children: [
                          TextSpan(text: 'By Continuing you are agree to \n'),
                          TextSpan(
                            text: 'Terms & Privacy Policy',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height:Dimensions.x50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onPressed;
  const SocialLoginButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: borderColor == null ? 2 : 0,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.5)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: Dimensions.x16),
            Text(
              text,
              style: TextStyle(
                fontFamily: AppConstants.fontFamily_Inter,
                fontSize: 20,
                fontWeight: borderColor != null
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: textColor,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:proxlink/features/auth/Login/controller/login_controller.dart';
import 'package:proxlink/features/auth/Otp/controller/Otpcontroller.dart';
import 'package:proxlink/features/auth/services/auth_services.dart';
import 'package:proxlink/features/auth/signup/controller/SignUpController.dart';
import '../../../Utill/app_required.dart';
import '../../bottomNavigation/controllers/bottom_navigation_controller.dart';


class AuthBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
    Get.lazyPut<AuthServices>(
      () => AuthServices(),
    );
    Get.lazyPut<OtpController>(
          () => OtpController(),
    );
    Get.lazyPut<SignUpController>(
          () => SignUpController(),
    );
  }
}

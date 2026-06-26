import 'package:get/get.dart';
import 'package:proxlink/features/auth/Login/controller/login_controller.dart';
import 'package:proxlink/features/auth/services/auth_services.dart';
import 'package:proxlink/features/auth/signup/controller/SignUpController.dart';


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

    Get.lazyPut<SignUpController>(
          () => SignUpController(),
    );
  }
}

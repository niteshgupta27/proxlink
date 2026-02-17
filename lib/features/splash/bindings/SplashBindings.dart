import 'package:get/get.dart';
import '../controller/SplashController.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    // Using Get.put() to ensure the controller is initialized immediately.
    Get.put<SplashController>(SplashController());
  }
}

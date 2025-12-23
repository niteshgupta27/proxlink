import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_required.dart';
import '../../../Utill/app_storage.dart';
import '../../../routes/app_pages.dart';


class SplashController extends GetxController {
  String TAG = "SplashController";
  final appStorage = Get.find<AppStorage>();
  var localImagePath = "".obs;
  RxBool isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
  }
  Future startAnimation() async {
    localImagePath.value =
        await appStorage.read(AppConstants.SplashPath)??"";
    isLoading.value=false;
    print("object${localImagePath.value} ");
    Future.delayed(const Duration(seconds: 2), () {
      print("object1");

      Get.offNamed(Routes.LOGINSCREEN);
    });
  }

}

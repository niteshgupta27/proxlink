import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_required.dart';
import '../../../Utill/app_storage.dart';


class ChatController extends GetxController {
  String TAG = "SplashController";
  final appStorage = Get.find<AppStorage>();
  var localImagePath = "".obs;
  RxBool isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
  }


}

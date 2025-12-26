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
  RxBool isLoading = false.obs;
  final messages = [
    {'name': 'Pranav Ray', 'msg': 'okay sure!!', 'time': '12:25 PM', 'initials': 'PR'},
    {'name': 'Ayesha Tanwar', 'msg': 'okay sure!!', 'time': '12:25 PM', 'initials': 'AT'},
    {'name': 'Roshni', 'msg': 'okay sure!!', 'time': '12:25 PM', 'initials': 'R'},
    {'name': 'Kaushik', 'msg': 'okay sure!!', 'time': '12:25 PM', 'initials': 'K'},
    {'name': 'Rahul Sini', 'msg': 'okay sure!!', 'time': '12:25 PM', 'initials': 'RS'},
  ].obs;
  @override
  void onInit() {
    super.onInit();
  }


}

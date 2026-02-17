
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../Utill/Apputills.dart';
import '../../../Utill/app_storage.dart';
import '../networkService.dart';

class ShearQRController extends GetxController {

  final AppStorage _appStorage = Get.find<AppStorage>();
  var isLoading = false.obs;
  final Networkservice _eventService = Networkservice();

  RxString networkId = ''.obs;
  RxString networkName = ''.obs;
 // var networks = <NetworkModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    //fetchNetworks();
    final argument =Get.arguments;
    if(argument != null){
      networkId.value=argument['network_id'];
      networkName.value= argument['network_name'];
    }
  }

  Future<void> List_event(String networkId) async {
    isLoading.value = true;
    // DialogHelper.showLoading();


      final body = {
        "api_key": _appStorage.loggedInUserToken,
        "user_id": _appStorage.loggedInUserId?.toString() ?? "0",
        "payload": {
          "network_id": networkId
        }
      };

    _eventService.getevents(body: body).then((value) async {
        isLoading.value = false;
        if (value.status == "success") {



        } else {
          AppUtils.showSnackbar( "Authentication failed", "Info");
        }
      }).catchError((err) {
        isLoading.value = false;
        AppUtils.showSnackbar("Something went wrong", "Oops");
      });
  }
}
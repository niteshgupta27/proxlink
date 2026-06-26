import 'package:get/get.dart';
import '../../../Utill/Apputills.dart';
import '../../../Utill/app_storage.dart';
import '../../discovery/model/discovery_Model.dart';
import '../service/memberService.dart';


class MemberListController extends GetxController {
  String TAG = "SplashController";
  var networks = <GroupedUser>[].obs;
  RxString networkId = ''.obs;
  var isLoading = false.obs;
  final Memberserviceservice _eventService = Memberserviceservice();
  final appStorage = Get.find<AppStorage>();
  var view_as = ''.obs;
  RxString networkname= ''.obs;
  @override
  void onInit() {
    super.onInit();
    final argument =Get.arguments;
    if(argument != null){
      networkId.value=argument['network_id'].toString();
      view_as.value=argument['view_as'];
      networkname.value=argument['network_name'];
      List_event();
    }

  }


  Future<void> List_event() async {
    isLoading.value = true;
    // DialogHelper.showLoading();


    final body = {
      "api_key": appStorage.loggedInUserToken,
      "user_id": appStorage.loggedInUserId?.toString() ?? "0",
      "payload": {
        "network_id": networkId.value,
        "view_as": view_as.value
      }
    };

    _eventService.getevents(body: body).then((value) async {
      isLoading.value = false;
      if (value.status == "success") {

networks.value=value.groupedUsers;

      } else {
        AppUtils.showSnackbar( "Authentication failed", "Info");
      }
    }).catchError((err) {
      isLoading.value = false;
      AppUtils.showSnackbar("Something went wrong", "Oops");
    });
  }

}

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:proxlink/Utill/app_required.dart';
import 'package:proxlink/features/Chat/view/chatView.dart';
import 'package:proxlink/features/discovery/view/discoveryView.dart';
import 'package:proxlink/features/network/view/networkView.dart';

import '../../../Utill/AppConstants.dart';
import '../../../Utill/Apputills.dart';

import '../../../Utill/ResponsiveView.dart';
import '../../../Utill/app_storage.dart';
import '../../auth/Otp/model/otpresponse.dart';


class BottomNavigationController extends GetxController {

  String TAG = "BottomNavigationController";
  RxBool isMobilex = false.obs;
  final List<GetView> pages = [
     DiscoveryView(),
     NetworkView(),
     ChatView()
  ];
  var appStorage = Get.find<AppStorage>();

  var _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;
  changeIndex(val) {_currentIndex.value = val;
    if(val==0){
    AppUtils.updateHeaderColor(appStorage.productheadColor);
    }
  else if(val==1){
    AppUtils.updateHeaderColor(appStorage.serviceheadColor);
  }
    else{
      AppUtils.updateHeaderColor(appStorage.AmcHeaderColor);
    }
  }

  @override
  void onInit() {
    super.onInit();
    var x = Get.arguments;
    if (x != null) {
      _currentIndex.value = x["selectedIndex"];
    }
    if (ResponsiveView.isWeb()) {
      ReadUserData();
    }

    }
  ReadUserData() async {
    print("object");
    var loggedInUserInformation =
    await appStorage.read(AppConstants.loginUserInformation);


    if(loggedInUserInformation!= null) {
      appStorage.loggedInUser = loggedInUserInformation != null ? UserData.fromJson(loggedInUserInformation) : UserData.fromJson({});
      print(appStorage.loggedInUser.name);
      appStorage.loggedInUserToken =
      await appStorage.read(AppConstants.loginUserInformationToken);
      appStorage.productheadColor =
      await appStorage.read(AppConstants.productHeaderColor);
      AppUtils.updateHeaderColor(appStorage.productheadColor);
      appStorage.serviceheadColor =
          await appStorage.read(AppConstants.ServiceHeaderColor)??"#ffe2e2e";
      appStorage.AmcHeaderColor =
          await appStorage.read(AppConstants.AmcHeaderColor)??"#079AC2";
      appStorage.loggedInUserReferalContain =
          await appStorage.read(AppConstants.Referalcontent) ?? "";
      final List<dynamic> rawList = await appStorage.read(AppConstants.cartList) ?? [];
      print("object2$rawList");


    }

  }
}

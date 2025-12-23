import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:proxlink/features/auth/Otp/model/otpresponse.dart';

import 'AppConstants.dart';

class AppStorage extends GetxService {
   UserData loggedInUser = UserData();
  String loggedInUserToken = '';
   String loggedInUserReferalContain = '';
   String productheadColor = '#ffe2e2e';
String serviceheadColor = '#ffe2e2e';
String AmcHeaderColor = '#079AC2';
//String FcmToken = '';
String SplashPath = '';
String SplashTime = '';
String loginTime='';
String refralcode="";

RxBool showdownloadApp=true.obs;
String navigationurl="";
  Future<AppStorage> init() async {
    await GetStorage.init();
    return this;
  }

  Future<void> write(String key, dynamic value) async {
    return await GetStorage().write(key, value);
  }

  dynamic read(String key) async {
    return await GetStorage().read<dynamic>(key);
  }

  Future<void> delete(String key) {
    return GetStorage().remove(key);
  }

  resetStorage() {
     loggedInUser = UserData();
    loggedInUserToken = '';

    GetStorage().remove(AppConstants.loginUserInformation);
    GetStorage().remove(AppConstants.loginUserInformationToken);
     GetStorage().remove(AppConstants.cartList);
     GetStorage().remove(AppConstants.AddressList);
     GetStorage().remove(AppConstants.Referalcontent);
  }


}
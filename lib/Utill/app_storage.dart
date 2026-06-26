import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


import '../features/auth/Login/models/otpresponse.dart';
import 'AppConstants.dart';

class AppStorage extends GetxService {
   UserData loggedInUser = UserData();
  String loggedInUserToken = '';
  int? loggedInUserId;
   String loggedInUserReferalContain = '';

//String FcmToken = '';
RxDouble current_lat = 0.0.obs;
  RxDouble current_lng = 0.0.obs;

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
    loggedInUserId = null;

    GetStorage().remove(AppConstants.loginUserInformation);
    GetStorage().remove(AppConstants.loginUserInformationToken);
    GetStorage().remove(AppConstants.loginUserId);
     GetStorage().remove(AppConstants.cartList);
     GetStorage().remove(AppConstants.AddressList);
     GetStorage().remove(AppConstants.Referalcontent);
  }


}

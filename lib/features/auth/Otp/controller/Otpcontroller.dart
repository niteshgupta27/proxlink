import 'package:get/get.dart';
import 'package:proxlink/Utill/app_required.dart';
import 'package:proxlink/features/auth/services/auth_services.dart';

import '../../../../Utill/AppConstants.dart';
import '../../../../Utill/Apputills.dart';
import '../../../../Utill/app_storage.dart';
import '../../../../routes/app_pages.dart';

class OtpController extends GetxController {
  String TAG = "OtpController";
  var loginServices = Get.find<AuthServices>();
  var appStorage = Get.find<AppStorage>();
  RxBool isLoading = false.obs;

  var arguments = Get.parameters;
var otpvalue="";
RxString phonenumber = "".obs;
RxInt isRegistor = 0.obs;
  var localImagePath = "".obs;

  @override
  void onInit() {
    super.onInit();
    if (arguments["phoneNumber"] != null) {
      isRegistor.value = arguments["Registration"]=="1"?1: 0;
      phonenumber.value = arguments["phoneNumber"]!;
      otpvalue= Get.arguments["otp"].toString();
print(arguments);

    }
    startAnimation();

  }
  Future startAnimation() async {
    localImagePath.value =
        await appStorage.read(AppConstants.loginimgPath) ?? "";
    print(localImagePath.value);


  }
  validateAndProcess(otp) async {
    if (otp != "" ) {
      if (await AppUtils.checkInternetConnectivity()) {

      OTPSubmit(otp);
    }else {
      AppUtils.showSnackbar("Please check Internet connection", "Info");
    }
    } else {
      AppUtils.showSnackbar("Please enter a OTP.", "Info");
      //Show error
    }
  }
  void OTPSubmit(Otp) {
    // AppUtils.alertWithProgressBar();
    isLoading.value=true;
    var requestBody = {
      'number': arguments["phoneNumber"],
      'otp':Otp,
      'Registration':arguments["Registration"],
      'fmc_token':AppUtils.FcmToken,

    };

    loginServices.OtpSubmit(body: requestBody).then((value) async {
      isLoading.value=false;
      if(value.status == true){
        if (value.data.registration == 1) {
          appStorage.loggedInUser = value.data;
          appStorage.loggedInUserToken =value.token;
          await appStorage.write(AppConstants.loginUserInformationToken, value.token!);
          await appStorage.write(
              AppConstants.loginUserInformation, appStorage.loggedInUser);
          Get.offAllNamed(Routes.BOTTOM_NAVIGATION);

        } else {
          //Get.back();
          Get.toNamed(Routes.SignUpSCREEN,parameters: {
            'phoneNumber': arguments["phoneNumber"]!,
          });

        }

      }else{
        AppUtils.showSnackbar(value.message.toString(),  "Info");
    }
    }).catchError((err) {
      // Get.back();
      isLoading.value=false;
      AppUtils.showSnackbar("Something went wrong","Oops");
      //AppUtils.alert("Something went wrong", title: "Oops");
    });
  }
}
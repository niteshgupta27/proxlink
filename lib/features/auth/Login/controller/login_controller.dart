import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proxlink/Utill/app_required.dart';
import 'package:proxlink/features/auth/services/auth_services.dart';

import '../../../../Utill/AppConstants.dart';
import '../../../../Utill/Apputills.dart';
import '../../../../Utill/app_storage.dart';
import '../../../../routes/app_pages.dart';

class LoginController extends GetxController {
  String TAG = "LoginController";
  var loginServices = Get.find<AuthServices>();
  RxBool isLoading = false.obs;
  Rx<User?> firebaseUser = Rx<User?>(null);
String providername="";
  var appStorage = Get.find<AppStorage>();

  var localImagePath = "".obs;

  @override
  void onInit() {
    super.onInit();
    // if(!kIsWeb) {
    //   firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
    //   ever(firebaseUser, handleAuthChanged);
    //   startAnimation();
    // }
    // AppUtils.initFCM(false);
   //AppUtils.currentHeaderThemeColor =AppColors.primaryColor ;
  }
  Future startAnimation() async {
    localImagePath.value =
        await appStorage.read(AppConstants.loginimgPath) ?? "";
    print(localImagePath.value);
    final file = File(localImagePath.value);
    if (await file.exists()) {

    }

  }
  void handleAuthChanged(User? user) {
    print(user?.email);
    print(user?.displayName);
    print(user?.tenantId);
    if (user != null) {
      if(providername=="Facebook"){
        signInWithSocial(user, "facebook");
      }
     else if(providername=="Apple"){
        signInWithSocial(user, "apple");
      }
      else if(providername=="Google"){
        signInWithSocial(user, "google");
      }
      //Get.offAllNamed('/home'); // Navigate to home if logged in
    } else {
      //Get.offAllNamed('/login'); // Navigate to login if not logged in
    }
  }
  validateAndProcess(phonenumber) async {
    print(phonenumber);
    if (phonenumber != "" && RegExp(AppConstants.phonenoExp)
        .hasMatch(phonenumber)) {
      if (await AppUtils.checkInternetConnectivity()) {
      login(phonenumber);
    }else {
        AppUtils.showSnackbar("Please check Internet connection", "Info");
      }
    } else {
      AppUtils.showSnackbar("Please enter a valid Phone Number.", "Info");
      //Show error
    }
  }
  void login(phonenumber) {
   // AppUtils.alertWithProgressBar();
    isLoading.value= true;
    var requestBody = {
      'number': phonenumber,

    };

    loginServices.authenticate(body: requestBody).then((value) {
      isLoading.value = false;
      if (value.data != null) {
print(value);
        Get.toNamed(Routes.OTPSCREEN,parameters: {
          'phoneNumber': phonenumber,
          'Registration': value.Registration.toString(),

        },arguments:{'otp': value.data["otp"].toString(),} );
      } else {
       // Get.back();

        AppUtils.showSnackbar(value.message.toString(),  "Info");
      }
    }).catchError((err) {
     // Get.back();
      isLoading.value = false;
      AppUtils.showSnackbar("Something went wrong","Oops");
      //AppUtils.alert("Something went wrong", title: "Oops");
    });
  }
  Future<UserCredential?> signInWithGoogle() async {
    providername = "Google";
    try {
      if (kIsWeb) {

        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email'); // explicitly request email
        googleProvider.addScope('profile');
        // Web-based Google sign-in using signInWithPopup
        UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);

        // Sometimes user info is only in userCredential.additionalUserInfo
        final user = userCredential.user;
        final additionalInfo = userCredential.additionalUserInfo;

        print("Firebase user: $user");
        print("Additional info: ${additionalInfo?.profile}");

        // The email might be in additionalUserInfo.profile
        String? email = user?.email ?? additionalInfo?.profile?['email'];
        print("User's email: $email");
       // print("User's email: ${userCredential.user?.email}");
        if (user != null) {
          signInWithSocial(user, "google", webEmail: email);
        }
        return userCredential;
      } else {

        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        print(googleUser);
        if (googleUser == null) {
          // User canceled the sign-in
          print("User canceled the sign-in.");
          return null;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        if (userCredential.user != null) {
          signInWithSocial(userCredential.user!, "google", token: googleAuth.idToken);
        }
        return userCredential;
      }
    } catch (e,stackTrace) {
      print("ffff$e");
      print("ffff$stackTrace");
      return null;
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    providername="Facebook";
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      print(result.status);
      if (result.status == LoginStatus.success) {
        print("result success");
        final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        if (userCredential.user != null) {
          signInWithSocial(userCredential.user!, "facebook", token: result.accessToken!.tokenString);
        }
        return userCredential;
      } else {
        print("result.status");
        print(result.status);
        print(result.message);
        return null;
      }
    } catch (e) {
      print("error $e");
      return null;
    }
  }

  Future<void> signInWithSocial(User user, String provider, {String? token, String? webEmail}) async {
    isLoading.value = true;
    String deviceId = await getDeviceId();
    
    var requestBody = {
      "device_id": deviceId,
      "provider": provider,
      "provider_token": token ?? "",
      "payload": {
        "email": webEmail ?? user.email ?? "",
        "provider_user_id": user.uid
      }
    };

    loginServices.socialLogin(body: requestBody).then((value) async {
      isLoading.value = false;
      if (value.status == "success") {
        if (value.apiKey != null) {
          appStorage.loggedInUserToken = value.apiKey!;
          await appStorage.write(AppConstants.loginUserInformationToken, value.apiKey!);
          appStorage.loggedInUserId = value.userId;
          await appStorage.write(AppConstants.loginUserId, value.userId);

        }
        
        if (value.isNewUser == true) {
          Get.toNamed(Routes.SignUpSCREEN, parameters: {
            'provider_id': user.uid,
            'email': webEmail ?? user.email ?? "",
            'name': user.displayName ?? "",
          });
        } else {
          Get.offAllNamed(Routes.BOTTOM_NAVIGATION);
        }
      } else {
        AppUtils.showSnackbar(value.message ?? "Authentication failed", "Info");
      }
    }).catchError((err) {
      isLoading.value = false;
      AppUtils.showSnackbar("Something went wrong", "Oops");
    });
  }

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      return webBrowserInfo.userAgent ?? "web";
    } else {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? "ios";
      }
    }
    return "unknown";
  }


}
class PigeonUserDetails {
  final String? id;
  final String? email;
  final String? displayName;

  PigeonUserDetails({this.id, this.email, this.displayName});

  // Factory constructor to create an instance from GoogleSignInAccount
  factory PigeonUserDetails.fromGoogleAccount(GoogleSignInAccount account) {
    return PigeonUserDetails(
      id: account.id,
      email: account.email,
      displayName: account.displayName,
    );
  }
}
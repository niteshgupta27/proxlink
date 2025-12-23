import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
        SocialFacebooklogin(user.email,user.displayName,user.tenantId);
      }
     else if(providername=="Apple"){
        SocialAppplelogin(user.email,user.displayName,user.tenantId);
      }
      else if(providername=="Google"){
        SocialGooglelogin(user.email,user.displayName,user.tenantId);
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
        SocialGooglelogin(email,additionalInfo?.profile?['name'],user?.uid);
        return userCredential;
      } else {

        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        print(googleUser);
        if (googleUser == null) {
          // User canceled the sign-in
          print("User canceled the sign-in.");
          return null;
        }
      //  FcmToken= await AppUtils.initializeFCM();

        SocialGooglelogin(googleUser.email,googleUser.displayName,googleUser.id);
        // if (googleUser != null) {
        //   return PigeonUserDetails.fromGoogleAccount(googleUser);
        // }

        // final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        // print("User canceled the sign-in.1${googleAuth}");
        // final OAuthCredential credential = GoogleAuthProvider.credential(
        //   accessToken: googleAuth.accessToken,
        //   idToken: googleAuth.idToken,
        // );
        // print("User canceled the sign-in.2$credential");
        // UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        // print("User canceled the sign-in.3");
        // String? email = userCredential.user?.email;
        // print("User's email: $email");
        //
        // return userCredential;
      }
    } catch (e,stackTrace) {
      print("ffff$e");
      print("ffff$stackTrace");
      return null;
    }
  }
  // Future<UserCredential?> signInWithFacebook() async {
  //   providername="Facebook";
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login( loginBehavior: LoginBehavior.webOnly, );
  //     print(result.status);
  //     if (result.status == LoginStatus.success) {
  //       print("result.");
  //       final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
  //       return await FirebaseAuth.instance.signInWithCredential(credential);
  //     } else {
  //       print("result.status");
  //       print(result.status);
  //       return null;
  //     }
  //   } catch (e) {
  //     print("error $e");
  //     return null;
  //   }
  // }
  // Future<UserCredential?> signInWithApple() async {
  //   providername="Apple";
  //   try {
  //     // final appleProvider = AppleAuthProvider();
  //     // print(appleProvider);
  //     // if (kIsWeb) {
  //     //   await FirebaseAuth.instance.signInWithPopup(appleProvider);
  //     // } else {
  //     //   await FirebaseAuth.instance.signInWithProvider(appleProvider);
  //     // }
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
  //     //);
  //     webAuthenticationOptions: WebAuthenticationOptions(
  //       clientId: 'com.example.app',  // Replace with your client ID
  //       redirectUri: Uri.parse(
  //         'https://your-app-url.com/callbacks/sign_in_with_apple', // Replace with your redirect URI
  //       ),
  //     ),
  //   );
  //     final OAuthCredential credential = OAuthProvider("apple.com").credential(
  //       idToken: appleCredential.identityToken,
  //       accessToken: appleCredential.authorizationCode,
  //
  //     );
  //
  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
  Future<void> SocialGooglelogin(email,name,id) async {
    // AppUtils.alertWithProgressBar();
    providername="Google";
    isLoading.value= true;
    var requestBody = {
      'name': name,
'email':email,
      'id':id,
      'fmc_token':AppUtils.FcmToken
    };
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    //await FacebookAuth.instance.logOut();
    loginServices.providergoogle(body: requestBody).then((value) async {
      isLoading.value = false;
      if (value.status == true) {
        if (value.registration == 1) {
          appStorage.loggedInUser = value.data!;
          appStorage.loggedInUserToken =value.token;
          await appStorage.write(AppConstants.loginUserInformationToken, value.token!);
          await appStorage.write(
              AppConstants.loginUserInformation, appStorage.loggedInUser);
          Get.offAllNamed(Routes.BOTTOM_NAVIGATION);


        }
        else if (value.registration == 1&& value.numberVerification==0) {
          Get.toNamed(Routes.OTPSCREEN,parameters: {
            'phoneNumber': value.data!.number.toString(),
            'Registration': value.data!.registration.toString(),
          });
        }
        else {
          //Get.back();
          Get.toNamed(Routes.SignUpSCREEN,parameters: {
            'provider_id': value.data!.providerId!,
            'email': value.data!.email!,
            'name': value.data!.name!,
          });

        }
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
  void SocialAppplelogin(email,name,id) {
    // AppUtils.alertWithProgressBar();
    isLoading.value= true;
    var requestBody = {
      'name': name,
      'email':email,
      'id':id
    };

    loginServices.authenticate(body: requestBody).then((value) {
      isLoading.value = false;
      if (value.data != null) {
        // appStorage.loggedInUser.data?.token = value.data;
        // appStorage.loggedInUserToken = value.data!;
        // appStorage.write(AppConstants.loginUserInformationToken, value.data!);
        // fetchUserInformation(token: value.data);
        // Get.toNamed(Routes.OTPSCREEN,parameters: {
        //   'phoneNumber': phonenumber,
        //   'Registration': value.Registration,
        // });
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
  void SocialFacebooklogin(email,name,id) {
    // AppUtils.alertWithProgressBar();
    isLoading.value= true;
    var requestBody = {
      'name': name,
      'email':email,
      'id':id
    };

    loginServices.authenticate(body: requestBody).then((value) {
      isLoading.value = false;
      if (value.data != null) {
        // appStorage.loggedInUser.data?.token = value.data;
        // appStorage.loggedInUserToken = value.data!;
        // appStorage.write(AppConstants.loginUserInformationToken, value.data!);
        // fetchUserInformation(token: value.data);
        // Get.toNamed(Routes.S,parameters: {
        //   'phoneNumber': phonenumber,
        //   'Registration': value.Registration,
        // });
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
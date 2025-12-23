import 'package:proxlink/Utill/app_required.dart';

import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_base_client.dart';
import '../Login/models/SocialResponse.dart';
import '../Login/models/login_response.dart';
import '../Otp/model/otpresponse.dart';

class AuthServices {
  String TAG = "AuthServices";

  Future<LoginResponse> authenticate({body}) async {
    try {
      final response = await BaseClient.sharedClient.postPreLogin(
        endPoint: AppConstants.login,
        body: body,
      );
     // print("response=====$response");
      print("response1=====$response");
      return LoginResponse.fromJson(response as Map<String, dynamic>);
    } catch (exception) {
      print("response exception=====$exception");
      rethrow;
    }
  }
  Future<OtpResponse> OtpSubmit({body}) async {
    try {
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.otpsubmit,
        body: body,
      );
      // print("response=====$response");
      print("response=====$response");
      return OtpResponse.fromJson(response as Map<String, dynamic>);
    } catch (exception) {
      print("response=====$exception");
      rethrow;
    }
  }
  Future<OtpResponse> register({body}) async {
    try {
      final response = await BaseClient.sharedClient.putRequest(
        endPoint: AppConstants.register,
        payloadObj: body,
      );
      // print("response=====$response");
      print("response=====$response");
      return OtpResponse.fromJson(response as Map<String, dynamic>);
    } catch (exception) {
      print("response=====$exception");
      rethrow;
    }
  }
  Future<SocialResponse> providergoogle({body}) async {
    try {
      final response = await BaseClient.sharedClient.postPreLogin(
        endPoint: AppConstants.providergoogle,
        body: body,
      );
      // print("response=====$response");
      print("response=====$response");
      return SocialResponse.fromJson(response as Map<String, dynamic>);
    } catch (exception) {
      print("response=====$exception");
      rethrow;
    }
  }
}
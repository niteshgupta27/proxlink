import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../routes/app_pages.dart';
import 'AppConstants.dart';
import 'Apputills.dart';
import 'app_exception.dart';
import 'app_storage.dart';

class BaseClient extends GetConnect {
  String TAG = "BaseClient";
  static BaseClient sharedClient = BaseClient();
  static const int timeOutDuration = 50;

  // Use a getter so it doesn't crash if called before Get.put
  AppStorage get _appStorage => Get.find<AppStorage>();

  Map<String, String> requestHeaders() {
    return <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_appStorage.loggedInUserToken}'
    };
  }

  Future<dynamic> postRequest({
    required String endPoint,
    required dynamic body,
  }) async {
    final uri = AppConstants.baseUrl + endPoint;
    final payload = json.encode(body);
    try {
      print("Api url===$uri");
      final response = await http.post(
        Uri.parse(uri),
        body: payload,
        headers: requestHeaders(),
      ).timeout(const Duration(seconds: timeOutDuration));
      
      return _processResponse(response);
    } catch (exception) {
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) {
    var body = json.decode(response.body);
    final url = response.request!.url.toString();

    switch (response.statusCode) {
      case 200:
      case 201:
        return body;
      case 401:
        // Check if we are in the background (no active navigator)
        if (Get.context != null) {
          _appStorage.resetStorage();
          Get.offAllNamed(Routes.LOGINSCREEN);
        }
        throw BadRequestException('Session expired', url);
      default:
        throw FetchDataException('Error: ${response.statusCode}', url);
    }
  }
}

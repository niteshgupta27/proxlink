import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../routes/app_pages.dart';
import 'AppConstants.dart';
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

  Future<dynamic> postMultipartRequest({
    required String endPoint,
    required Map<String, dynamic> body,
    required File file,
    required String fileKey,
  }) async {
    final uri = Uri.parse(AppConstants.baseUrl + endPoint);
    try {
      var request = http.MultipartRequest('POST', uri);
      
      // Add headers
      request.headers.addAll(requestHeaders());
      
      // Add fields
      body.forEach((key, value) {
        if (value is Map) {
          request.fields[key] = json.encode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });
      
      // Add file
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile(
        fileKey,
        stream,
        length,
        filename: basename(file.path),
        contentType: MediaType('image', 'jpeg'), // Adjust based on file type if needed
      );
      request.files.add(multipartFile);
      
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      
      return _processResponse(http.Response(responseString, response.statusCode, request: request));
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

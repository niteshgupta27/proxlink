import 'package:get/get.dart';
import '../../../Utill/AppConstants.dart';
import '../../../Utill/Apputills.dart';
import '../../../Utill/app_base_client.dart';
import '../../../Utill/app_storage.dart';
import '../../../Utill/dialog_helper.dart';

class NetworkController extends GetxController {
  final appStorage = Get.find<AppStorage>();
  var isLoading = false.obs;
  
  Future<void> sendLocation({
    required double lat,
    required double lng,
    required double accuracy,
    required double speed,
    required bool isMoving,
  }) async {
    try {
      final body = {
        "api_key": appStorage.loggedInUserToken,
        "device_id": "DEVICE_ID",
        "user_id": appStorage.loggedInUserId?.toString() ?? "0",
        "payload": {
          "accuracy_m": accuracy.toString(),
          "device_time": DateTime.now().toIso8601String(),
          "is_active": "1",
          "is_moving": isMoving ? "1" : "0",
          "lat": lat.toString(),
          "lng": lng.toString(),
          "speed_mps": speed.toString()
        }
      };

      await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.location_update,
        body: body,
      );
    } catch (e) {
      print("Error sending location: $e");
    }
  }

  /// Joins a network using the scanned network ID
  Future<void> joinNetwork(String networkId) async {
    isLoading.value = true;
   // DialogHelper.showLoading();

    try {
      final body = {
        "api_key": appStorage.loggedInUserToken,
        "user_id": appStorage.loggedInUserId?.toString() ?? "0",
        "payload": {
          "network_id": networkId
        }
      };

      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.networks_join,
        body: body,
      );

      //DialogHelper.hideLoading();
      isLoading.value = false;

      if (response != null && response['status'] == 'success') {
        AppUtils.showSnackbar(response['message'] ?? "Joined successfully", "Success");
      } else {
        AppUtils.showSnackbar(response?['message'] ?? "Failed to join network", "Error");
      }
    } catch (e) {
      //DialogHelper.hideLoading();
      isLoading.value = false;
      AppUtils.showSnackbar("Something went wrong: $e", "Oops");
    }
  }
}

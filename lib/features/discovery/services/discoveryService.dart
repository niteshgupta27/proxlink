
import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_base_client.dart';
import '../model/discovery_Model.dart';

class Discoveryservice {
  String TAG = "Discoveryservice";
  Future<DiscoveryModelResponse> getDiscovery({body}) async {
    try {
      print("body===========$body");
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.users_map,
        body: body,
      );
      // print("response=====$response");
      print("response1=====$response");
      return DiscoveryModelResponse.fromJson(response as Map<String, dynamic>);
    } catch (exception) {
      print("response exception=====$exception");
      rethrow;
    }
  }
}
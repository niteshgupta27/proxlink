
import '../../Utill/AppConstants.dart';
import '../../Utill/app_base_client.dart';
import '../discovery/model/discovery_Model.dart';

class Networkservice {
  String TAG = "Networkservice";
  Future<DiscoveryModelResponse> getevents({body}) async {
    try {
      print("body===========$body");
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.event_List,
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
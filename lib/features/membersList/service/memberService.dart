import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_base_client.dart';
import '../../discovery/model/discovery_Model.dart';
import '../model/memberModel.dart';

class Memberserviceservice {
  String TAG = "Networkservice";
  Future<MemberModelResponse> getevents({body}) async {
    try {
      print("body===========$body");
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.member_List,
        body: body,
      );
      // print("response=====$response");
      print("response1=====$response");
      return MemberModelResponse.fromJson(response as Map<String, dynamic>);
    } catch (exception) {
      print("response exception=====$exception");
      rethrow;
    }
  }
}
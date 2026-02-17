import '../../../Utill/app_base_client.dart';
import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_storage.dart';
import 'package:get/get.dart';

import '../auth/Login/models/login_response.dart';
import 'model/addeventmodel.dart';
import 'model/eventModel.dart';

class EventService {
  final BaseClient _baseClient = BaseClient.sharedClient;

  Future<NetworkListResponse> getNetworkList({body}) async {
    try {
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.event_List,
        body: body,
      );
      // print("response=====$response");
      print("response1=====$response");
      return NetworkListResponse.fromJson(response as Map<String, dynamic>);
    } catch (exception) {
      print("response exception=====$exception");
      rethrow;
    }
  }
  Future<AddeventModelResponse> CreateNetwork({body}) async {
    try {
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.networks_create,
        body: body,
      );
      // print("response=====$response");
      print("response1=====$response");
      return AddeventModelResponse.fromJson(response as Map<String, dynamic>);
    } catch (exception) {
      print("response exception=====$exception");
      rethrow;
    }
  }
}

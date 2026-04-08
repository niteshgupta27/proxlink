import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_base_client.dart';
import '../model/MyZoneListResponse.dart';
import '../model/ZoneDetailResponse.dart';
import '../model/zone_model.dart';

class ZoneService {
  Future<ZoneModelResponse> getZoneMapRealtime({required Map<String, dynamic> body}) async {
    try {
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.zone_map_realtime,
        body: body,
      );
      print("response1=====$response");
      return ZoneModelResponse.fromJson(response as Map<String, dynamic>);
    } catch (exception) {
      rethrow;
    }
  }

  Future<dynamic> createZone({required Map<String, dynamic> body}) async {
    try {
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.zone_create,
        body: body,
      );
      return response;
    } catch (exception) {
      rethrow;
    }
  }

  Future<ZoneDetailResponse> getZoneDetails({required Map<String, dynamic> body}) async {
    try {
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.zone_details,
        body: body,
      );
      return ZoneDetailResponse.fromJson(response);
    } catch (exception) {
      rethrow;
    }
  }

  Future<dynamic> joinZone({required Map<String, dynamic> body}) async {
    try {
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.zone_join,
        body: body,
      );
      return response;
    } catch (exception) {
      rethrow;
    }
  }

  Future<dynamic> leaveZone({required Map<String, dynamic> body}) async {
    try {
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.zone_leave,
        body: body,
      );
      return response;
    } catch (exception) {
      rethrow;
    }
  }

  Future<MyZoneListResponse> getMyMemberships({required Map<String, dynamic> body}) async {
    try {
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.zone_membership,
        body: body,
      );
      return MyZoneListResponse.fromJson(response);
    } catch (exception) {
      rethrow;
    }
  }

  Future<MyZoneListResponse> getMyOwnerships({required Map<String, dynamic> body}) async {
    try {
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.zone_ownership,
        body: body,
      );
      return MyZoneListResponse.fromJson(response);
    } catch (exception) {
      rethrow;
    }
  }
}

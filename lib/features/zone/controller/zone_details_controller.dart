import 'package:get/get.dart';
import 'package:proxlink/Utill/app_storage.dart';
import 'package:proxlink/features/zone/model/ZoneDetailResponse.dart';
import 'package:proxlink/features/zone/model/zone_model.dart';
import 'package:proxlink/features/zone/model/MyZoneListResponse.dart';
import 'package:proxlink/features/zone/service/zone_service.dart';

class ZoneDetailsController extends GetxController {
  final appStorage = Get.find<AppStorage>();
  final zoneService = Get.find<ZoneService>();

  var isLoading = false.obs;
  var detailResponse = Rxn<ZoneDetailResponse>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      if (args is ZoneData) {
        _setupInitialDataFromZoneData(args);
        fetchZoneDetails(args.zoneId.toString());
      } else if (args is ZoneList) {
        _setupInitialDataFromZoneList(args);
        fetchZoneDetails(args.zoneId.toString());
      }
    }
  }

  void _setupInitialDataFromZoneData(ZoneData data) {
    detailResponse.value = ZoneDetailResponse(
      status: '',
      zone: Zone(
        zoneId: data.zoneId,
        name: data.name,
        purpose: data.purpose,
        membersCount: data.membersCount,
      ),
      isMember: data.isMember ? 1 : 0,
      isOwner: 0,
      role: '',
      distanceKm: (data.distanceM / 1000).toInt(),
      skills: data.skills,
    );
  }

  void _setupInitialDataFromZoneList(ZoneList data) {
    detailResponse.value = ZoneDetailResponse(
      status: '',
      zone: Zone(
        zoneId: data.zoneId,
        name: data.name,
        purpose: data.purpose,
        membersCount: data.membersCount,
      ),
      isMember: data.role != null ? 1 : 0,
      isOwner: data.role == 'owner' ? 1 : 0,
      role: data.role,
      distanceKm: 0,
      skills: [],
    );
  }

  Future<void> fetchZoneDetails(String zoneId) async {
    isLoading.value = true;

    final body = {
      "user_id": appStorage.loggedInUserId ?? 786,
      "api_key": appStorage.loggedInUserToken.isNotEmpty ? appStorage.loggedInUserToken : "API_KEY",
      "payload": {"zone_id": zoneId}
    };

    try {
      final response = await zoneService.getZoneDetails(body: body);
      if (response.status == 'success') {
        detailResponse.value = response;
      }
    } catch (e) {
      print("Error fetching zone details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleZoneJoin() async {
    if (detailResponse.value?.zone?.zoneId == null) return;

    bool isCurrentlyMember = detailResponse.value?.isMember == 1;
    isLoading.value = true;
    
    final body = {
      "user_id": appStorage.loggedInUserId ?? 786,
      "api_key": appStorage.loggedInUserToken.isNotEmpty ? appStorage.loggedInUserToken : "API_KEY",
      "payload": {"zone_id": detailResponse.value!.zone!.zoneId}
    };

    try {
      final response = isCurrentlyMember 
          ? await zoneService.leaveZone(body: body)
          : await zoneService.joinZone(body: body);

      if (response != null && response['status'] == 'success') {
        Get.snackbar("Success", response['message'] ?? "Action successful");
        fetchZoneDetails(detailResponse.value!.zone!.zoneId.toString());
      } else {
        Get.snackbar("Error", response?['message'] ?? "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to perform action");
      print("Error toggling zone status: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinZone() async {
    toggleZoneJoin();
  }
}

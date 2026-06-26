import 'package:get/get.dart';
import 'package:proxlink/Utill/app_storage.dart';
import 'package:proxlink/features/zone/service/zone_service.dart';

import '../model/MyZoneListResponse.dart';

class MyZonesController extends GetxController {
  final appStorage = Get.find<AppStorage>();
  final zoneService = Get.find<ZoneService>();

  var isLoading = false.obs;
  var zoneList = <ZoneList>[].obs;
  var title = "".obs;
  var type = "".obs; // 'membership' or 'ownership'

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      type.value = args['type'] ?? 'membership';
      title.value = type.value == 'membership' ? "Zones you are member of" : "Zones you own";
      fetchMyZones();
    }
  }

  Future<void> fetchMyZones() async {
    isLoading.value = true;
    final body = {
      "user_id": appStorage.loggedInUserId?.toString() ?? "786",
      "api_key": appStorage.loggedInUserToken.isNotEmpty ? appStorage.loggedInUserToken : "API_KEY",
    };

    try {
      final response = type.value == 'membership' 
          ? await zoneService.getMyMemberships(body: body)
          : await zoneService.getMyOwnerships(body: body);
      
      if (response.status == "success") {
        zoneList.value = response.zones!;
      }
    } catch (e) {
      print("Error fetching my zones: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

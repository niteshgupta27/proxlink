import 'package:get/get.dart';
import '../../../Utill/app_storage.dart';
import '../eventservice.dart';
import '../../membersList/model/NetworkModel.dart';

class EventListController extends GetxController {
  final EventService _eventService = EventService();
  RxList<NetworkModel> networks = <NetworkModel>[].obs;
  var isLoading = false.obs;
  final AppStorage _appStorage = Get.find<AppStorage>();
  var view_as = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final argument =Get.arguments;
    if(argument != null){
      view_as.value=argument['view_as'];
      fetchNetworks();
    }

  }

  Future<void> fetchNetworks() async {
    Map<String, dynamic> body = {
      "api_key": _appStorage.loggedInUserToken, // You might want to get this from constants if available
      "user_id": _appStorage.loggedInUserId.toString(),
      "payload": {
        "view_as": view_as.value
      }
    };
    try {
      isLoading.value = true;
      var response = await _eventService.getNetworkList(body: body);
      
      if (response.status == "success" ) {
        networks.value=response.networks!;
        // List<dynamic> data = response['data'] ?? [];
        // networks.assignAll(data.map((e) => NetworkModel.fromJson(e)).toList());
      }
    } catch (e) {
      print("Error fetching networks: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

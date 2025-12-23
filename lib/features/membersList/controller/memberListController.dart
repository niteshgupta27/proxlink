import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_required.dart';
import '../../../Utill/app_storage.dart';
import '../model/NetworkModel.dart';


class MemberListController extends GetxController {
  String TAG = "SplashController";
  var networks = <NetworkModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNetworks();
  }

  void fetchNetworks() {
    // Simulating data fetch from an API
    var serverData = List.generate(6, (index) => NetworkModel(
      title: "Sheraton - Google dev summit",
      imageUrl: "https://via.placeholder.com/150", // Replace with your image link
      memberCount: 20,
    ));
    networks.assignAll(serverData);
  }

}

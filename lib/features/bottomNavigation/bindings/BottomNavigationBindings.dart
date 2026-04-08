import 'package:get/get.dart';
import 'package:proxlink/features/Chat/controller/chatController.dart';
import 'package:proxlink/features/bottomNavigation/controllers/bottom_navigation_controller.dart';
import 'package:proxlink/features/discovery/controller/discoveryController.dart';
import 'package:proxlink/features/discovery/services/discoveryService.dart';
import 'package:proxlink/features/job/controller/jobController.dart';
import 'package:proxlink/features/job/services/jobService.dart';
import 'package:proxlink/features/network/controller/NetworkController.dart';
import 'package:proxlink/features/zone/controller/zone_controller.dart';
import 'package:proxlink/features/zone/service/zone_service.dart';


class BottomNavigationBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<BottomNavigationController>(() => BottomNavigationController());
    
    // Services
    Get.lazyPut<Discoveryservice>(() => Discoveryservice(), fenix: true);
    Get.lazyPut<JobService>(() => JobService(), fenix: true);
    Get.lazyPut<ZoneService>(() => ZoneService(), fenix: true);
    
    // Controllers
    Get.lazyPut<DiscoveryController>(() => DiscoveryController(), fenix: true);
    Get.lazyPut<NetworkController>(() => NetworkController(), fenix: true);
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
    Get.lazyPut<JobController>(() => JobController(), fenix: true);
    Get.lazyPut<ZoneController>(() => ZoneController(), fenix: true);
  }
}

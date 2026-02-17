import 'package:get/get.dart';
import 'package:proxlink/features/Chat/controller/chatController.dart';
import 'package:proxlink/features/bottomNavigation/controllers/bottom_navigation_controller.dart';
import 'package:proxlink/features/discovery/controller/discoveryController.dart';
import 'package:proxlink/features/discovery/services/discoveryService.dart';
import 'package:proxlink/features/network/controller/NetworkController.dart';


class BottomNavigationBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<BottomNavigationController>(() => BottomNavigationController());
    Get.lazyPut<DiscoveryController>(() => DiscoveryController());
    Get.lazyPut<Discoveryservice>(() => Discoveryservice());
    Get.lazyPut<NetworkController>(() => NetworkController());
    Get.lazyPut<ChatController>(() => ChatController());
  }
}

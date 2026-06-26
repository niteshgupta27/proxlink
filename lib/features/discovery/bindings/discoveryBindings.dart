import 'package:get/get.dart';

import '../controller/discoveryController.dart';
import '../services/discoveryService.dart';


class DiscoveryBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<DiscoveryController>(() => DiscoveryController());
    Get.lazyPut<Discoveryservice>(
          () => Discoveryservice(),
    );
  }

}
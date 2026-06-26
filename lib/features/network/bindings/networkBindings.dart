import 'package:get/get.dart';
import 'package:proxlink/features/network/controller/ShearQRController.dart';

import '../controller/NetworkController.dart';


class NetworkBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<NetworkController>(() => NetworkController());
    Get.lazyPut<ShearQRController>(() => ShearQRController());

  }

}
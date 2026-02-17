import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:proxlink/features/network/controller/ShearQRController.dart';

import '../../../Utill/app_required.dart';
import '../controller/NetworkController.dart';


class NetworkBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<NetworkController>(() => NetworkController());
    Get.lazyPut<ShearQRController>(() => ShearQRController());

  }

}
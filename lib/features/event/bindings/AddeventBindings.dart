import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:proxlink/features/event/controller/eventlistController.dart';

import '../../../Utill/app_required.dart';
import '../controller/AddeventController.dart';


class AddeventBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AddeventController>(() => AddeventController());
    Get.lazyPut<EventListController>(() => EventListController());

  }

}
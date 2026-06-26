import 'package:get/get.dart';
import 'package:proxlink/features/event/controller/eventlistController.dart';

import '../controller/AddeventController.dart';


class AddeventBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AddeventController>(() => AddeventController());
    Get.lazyPut<EventListController>(() => EventListController());

  }

}
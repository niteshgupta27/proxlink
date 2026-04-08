import 'package:get/get.dart';
import '../controller/my_zones_controller.dart';

class MyZonesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyZonesController>(() => MyZonesController());
  }
}

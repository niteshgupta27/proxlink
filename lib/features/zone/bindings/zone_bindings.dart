import 'package:get/get.dart';
import '../controller/zone_controller.dart';

class ZoneBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ZoneController>(() => ZoneController(), fenix: true);
  }
}

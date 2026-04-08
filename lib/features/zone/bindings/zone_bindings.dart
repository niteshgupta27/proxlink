import 'package:get/get.dart';
import '../controller/zone_controller.dart';
import '../controller/create_zone_controller.dart';
import '../controller/zone_details_controller.dart';
import '../service/zone_service.dart';

class ZoneBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ZoneService>(() => ZoneService(), fenix: true);
    Get.lazyPut<ZoneController>(() => ZoneController(), fenix: true);
    Get.lazyPut<CreateZoneController>(() => CreateZoneController(), fenix: true);
    Get.lazyPut<ZoneDetailsController>(() => ZoneDetailsController(), fenix: true);
  }
}

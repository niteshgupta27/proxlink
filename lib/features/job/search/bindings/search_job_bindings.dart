import 'package:get/get.dart';
import '../controller/search_job_controller.dart';

class SearchJobBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchJobController>(() => SearchJobController());
  }
}

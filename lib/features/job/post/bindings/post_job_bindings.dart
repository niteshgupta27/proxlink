import 'package:get/get.dart';
import '../controller/post_job_controller.dart';

class PostJobBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostJobController>(() => PostJobController());
  }
}

import 'package:get/get.dart';
import '../controller/jobController.dart';
import '../services/jobService.dart';


class JobBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<JobController>(() => JobController(), fenix: true);
    Get.lazyPut<JobService>(() => JobService());
  }

}

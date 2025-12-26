import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../../Utill/app_required.dart';
import '../controller/jobController.dart';


class JobBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<JobController>(() => JobController());
  }

}
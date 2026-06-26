import 'package:get/get.dart';

import '../controller/memberListController.dart';


class MemberListBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<MemberListController>(() => MemberListController());
  }

}
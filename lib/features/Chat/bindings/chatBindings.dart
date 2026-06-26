import 'package:get/get.dart';

import '../controller/chatController.dart';


class ChatBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
  }

}
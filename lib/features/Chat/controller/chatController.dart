import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Utill/Apputills.dart';
import '../../../Utill/app_storage.dart';
import '../services/chat_service.dart';
import '../../../routes/app_pages.dart';
import '../model/chat_list_model.dart';

class ChatController extends GetxController {
  String TAG = "ChatController";
  final appStorage = Get.find<AppStorage>();
  final chatService = ChatService();

  var localImagePath = "".obs;
  RxBool isLoading = false.obs;

  RxList<ChatData> chatList = <ChatData>[].obs;

  @override
  void onInit() {
    super.onInit();
    getChatList();
  }

  Future<void> getChatList() async {
    isLoading.value = true;
    try {
      final response = await chatService.getChatList(
        userId: appStorage.loggedInUserId ?? 0,
        apiKey: appStorage.loggedInUserToken,
      );

      if (response.status == 'success') {
        chatList.value = response.chats ?? [];
      }
    } catch (e) {
      print("Error in getChatList: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> navigateToChat({required int otherUserId, required String otherUserName}) async {
    AppUtils.showLoading();
    try {
      final response = await chatService.getOrCreateChat(
        userId: appStorage.loggedInUserId ?? 0,
        apiKey: appStorage.loggedInUserToken,
        otherUserId: otherUserId,
      );

      AppUtils.hideLoading();
      if (response != null && response['status'] == 'success') {
        int chatId = int.tryParse(response['chat_id'].toString()) ?? 0;
        
        ChatData chatData = ChatData(
          chatId: chatId,
          displayName: otherUserName,
          user: ChatUser(
            userId: otherUserId,
            name: otherUserName,
          ),
        );
        Get.toNamed(Routes.CHAT_DETAILS, arguments: chatData);
      } else {
        AppUtils.showSnackbar(response?['message'] ?? "Failed to create chat", "Error");
      }
    } catch (e) {
      AppUtils.hideLoading();
      debugPrint("Error in navigateToChat: $e");
      AppUtils.showSnackbar("Something went wrong", "Error");
    }
  }
}

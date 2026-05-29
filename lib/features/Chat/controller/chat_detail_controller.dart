import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Utill/app_storage.dart';
import '../model/chat_list_model.dart';
import '../model/message_model.dart';
import '../services/chat_service.dart';
import 'dart:io';
import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_base_client.dart';
import 'package:proxlink/Utill/Apputills.dart';

class ChatDetailController extends GetxController {
  final ChatService chatService = ChatService();
  final AppStorage appStorage = Get.find<AppStorage>();
  
  late ChatData chatData;
  var messages = <Message>[].obs;
  var isLoading = false.obs;
  var isSending = false.obs;
  var onlineStatus = "Offline".obs;
  
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool _isTyping = false;
  DateTime? _lastTypingTime;
  Timer? _messageTimer;
  bool _isFetching = false;

  @override
  void onInit() {
    super.onInit();
    chatData = Get.arguments;
    getMessages(showLoading: true);
    sendOnlineStatus(true);
    
    messageController.addListener(_onTextChanged);
    _messageTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      getMessages(showLoading: false);
    });
  }

  void _onTextChanged() {
    if (messageController.text.isNotEmpty && !_isTyping) {
      _isTyping = true;
      _sendTypingStatus(true);
    } else if (messageController.text.isEmpty && _isTyping) {
      _isTyping = false;
      _sendTypingStatus(false);
    }
    
    _lastTypingTime = DateTime.now();
    Future.delayed(const Duration(seconds: 2), () {
      if (_isTyping && _lastTypingTime != null && 
          DateTime.now().difference(_lastTypingTime!) >= const Duration(seconds: 2)) {
        _isTyping = false;
        _sendTypingStatus(false);
      }
    });
  }

  Future<void> _sendTypingStatus(bool isTyping) async {
    try {
      await chatService.sendTypingStatus(
        userId: appStorage.loggedInUserId ?? 0,
        apiKey: appStorage.loggedInUserToken,
        chatId: chatData.chatId ?? 0,
        isTyping: isTyping,
      );
    } catch (e) {
      print("Error sending typing status: $e");
    }
  }

  Future<void> getMessages({bool showLoading = false}) async {
    if (_isFetching) return;
    _isFetching = true;
    
    if (showLoading) isLoading.value = true;
    try {
      final response = await chatService.getMessages(
        chat_id: chatData.chatId ?? 0,
        last_id: 0,
        userId: appStorage.loggedInUserId ?? 0,
        apiKey: appStorage.loggedInUserToken,
      );

      if (response != null && response.status == 'success') {
        final newMessages = response.messages ?? [];
        if (newMessages.length != messages.length || 
            (newMessages.isNotEmpty && messages.isNotEmpty && newMessages.last.messageId != messages.last.messageId)) {
          messages.value = newMessages;
          _scrollToBottom();
          markAsRead();
        }
      }
    } catch (e) {
      print("Error fetching messages: $e");
    } finally {
      if (showLoading) isLoading.value = false;
      _isFetching = false;
    }
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    String text = messageController.text.trim();
    messageController.clear();
    
    // Optimistic update
    Message tempMsg = Message(
      messageId: -1,
      chatId: chatData.chatId,
      senderId: appStorage.loggedInUserId,
      message: text,
      messageType: "TEXT",
      createdAt: DateTime.now().toString(),
    );
    messages.add(tempMsg);
    _scrollToBottom();

    try {
      final response = await chatService.sendMessage(
        chat_id: chatData.chatId ?? 0,
        message: text,
        type: "TEXT",
        userId: appStorage.loggedInUserId ?? 0,
        apiKey: appStorage.loggedInUserToken,
      );

      if (response != null && response['status'] == 'success') {
        getMessages();
      }
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<void> markAsRead() async {
    if (messages.isEmpty) return;
    try {
      await chatService.markRead(
        chat_id: chatData.chatId ?? 0,
        last_message_id: messages.last.messageId ?? 0,
        userId: appStorage.loggedInUserId ?? 0,
        apiKey: appStorage.loggedInUserToken,
      );
      await chatService.markDelivered(
        chat_id: chatData.chatId ?? 0,
        last_message_id: messages.last.messageId ?? 0,
        userId: appStorage.loggedInUserId ?? 0,
        apiKey: appStorage.loggedInUserToken,
      );
    } catch (e) {
      print("Error marking as read: $e");
    }
  }

  Future<void> sendOnlineStatus(bool isOnline) async {
    try {
      await chatService.setUserOnlineStatus(
        userId: appStorage.loggedInUserId ?? 0,
        apiKey: appStorage.loggedInUserToken,
        isOnline: isOnline,
      );
    } catch (e) {
      print("Error setting online status: $e");
    }
  }

  Future<XFile?> getImage() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> pickImage() async {
    final XFile? image = await getImage();
    if (image != null) {
      AppUtils.showLoading();
      try {
        final body = {
          "chat_id": chatData.chatId,
        };

        // Call /chat/upload.php
        final response = await BaseClient.sharedClient.postMultipartRequest(
          endPoint: AppConstants.chat_upload,
          body: body,
          file: File(image.path),
          fileKey: "file"
        );
        
        if (response != null && response['status'] == 'success') {
          // If success, call uploadChatImage
          uploadChatImage(response['url']);
        } else {
          AppUtils.hideLoading();
          AppUtils.showSnackbar(response?['message'] ?? "Upload failed", "Error");
        }
      } catch (e) {
        AppUtils.hideLoading();
        print("Error uploading image: $e");
        AppUtils.showSnackbar("Something went wrong during upload", "Error");
      }
    }
  }

  Future<void> uploadChatImage(String url) async {
    AppUtils.hideLoading();
    try {
      final response = await chatService.sendMessage(
        chat_id: chatData.chatId ?? 0,
        message: url,
        type: "IMAGE",
        userId: appStorage.loggedInUserId ?? 0,
        apiKey: appStorage.loggedInUserToken,
      );

      if (response != null && response['status'] == 'success') {
        getMessages();
      }
    } catch (e) {
      print("Error sending message: $e");
    }
    // After success, refresh messages to show the new image
    getMessages();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    _messageTimer?.cancel();
    sendOnlineStatus(false);
    if (_isTyping) {
      _sendTypingStatus(false);
    }
    messageController.removeListener(_onTextChanged);
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

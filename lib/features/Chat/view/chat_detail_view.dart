import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proxlink/Utill/AppConstants.dart';
import 'package:proxlink/common/widget/custom_popup_menu_item.dart';
import '../../../Utill/app_colors.dart';
import '../controller/chat_detail_controller.dart';
import '../model/message_model.dart';
import 'package:intl/intl.dart';

class ChatDetailView extends GetView<ChatDetailController> {
  const ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: false,
        backgroundColor: AppColors.primaryColor,
        leadingWidth: 70,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Row(
            children: [
              const SizedBox(width: 5),
              const Icon(Icons.arrow_back, color: Colors.white),
              const SizedBox(width: 5),
              CircleAvatar(
                radius: 18,
                backgroundImage: controller.chatData.otherUserImage != null &&
                        controller.chatData.otherUserImage!.isNotEmpty
                    ? NetworkImage(controller.chatData.otherUserImage!)
                    : null,
                child: controller.chatData.otherUserImage == null ||
                        controller.chatData.otherUserImage!.isEmpty
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.chatData.otherUserName ?? "User",
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Obx(() => Text(
                  controller.onlineStatus.value,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                )),
          ],
        ),
        // actions: [
        //   PopupMenuButton<String>(
        //     icon: const Icon(Icons.more_vert, color: Colors.white),
        //     onSelected: (value) {
        //       if (value == 'clear') {
        //         // TODO: Implement clear chat
        //       } else if (value == 'block') {
        //         // TODO: Implement block user
        //       }
        //     },
        //     itemBuilder: (context) => [
        //       CustomPopupMenuItem(
        //         value: 'clear',
        //         icon: Icons.delete_outline,
        //         label: 'Clear Chat',
        //       ),
        //       CustomPopupMenuItem(
        //         value: 'block',
        //         icon: Icons.block,
        //         label: 'Block User',
        //         textColor: Colors.red,
        //         iconColor: Colors.red,
        //       ),
        //     ],
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(15),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    final isMe = message.senderId == controller.appStorage.loggedInUserId;
                    
                    return _buildMessageBubble(message, isMe);
                  },
                )),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe) {
    bool isImage = message.messageType == "IMAGE";

    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: isImage
              ? () {
                  String imageUrl = (message.message ?? "").isNotEmpty
                      ? AppConstants.ImaepathHost + message.message!
                      : "";
                  if (imageUrl.isNotEmpty) _showImagePreview(imageUrl);
                }
              : null,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: isImage ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFC7E2FF) : const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 20),
              ),
            ),
            constraints: BoxConstraints(maxWidth: Get.width * 0.7),
            child: isImage
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 20),
                    ),
                    child: Image.network(
                      (message.message ?? "").isNotEmpty
                          ? AppConstants.ImaepathHost + message.message!
                          : "",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  )
                : Text(
                    message.message ?? "",
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
          child: Text(
            _formatTime(message.createdAt),
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ),
      ],
    );
  }

  void _showImagePreview(String imageUrl) {
    if (imageUrl.isEmpty) return;
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                color: Colors.black.withOpacity(0.9),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                },
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.broken_image, size: 60, color: Colors.white),
                      SizedBox(height: 10),
                      Text("Could not load image", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () => controller.pickImage(),
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryColor,
                        radius: 18,
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
                        decoration: const InputDecoration(
                          hintText: "Type Message",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () => controller.sendMessage(),
              child: CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                radius: 22,
                child: const Icon(Icons.send, color: Colors.white), // Using mic icon as per image, but logically it should switch to send
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return "";
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('h:mm a').format(dt);
    } catch (e) {
      return "";
    }
  }
}

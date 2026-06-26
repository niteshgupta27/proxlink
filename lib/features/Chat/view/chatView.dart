
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../Utill/app_colors.dart';
import '../../../common/widget/custom_loader_widget.dart';
import '../../../routes/app_pages.dart';
import '../controller/chatController.dart';



class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {

    return Obx(()=>Scaffold( appBar: AppBar(
      backgroundColor: AppColors.primaryColor,
      title: const Text("Messages", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      actions: [
        IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
        // const CustomPopupMenu(),
      ],
    ),
      backgroundColor: AppColors.whites,
      body: controller.isLoading.value == true
          ? Center(
              child: CustomLoaderWidget(
              color: AppColors.primaryColor,
            ))
          : controller.chatList.isEmpty
              ? const Center(child: Text("No messages yet"))
              : ListView.separated(
                  itemCount: controller.chatList.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
                  itemBuilder: (context, index) {
                    var chat = controller.chatList[index];
                    return ListTile(
                      onTap: () {
                        // Navigate to Chat Detail Screen
                        Get.toNamed(Routes.CHAT_DETAILS, arguments: chat);
                      },
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.width * 0.04,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        radius: context.responsiveValue(mobile: 28.0, tablet: 35.0),
                        backgroundColor: AppColors.primaryColor.withValues(alpha: 0.2),
                        backgroundImage: chat.otherUserImage != null && chat.otherUserImage!.isNotEmpty
                            ? NetworkImage(chat.otherUserImage!)
                            : null,
                        child: chat.otherUserImage == null || chat.otherUserImage!.isEmpty
                            ? Text(
                                chat.otherUserName?.substring(0, 1).toUpperCase() ?? "",
                                style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                              )
                            : null,
                      ),
                      title: Text(
                        chat.otherUserName ?? "Unknown",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        chat.lastMessage ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(chat.lastMessageTime ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 4),
                          if (chat.unreadCount != null && chat.unreadCount! > 0)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                chat.unreadCount.toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            )
                          else
                            const Icon(Icons.done_all, size: 16, color: Colors.grey),
                        ],
                      ),
                    );
                  },
                ),
    )
    );
  }



  }


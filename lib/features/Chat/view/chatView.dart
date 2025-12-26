import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proxlink/features/discovery/controller/discoveryController.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../Utill/Images.dart';
import '../../../Utill/app_colors.dart';
import '../../../Utill/app_required.dart';
import '../../../common/widget/custom_loader_widget.dart';
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
      ],
    ),
      backgroundColor: AppColors.whites,
      body:controller.isLoading==true?  Center(child: CustomLoaderWidget(color: AppColors.primaryColor,)) :

       ListView.separated(
        itemCount: controller.messages.length,
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
        itemBuilder: (context, index) {
          var chat = controller.messages[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.width * 0.04, // Responsive horizontal padding
              vertical: 8,
            ),
            leading: CircleAvatar(
              radius: context.responsiveValue(mobile: 28.0, tablet: 35.0), // Dynamic sizing
              backgroundColor: Colors.blueAccent,
              child: Text(
                chat['initials']!,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              chat['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              chat['msg']!,
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat['time']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
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


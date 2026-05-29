import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../membersList/model/NetworkModel.dart';
import '../controller/AddeventController.dart';

class AddeventView extends GetView<AddeventController> {
  const AddeventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whites,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: Center(
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.arrow_back_ios_new, color: AppColors.primaryColor),
            ),
          ),
        ),
        title: const Text(
          "Create a Network/Event",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: AppConstants.fontFamily_Acre, color: AppColors.whites),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputSection(),
            const SizedBox(height: 30),
            const Text(
              "'Hosted Events",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: AppConstants.fontFamily_Acre, color: AppColors.black),
            ),
            const SizedBox(height: 15),
            _buildPreviousEventsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Event name",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: AppConstants.fontFamily_Acre, color: AppColors.black),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.nameController,
              textCapitalization: TextCapitalization.words,
              spellCheckConfiguration: const SpellCheckConfiguration(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter event name';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Type here...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: const TextStyle(fontFamily: AppConstants.fontFamily_Acre, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 20),
            const Text(
              "Description",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: AppConstants.fontFamily_Acre, color: AppColors.black),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.descriptionController,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              spellCheckConfiguration: const SpellCheckConfiguration(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Type here...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: const TextStyle(fontFamily: AppConstants.fontFamily_Acre, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            controller.createEvent();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Create",
                            style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: AppConstants.fontFamily_Acre),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviousEventsList() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: controller.networks.length,
        itemBuilder: (context, index) {
          return _buildNetworkCard(controller.networks[index]);
        },
      ),
    );
  }

  Widget _buildNetworkCard(NetworkModel network) {
    return InkWell(
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            // Top section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor, // Blue circle color
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.groups, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          network.name ?? "",
                          style: const TextStyle(fontSize: 16, fontFamily: AppConstants.fontFamily_Acre, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          network.description ?? "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy",
                          style: const TextStyle(fontSize: 12, fontFamily: AppConstants.fontFamily_Acre, color: Colors.black54, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom section (Blue)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Members",
                        style: TextStyle(fontSize: 11, fontFamily: AppConstants.fontFamily_Acre, color: Colors.white70),
                      ),
                      Text(
                        "${network.totalMembers ?? 0} members",
                        style: const TextStyle(fontSize: 14, fontFamily: AppConstants.fontFamily_Acre, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  // Overlapping avatars
                  // SizedBox(
                  //   width: 80,
                  //   height: 30,
                  //   child: Stack(
                  //     children: [
                  //       const Positioned(
                  //         right: 40,
                  //         child: CircleAvatar(
                  //           radius: 14,
                  //           backgroundColor: Colors.white,
                  //           child: CircleAvatar(
                  //             radius: 13,
                  //             backgroundImage: NetworkImage(
                  //               "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjUM6RjCVFkhLB_YuYGcuV2lw8Zukn6VASqzKRwM4klEhdfbGfJomXQ3oRDHurkHuHf9IaEhRkx2iYblYIlMTJgPiSfPkxndw6yuwKN8EZGDzzqHcoBoTj2Hf-iDEiZLDM8mEwjvp0Br7Ar/s1600/digital+painting+of+avtar.jpg",
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       const Positioned(
                  //         right: 25,
                  //         child: CircleAvatar(
                  //           radius: 14,
                  //           backgroundColor: Colors.white,
                  //           child: CircleAvatar(
                  //             radius: 13,
                  //             backgroundImage: NetworkImage(
                  //               "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjUM6RjCVFkhLB_YuYGcuV2lw8Zukn6VASqzKRwM4klEhdfbGfJomXQ3oRDHurkHuHf9IaEhRkx2iYblYIlMTJgPiSfPkxndw6yuwKN8EZGDzzqHcoBoTj2Hf-iDEiZLDM8mEwjvp0Br7Ar/s1600/digital+painting+of+avtar.jpg",
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       Positioned(
                  //         right: 0,
                  //         child: Container(
                  //           width: 28,
                  //           height: 28,
                  //           decoration: BoxDecoration(
                  //             color: const Color(0xFFC0DAFF),
                  //             shape: BoxShape.circle,
                  //             border: Border.all(color: Colors.white, width: 1),
                  //           ),
                  //           alignment: Alignment.center,
                  //           child: const Text(
                  //             "+42",
                  //             style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1877F2)),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Get.toNamed(Routes.shearqr, arguments: {"network_id": network.networkId.toString(), "network_name": network.name});
      },
    );
  }
}

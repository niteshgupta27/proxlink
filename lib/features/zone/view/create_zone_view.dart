import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proxlink/Utill/AppConstants.dart';
import 'package:proxlink/Utill/app_colors.dart';
import '../controller/create_zone_controller.dart';
import 'location_picker_view.dart';

class CreateZoneView extends GetView<CreateZoneController> {
  const CreateZoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        toolbarHeight: 80,
        leadingWidth: 70,
        leading: Center(
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
          ),
        ),
        title: const Text(
          "Create Zone",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontFamily_Acre,
            color: Colors.white,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Zone Owned by you: ",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontFamily: AppConstants.fontFamily_Acre,
                      ),
                    ),
                    const TextSpan(
                      text: "5", // This could be dynamic from controller if needed
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConstants.fontFamily_Acre,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Zone Name"),
                  _buildTextField(controller.nameController, "Type here"),
                  const SizedBox(height: 25),
                  
                  _buildLabel("Purpose"),
                  _buildTextArea(controller.purposeController, "Type here"),
                  const SizedBox(height: 25),
                  
                  _buildLabel("Skill Sets"),
                  _buildSkillSection(),
                  const SizedBox(height: 25),
                  
                  _buildLabel("Select your location"),
                  _buildLocationField(),
                  const SizedBox(height: 25),
                  
                  _buildMoveWithOwnerCheckbox(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildCreateButton(),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          fontFamily: AppConstants.fontFamily_Acre,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController textController, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: textController,
        style: const TextStyle(fontFamily: AppConstants.fontFamily_Acre),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTextArea(TextEditingController textController, String hint) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: textController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(fontFamily: AppConstants.fontFamily_Acre),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          contentPadding: const EdgeInsets.all(20),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSkillSection() {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.skillController,
            onSubmitted: (val) => controller.addSkill(val),
            style: const TextStyle(fontFamily: AppConstants.fontFamily_Acre),
            decoration: InputDecoration(
              hintText: "Type here",
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.primaryColor, size: 28),
                onPressed: () => controller.addSkill(controller.skillController.text),
              ),
            ),
          ),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 15),
          Obx(() => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: controller.skills.map((skill) => _buildSkillChip(skill)).toList(),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            skill,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: AppConstants.fontFamily_Acre,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => controller.removeSkill(skill),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField() {
    return GestureDetector(
      onTap: () async {
        final result = await Get.to(() => LocationPickerView(
          initialLat: controller.selectedLat.value != 0 ? controller.selectedLat.value : 12.9716,
          initialLng: controller.selectedLng.value != 0 ? controller.selectedLng.value : 77.5946,
        ));
        
        if (result != null && result is Map<String, dynamic>) {
          controller.selectedLat.value = result['lat'];
          controller.selectedLng.value = result['lng'];
          controller.selectedAddress.value = result['address'];
          controller.locationController.value.text = result['address'];
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller.locationController.value,
          enabled: false, // User must click container to open map
          style: const TextStyle(fontFamily: AppConstants.fontFamily_Acre),
          decoration: InputDecoration(
            hintText: "Select your Current location on the map",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            border: InputBorder.none,
            suffixIcon: const Icon(Icons.location_on, color: AppColors.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildMoveWithOwnerCheckbox() {
    return Row(
      children: [
        Obx(() => GestureDetector(
          onTap: () => controller.moveWithOwner.toggle(),
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
              ),
              color: controller.moveWithOwner.value ? AppColors.primaryColor : Colors.white,
            ),
            child: controller.moveWithOwner.value
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : null,
          ),
        )),
        const SizedBox(width: 12),
        const Text(
          "I want to carry my Zone where ever I go",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontFamily: AppConstants.fontFamily_Acre,
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return Obx(() => InkWell(
      onTap: controller.isLoading.value ? null : () => controller.createZone(),
      child: Container(
        color: AppColors.primaryColor,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: 65,
            alignment: Alignment.center,
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Create",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.fontFamily_Acre,
                    ),
                  ),
          ),
        ),
      ),
    ));
  }
}

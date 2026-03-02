import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Utill/AppConstants.dart';
import '../../../../Utill/Dimensions.dart';
import '../../../../Utill/app_colors.dart';
import '../controller/post_job_controller.dart';

class PostJobView extends GetView<PostJobController> {
  const PostJobView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
            ),
          ),
        ),
        title: const Text(
          "Post Jobs",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontFamily_Acre,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Past Jobs",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.fontFamily_Acre,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Company Name"),
                _buildTextField(controller.companyNameController, "Type here"),
                const SizedBox(height: 25),

                _buildLabel("Job Title"),
                _buildTextField(controller.jobTitleController, "Type here"),
                const SizedBox(height: 25),

                _buildLabel("Job Type"),
                _buildJobTypeCard(),
                const SizedBox(height: 25),

                _buildLabel("Experience"),
                _buildTextField(controller.experienceController, "Type here"),
                const SizedBox(height: 25),

                _buildLabel("Education"),
                _buildTextField(controller.educationController, "Type here"),
                const SizedBox(height: 25),

                _buildLabel("Salary"),
                _buildTextField(controller.salaryController, "Type here"),
                const SizedBox(height: 25),

                _buildLabel("Skill Sets"),
                _buildSkillSetsSection(),
                const SizedBox(height: 25),

                _buildLabel("Office Location"),
                _buildTextField(controller.officeLocationController, "Search on map"),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Obx(() => controller.isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryColor),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: AppConstants.fontFamily_Acre,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whites,
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(fontFamily: AppConstants.fontFamily_Acre, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontFamily: AppConstants.fontFamily_Acre),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildJobTypeCard() {
    final types = ['Full Time', 'Part Time', 'Freelancer'];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: types.map((type) {
          return Obx(() {
            bool isSelected = controller.selectedJobType.value == type;
            return InkWell(
              onTap: () => controller.selectedJobType.value = type,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  border: type != types.last
                      ? Border(bottom: BorderSide(color: Colors.grey.shade100))
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(
                        fontFamily: AppConstants.fontFamily_Acre,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(Icons.check, size: 18, color: AppColors.primaryColor),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _buildSkillSetsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.skillInputController,
            style: const TextStyle(fontFamily: AppConstants.fontFamily_Acre, fontSize: 15),
            onSubmitted: (value) => controller.addSkill(value),
            decoration: InputDecoration(
              hintText: "Type here",
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontFamily: AppConstants.fontFamily_Acre),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Divider(color: Colors.grey.shade100, height: 1),
                ),
                if (controller.skills.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 10.0,
                      children: controller.skills.map((skill) => Container(
                        padding: const EdgeInsets.only(left: 16, right: 6, top: 6, bottom: 6),
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
                                fontWeight: FontWeight.w500,
                                fontFamily: AppConstants.fontFamily_Acre
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
                                child: const Icon(Icons.close, color: AppColors.primaryColor, size: 14),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                  )
                else
                  const SizedBox(height: 10),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      color: AppColors.primaryColor,
      width: double.infinity,
      height: 65,
      child: TextButton(
        onPressed: () => controller.submitJob(),
        child: Obx(() => controller.isLoading.value
            ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontFamily_Acre,
                ),
              )),
      ),
    );
  }
}

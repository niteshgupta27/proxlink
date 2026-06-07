import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proxlink/Utill/app_colors.dart';
import '../../../../Utill/AppConstants.dart';
import '../../../../Utill/Dimensions.dart';
import '../controller/search_job_controller.dart';

class SearchJobView extends GetView<SearchJobController> {
  const SearchJobView({super.key});

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
          "Search Jobs",
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Saved Searches",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.fontFamily_Acre,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Job Type"),
            _buildJobTypeSelector(),
            const SizedBox(height: 25),

            _buildSectionTitle("Job Title"),
            _buildJobTitleInput(),
            const SizedBox(height: 25),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildExperienceDropdown()),
                const SizedBox(width: 20),
                Expanded(child: _buildEducationDropdown()),
              ],
            ),
            const SizedBox(height: 25),

            _buildSectionTitle("Salary Expectation"),
            _buildSalarySlider(context),
            const SizedBox(height: 25),

            _buildSectionTitle("Skill sets"),
            _buildSkillSets(),
            const SizedBox(height: 25),

            _buildSectionTitle("Work Location"),
            _buildWorkLocationSelector(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveSearchButton(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: AppConstants.fontFamily_Acre,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildJobTypeSelector() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ['Full Time', 'Part Time', 'Freelancer','Internship']
          .map((type) => _buildCircularOption(
                label: type,
                isSelected: controller.selectedJobType.value == type,
                onTap: () => controller.selectedJobType.value = type,
              ))
          .toList(),
    ));
  }

  Widget _buildCircularOption({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppConstants.fontFamily_Acre,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobTitleInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
          child: TextField(
            controller: controller.jobTitleController,
            style: const TextStyle(fontFamily: AppConstants.fontFamily_Acre, fontSize: 15),
            decoration: InputDecoration(
              hintText: "Search jobs",
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontFamily: AppConstants.fontFamily_Acre),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
        ),
        Obx(() => controller.showSuggestions.value
            ? Container(
                margin: const EdgeInsets.only(top: 5),
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSizeMedium),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: controller.suggestions.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final suggestion = controller.suggestions[index];
                    return ListTile(
                      title: Text(
                        suggestion,
                        style: const TextStyle(
                          fontFamily: AppConstants.fontFamily_Acre,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        controller.selectSuggestion(suggestion);
                        FocusScope.of(context).unfocus();
                      },
                    );
                  },
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildExperienceDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Experience"),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Select", style: TextStyle(color: Colors.grey)),
              value: controller.selectedExperience.value,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              items: controller.experienceOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (newValue) {
                controller.selectedExperience.value = newValue;
              },
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildEducationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Education"),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Select", style: TextStyle(color: Colors.grey)),
              value: controller.selectedEducation.value,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              items: controller.educationOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (newValue) {
                controller.selectedEducation.value = newValue;
              },
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildSalarySlider(BuildContext context) {
    return Obx(() => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('30k', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
            Text('100k', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 5),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            rangeThumbShape: const _CustomRangeThumbShape(),
            overlayColor: AppColors.primaryColor.withOpacity(0.1),
            activeTrackColor: AppColors.primaryColor,
            inactiveTrackColor: Colors.grey.shade200,
            trackHeight: 6.0,
          ),
          child: RangeSlider(
            values: controller.salaryRange.value,
            min: 30000,
            max: 100000,
            onChanged: (values) {
              controller.salaryRange.value = values;
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 30,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double width = constraints.maxWidth;
                    double startPos = (controller.salaryRange.value.start - 30000) / (100000 - 30000) * width;
                    double endPos = (controller.salaryRange.value.end - 30000) / (100000 - 30000) * width;
                    
                    return Stack(
                      children: [
                        Positioned(
                          left: startPos - 15,
                          child: Text(
                            '\$${(controller.salaryRange.value.start / 1000).toStringAsFixed(0)}k',
                            style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        Positioned(
                          left: endPos - 15,
                          child: Text(
                            '\$${(controller.salaryRange.value.end / 1000).toStringAsFixed(0)}k',
                            style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }

  Widget _buildSkillSets() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Obx(() => Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: controller.skills.map((skill) => _buildSkillChip(skill)).toList(),
          )),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
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
    );
  }

  Widget _buildWorkLocationSelector() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ['WFH', 'On Site', 'Hybrid']
          .map((location) => _buildCircularOption(
                label: location,
                isSelected: controller.selectedWorkLocation.value == location,
                onTap: () => controller.selectedWorkLocation.value = location,
              ))
          .toList(),
    ));
  }

  Widget _buildSaveSearchButton() {
    return Container(
      color: AppColors.primaryColor,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 65,
          child: TextButton(
            onPressed: () => controller.applyFilter(),
            child: const Text(
              "Save Search",
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
    );
  }
}

class _CustomRangeThumbShape extends RangeSliderThumbShape {
  const _CustomRangeThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(20, 20);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    final Paint bluePaint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.fill;

    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 10, bluePaint);
    canvas.drawCircle(center, 5, whitePaint);
  }
}

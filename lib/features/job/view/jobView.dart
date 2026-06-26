import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proxlink/Utill/app_colors.dart';
import '../../../Utill/AppConstants.dart';
import '../../../Utill/Dimensions.dart';
import '../../../routes/app_pages.dart';
import '../../Chat/controller/chatController.dart';
import '../controller/jobController.dart';
import '../model/JobResponse.dart';

class JobView extends GetView<JobController> {
  const JobView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        toolbarHeight: 60,
        centerTitle: false,
        title: const Text(
          "Jobs Near You",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontFamily_Acre,
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // Action for Post Jobs
              Get.toNamed(Routes.post_job);
            },
            child: Container(
              height: 55,
              margin: const EdgeInsets.symmetric(horizontal: 14,vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.whites,
                borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  const Icon(Icons.post_add, color:AppColors.primaryColor, size: 28),
                  const SizedBox(width: 1),
                  const Text(
                    "Post Jobs",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.fontFamily_Acre,
                    ),
                  ),const SizedBox(width: 7),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map background
          Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      controller.appStorage.current_lat.value,
                      controller.appStorage.current_lng.value,
                    ),
                    zoom: 14,
                  ),
                  markers: controller.markers.toSet(),
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController mapController) {
                    controller.onMapCreated(mapController);
                  },
                )),

          // Overlay: Search Bar, Filter and Post Jobs Button
          Positioned(
            top: 15,
            left: Dimensions.paddingSizeDefault,
            right: Dimensions.paddingSizeDefault,
            child: Column(
              children: [
                Row(
                  children: [
                    // Search Input Box
                    Expanded(
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controller.searchTextController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Colors.black, size: 24),
                            hintText: "Search Jobs",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 18),
                            hintStyle: TextStyle(
                              color: AppColors.textGrayColor,
                              fontFamily: AppConstants.fontFamily_Acre,
                              fontSize: Dimensions.fontSizeLarge,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: AppConstants.fontFamily_Acre,
                            fontSize: Dimensions.fontSizeLarge,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Filter Button
                    GestureDetector(
                      onTap: () async {
                        // Navigate to Filter / Search Job View and wait for result
                        final result = await Get.toNamed(Routes.job_fitter);
                        if (result != null && result is Map<String, dynamic>) {
                          controller.fetchJobs(
                            jobType: result['job_type'] ?? "",
                            keywords: result['keywords'] ?? "",
                            skills: result['skills'] ?? "",
                            salaryMin: result['salary_min'] ?? "",
                            salaryMax: result['salary_max'] ?? "",
                          );
                        }
                      },
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.tune, color: AppColors.primaryColor, size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(() => controller.showSuggestions.value
                    ? Container(
                        margin: const EdgeInsets.only(top: 5),
                        constraints: BoxConstraints(maxHeight: Get.height * 0.3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
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
                                  fontWeight: FontWeight.w500,
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
            ),
          ),
          // const CustomPopupMenu(),
        ],
      ),
    );
  }
}

class JobDetailsBottomSheet extends StatelessWidget {
  final List<JobDetail> users;
  const JobDetailsBottomSheet({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Job Available (${users.length})",
                  style: const TextStyle(
                      color: AppColors.black,
                      fontFamily: AppConstants.fontFamily_Acre,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Contact List
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                return _buildJobCard(users[index]);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildJobCard(JobDetail job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(job.companyName, style: const TextStyle(color: Colors.blue)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow("Type", job.job_type),
                          _buildDetailRow("Education", job.education),
                          _buildDetailRow("Experience", job.experience_text),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _buildDetailRow(
                          "Salary", job.salaryCurrency),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildRichText("Skill Set : ", job.skillsHash),
                  ],
                ),
                const SizedBox(height: 20), // Space for the floating button
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child:InkWell(  onTap: () => Get.find<ChatController>().navigateToChat(
    otherUserId: job.posted_by_user_id,
    otherUserName: job.companyName,
    ),child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF1A73E8), // Match the blue from UI
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text("Chat",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),)
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text.rich(
        TextSpan(text: "$label : ", children: [
          TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  Widget _buildRichText(String label, String value) {
    return Flexible(
      child: Text.rich(
        TextSpan(text: label, children: [
          TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        style: const TextStyle(fontSize: 12),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

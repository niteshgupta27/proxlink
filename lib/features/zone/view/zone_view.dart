import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide Cluster;
import 'package:proxlink/Utill/AppConstants.dart';
import 'package:proxlink/Utill/Dimensions.dart';
import 'package:proxlink/Utill/app_colors.dart';
import 'package:proxlink/features/zone/model/zone_model.dart';
import '../../../routes/app_pages.dart';
import '../controller/zone_controller.dart';

class ZoneView extends GetView<ZoneController> {
  const ZoneView({super.key});

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
          "Zones Near You",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontFamily_Acre,
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              var result = await Get.toNamed(Routes.CreateZone);
              if (result == true) {
                controller.fetchZoneMapRealtime();
              }
            },
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
              ),
              child: const Center(
                child: Text(
                  "Create Zone",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.fontFamily_Acre,
                  ),
                ),
              ),
            ),
          ),
          // const CustomPopupMenu(),
        ],
      ),
      body: Stack(
        children: [
          // Content (Map or List)
          Obx(() => controller.isListView.value ? _buildListView() : _buildMapView()),

          // Loading Overlay
          Obx(() => controller.isLoading.value 
            ? Container(
                color: Colors.black.withValues(alpha: 0.1),
                child: const Center(child: CircularProgressIndicator()),
              )
            : const SizedBox.shrink()
          ),

          // Search & Filters Layer
          Column(
            children: [
              const SizedBox(height: 15),
              // Top Buttons (Membership & Ownership)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Obx(() => Row(
                      children: [
                        Expanded(
                          child: _buildTopButton(
                            "Membership : ${controller.membershipCount.value}",
                            onTap: () {
                              Get.toNamed(Routes.MyZones, arguments: {'type': 'membership'});
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildTopButton(
                            "Ownership : ${controller.ownershipCount.value}",
                            onTap: () {
                              Get.toNamed(Routes.MyZones, arguments: {'type': 'ownership'});
                            },
                          ),
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 15),
              // Search Bar & Toggle Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    // Search Bar
                    Expanded(
                      child: Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child:  Row(
                          children: [
                            Icon(Icons.search, color: AppColors.black),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: controller.searchTextController,
                                decoration: const InputDecoration(
                                  hintText: "Search zone by keywords",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: AppConstants.fontFamily_Acre,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Toggle Button (Show List / Show Map)
                    GestureDetector(
                      onTap: () => controller.toggleView(),
                      child: Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Obx(() => Row(
                              children: [
                                Icon(
                                    controller.isListView.value
                                        ? Icons.map
                                        : Icons.tune,
                                    color: Colors.white,
                                    size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  controller.isListView.value ? "Show Map" : "Show List",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppConstants.fontFamily_Acre,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Obx(() => GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              controller.appStorage.current_lat.value,
              controller.appStorage.current_lng.value,
            ),
            zoom: 14,
          ),
          markers: Set<Marker>.from(controller.markers),
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: controller.onMapCreated,
        ));
  }

  Widget _buildListView() {
    return Container(
      padding: const EdgeInsets.only(top: 160),
      color: Colors.white,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.allZoneList.isEmpty) {
          return const Center(child: Text("No zones found near you"));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: controller.allZoneList.length,
          itemBuilder: (context, index) {
            final zone = controller.allZoneList[index];
            return _buildZoneListItem(zone);
          },
        );
      }),
    );
  }

  Widget _buildZoneListItem(ZoneData zone) {
    return GestureDetector(
      onTap: () async {
        var result = await Get.toNamed(Routes.ZoneDetails, arguments: zone);
        if (result == true) {
          controller.fetchZoneMapRealtime();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zone.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: AppConstants.fontFamily_Acre,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildChip("${zone.membersCount} members"),
                      const SizedBox(width: 10),
                      _buildChip("${zone.distanceM.toStringAsFixed(1)} Mts"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: AppConstants.fontFamily_Acre,
                      ),
                      children: [
                        TextSpan(
                          text: zone.purpose.length > 100 
                              ? "${zone.purpose.substring(0, 100)}... " 
                              : "${zone.purpose} ",
                        ),
                        const TextSpan(
                          text: "Read More",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!zone.isMember)
              GestureDetector(
                onTap: () async {
                  var result = await Get.toNamed(Routes.ZoneDetails, arguments: zone);
                  if (result == true) {
                    controller.fetchZoneMapRealtime();
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Join Zone",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: AppConstants.fontFamily_Acre,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: AppConstants.fontFamily_Acre,
        ),
      ),
    );
  }

  Widget _buildTopButton(String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontFamily_Acre,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class ZoneDetailsBottomSheet extends StatelessWidget {
  final List<ZoneData> zones;
  const ZoneDetailsBottomSheet({super.key, required this.zones});


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
              Text("Zones Available (${zones.length})",
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
          // List of Zones
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: zones.length,
              itemBuilder: (context, index) {
                return _buildZoneCard(zones[index]);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildZoneCard(ZoneData zone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () async {
          Get.back();
          var result = await Get.toNamed(Routes.ZoneDetails, arguments: zone);
          if (result == true) {
            if (Get.isRegistered<ZoneController>()) {
              Get.find<ZoneController>().fetchZoneMapRealtime();
            }
          }
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(zone.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      _buildRichText("Skills : ", zone.skills.join(', ')),
                    ],
                  ),
                  Text(zone.purpose, style: const TextStyle(color: Colors.blue)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildDetailRow("Members", zone.membersCount.toString()),
                      const SizedBox(width: 20),
                      _buildDetailRow("Type", zone.zoneType),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            if (!zone.isMember)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A73E8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.login, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text("Join",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Text.rich(
      TextSpan(text: "$label : ", children: [
        TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ]),
      style: const TextStyle(fontSize: 13),
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

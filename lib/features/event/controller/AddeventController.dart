import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Utill/app_storage.dart';
import '../../membersList/model/NetworkModel.dart';
import '../eventservice.dart';

class AddeventController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  var eventName = ''.obs;
  var description = ''.obs;
  final AppStorage _appStorage = Get.find<AppStorage>();
  var isLoading = false.obs;
  final EventService _eventService = EventService();

  RxList<NetworkModel> networks = <NetworkModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchNetworks();
    nameController.addListener(() {
      eventName.value = nameController.text;
    });
    descriptionController.addListener(() {
      description.value = descriptionController.text;
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> createEvent() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    Map<String, dynamic> body = {
      "api_key": _appStorage.loggedInUserToken,
      "user_id": _appStorage.loggedInUserId.toString(),
      "payload": {
        "description": description.value,
        "name": eventName.value
      }
    };
    
    try {
      isLoading.value = true;
      var response = await _eventService.CreateNetwork(body: body); // Placeholder, update if CreateNetwork exists

      if (response.status == "success") {
        Get.back(result: {'network_name': eventName.value.toString(),
          'network_id':response.network_id.toString()});

        Get.snackbar("Success", "Network created successfully", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error creating event: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNetworks() async {
    Map<String, dynamic> body = {
      "api_key": _appStorage.loggedInUserToken, // You might want to get this from constants if available
      "user_id": _appStorage.loggedInUserId.toString(),
      "payload": {
        "view_as": "Host"
      }
    };
    try {
      isLoading.value = true;
      var response = await _eventService.getNetworkList(body: body);

      if (response.status == "success" ) {
        networks.value=response.networks!;
        // List<dynamic> data = response['data'] ?? [];
        // networks.assignAll(data.map((e) => NetworkModel.fromJson(e)).toList());
      }
    } catch (e) {
      print("Error fetching networks: $e");
    } finally {
      isLoading.value = false;
    }
  }

}

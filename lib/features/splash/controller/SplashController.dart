import 'package:get/get.dart';
import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_storage.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final appStorage = Get.find<AppStorage>();

  @override
  void onInit() {
    super.onInit();
    print("--- SPLASH CONTROLLER INITIALIZED ---");
    _navigateUser();
  }

  Future<void> _navigateUser() async {
    try {
      // Ensure AppStorage is ready
      await appStorage.init(); 

      // Read the token from storage
      String token = await appStorage.read(AppConstants.loginUserInformationToken) ?? "";
      print("Token found: $token");

      // Minimum splash time
      await Future.delayed(const Duration(seconds: 2));
      
      if (token.isNotEmpty) {
        print("Navigating to Bottom Navigation");
        
        // Fix: Added await because appStorage.read is an async method
        appStorage.loggedInUserToken=token;
        appStorage.current_lat.value= await appStorage.read('current_lat') ?? 13.0827;
        appStorage.current_lng.value= await appStorage.read('current_lng') ?? 80.2707;
appStorage.loggedInUserId= await appStorage.read(AppConstants.loginUserId);
        Get.offNamed(Routes.BOTTOM_NAVIGATION);
      } else {
        print("Navigating to Login");
        Get.offNamed(Routes.LOGINSCREEN);
      }
    } catch (e) {
      print("Splash error: $e");
      Get.offNamed(Routes.LOGINSCREEN);
    }
  }
}

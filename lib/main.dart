import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:proxlink/LocationService.dart';
import 'package:proxlink/Utill/app_colors.dart';
import 'package:proxlink/Utill/app_storage.dart';
import 'package:proxlink/proxlink.dart';
import 'package:proxlink/Utill/AppConstants.dart';
import 'package:proxlink/features/network/controller/NetworkController.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Explicitly set both Status Bar and Navigation Bar styles
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: AppColors.primaryColor,
    statusBarIconBrightness: Brightness.light, // White icons for Android status bar
    statusBarBrightness: Brightness.dark,      // White icons for iOS status bar
    systemNavigationBarColor: AppColors.primaryColor, // Matching color for navigation bar
    systemNavigationBarIconBrightness: Brightness.light, // White icons for navigation bar
  ));

  await GetStorage.init();
  
  final storage = Get.put(AppStorage());
  await storage.init();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }
  } catch (e) {}

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await runZonedGuarded(() async {
    runApp(const ProxlinkApp());
  }, (error, stack) {
    if (!kIsWeb) FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', 'PROXLINK SERVICE', 
    importance: Importance.low
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Proxlink Active',
      initialNotificationContent: 'Initializing...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(autoStart: true, onForeground: onStart, onBackground: onIosBackground),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async => true;

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  
  // 🚀 RE-INITIALIZE EVERYTHING FOR THE BACKGROUND ISOLATE
  await GetStorage.init();
  final storage = Get.put(AppStorage());
  
  // Load credentials from disk into this isolate's memory
  storage.loggedInUserToken = GetStorage().read(AppConstants.loginUserInformationToken) ?? "";
  storage.loggedInUserId = GetStorage().read(AppConstants.loginUserId);

  // Register the NetworkController in this isolate
  Get.put(NetworkController());

  final locationService = LocationService();
  print("--- BACKGROUND SERVICE STARTED ---");

  Timer.periodic(const Duration(seconds: 20), (timer) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      await locationService.updateLocation(position);

      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Tracking Active",
          content: "Last Update: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}",
        );
      }
    } catch (e) {
      print("Location Error: $e");
    }
  });
}

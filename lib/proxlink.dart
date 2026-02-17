import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:proxlink/routes/app_pages.dart';

import 'Utill/AppConstants.dart';
import 'Utill/ResponsiveView.dart';
import 'Utill/app_colors.dart';
import 'Utill/app_storage.dart';
import 'Utill/app_theme.dart';

class ProxlinkApp extends StatefulWidget {
  const ProxlinkApp({super.key});

  @override
  State<ProxlinkApp> createState() => _ProxlinkAppState();
}

class _ProxlinkAppState extends State<ProxlinkApp> {
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  bool _fcmInitialized = false;

  @override
  void initState() {
    super.initState();
    _setupFCM();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    // // Apply Status bar configuration
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: AppColors.primaryColor, // Android status bar color
    //   statusBarIconBrightness: Brightness.light, // Android status bar icons
    //   statusBarBrightness: Brightness.dark, // iOS status bar icons
    // ));
    // Explicitly set both Status Bar and Navigation Bar styles
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
      statusBarIconBrightness: Brightness.light, // White icons for Android status bar
      statusBarBrightness: Brightness.dark,      // White icons for iOS status bar
      systemNavigationBarColor: AppColors.primaryColor, // Matching color for navigation bar
      systemNavigationBarIconBrightness: Brightness.light, // White icons for navigation bar
    ));
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(size.width < 380 ? 0.8 : 1)),
      child: GetMaterialApp(
        title: AppConstants.appName,
        initialRoute: _getInitialRoute(),
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getproxlinkTheme(),
        initialBinding: BindingsBuilder(() {
          Get.lazyPut<GetConnect>(() => GetConnect());
          Get.lazyPut<AppStorage>(() => AppStorage());
        }),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
          },
        ),
      ),
    );
  }

  String _getInitialRoute() {
    return ResponsiveView.isWeb()
        ? Routes.BOTTOM_NAVIGATION
        : Routes.SPLASH;
  }

  // ================= FCM SETUP =================

  Future<void> _setupFCM() async {
    if (_fcmInitialized || kIsWeb) return;
    _fcmInitialized = true;

    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    /// 🔔 Permission
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    /// 📢 Local notifications init
    await _initLocalNotifications();

    /// 📬 Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    /// 📲 App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    /// 🚀 App opened from terminated state
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }
  }

  // ================= LOCAL NOTIFICATIONS =================

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          _handleNotificationPayload(response.payload!);
        }
      },
    );

    /// 🔥 Android notification channel (MANDATORY)
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel =
      AndroidNotificationChannel(
        'proxlink_high',
        'High Priority Notifications',
        description: 'Used for important notifications',
        importance: Importance.max,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  // ================= HANDLERS =================

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _showNotification(notification, message.data);
    }
  }

  void _handleMessageTap(RemoteMessage message) {
    debugPrint("Notification tapped: ${message.data}");

    /// Example navigation
    if (message.data['route'] != null) {
      Get.toNamed(message.data['route']);
    }
  }

  void _handleNotificationPayload(String payload) {
    debugPrint("Notification payload: $payload");
  }

  // ================= SHOW NOTIFICATION =================

  Future<void> _showNotification(
      RemoteNotification notification,
      Map<String, dynamic> data,
      ) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'proxlink_high',
      'High Priority Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails =
    DarwinNotificationDetails();

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique ID
      notification.title,
      notification.body,
      details,
      payload: data.toString(),
    );
  }
}

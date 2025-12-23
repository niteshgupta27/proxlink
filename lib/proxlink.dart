import 'dart:io';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:proxlink/Utill/Apputills.dart';
import 'package:proxlink/Utill/app_required.dart';
import 'package:proxlink/routes/app_pages.dart';

import 'Utill/AppConstants.dart';
import 'Utill/ResponsiveView.dart';
import 'Utill/app_storage.dart';
import 'Utill/app_theme.dart';

class ProxlinkApp extends StatefulWidget {
  const ProxlinkApp({super.key});

  @override
  State<ProxlinkApp> createState() => _ProxlinkAppState();
}
class _ProxlinkAppState extends State<ProxlinkApp> {
  //const proxlinkApp({super.key});
 static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
 //var appStorage = Get.lazyPut(()=>AppStorage());

 @override
 void initState() {
   super.initState();

   _initializeFCM();
 }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    //  if (!kIsWeb) {
    //    _initDynamicLinks();
    //  }
     _initializeFCM();
    return MediaQuery(
         data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(size.width < 380 ?  0.8 : 1)),
         child: GetMaterialApp(
          title: AppConstants.appName,
         // navigatorKey: navigatorKey,
          initialRoute: _getInitialRoute(),

          getPages: AppPages.routes,
           // routeInformationParser: GetInformationParser(
           //   // Replace AppPages.initial with your desired constant
           //   // or simply a string like '/'
           //   initialRoute:  _getInitialRoute(), // <--- THIS IS YOUR NEW INITIAL ROUTE
           // ),
           // routerDelegate: GetDelegate(),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getproxlinkTheme(),
          initialBinding: BindingsBuilder(
                () {
              Get.lazyPut<GetConnect>(
                    () => GetConnect(),
              );
              Get.lazyPut<AppStorage>(
                    () => AppStorage(),
              );
            },
          ),
          scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
          }),

               ),
       );

  }

  String _getInitialRoute() {
    if (ResponsiveView.isWeb()) {

      return Routes.BOTTOM_NAVIGATION;
    } else {
      return Routes.SPLASH;
    }

   }

  /// Handle incoming dynamic links


  Future<void> _initializeFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission (iOS and Web)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Initialize local notifications
   // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,iOS:initializationSettingsIOS
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message);
      if (message.notification != null) {
        _showNotification(message.notification!);
      }
    });

    // // Retrieve FCM token
    // FcmToken = await messaging.getToken();
    // print('FCM Token: $FcmToken');
  }

  Future<void> _showNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails, iOS: iosDetails
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      notificationDetails,
    );
  }

}

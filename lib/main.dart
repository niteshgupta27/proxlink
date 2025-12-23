import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:proxlink/proxlink.dart';

import 'firebase_options.dart';

///https://www.figma.com/design/QjAvvcytmaVvq8A81CdLSR/Serggo-User-App?node-id=2-4&node-type=FRAME&t=0jZsmMMvX8grxzmU-0

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
}

void main() {
  //HttpOverrides.global = MyHttpOverrides();
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await GetStorage.init();
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,

      systemNavigationBarColor: Colors.white, // Bottom nav bar background
      systemNavigationBarDividerColor: Colors.white, // Divider line color
      systemNavigationBarIconBrightness: Brightness.dark, // Nav bar icons
      systemNavigationBarContrastEnforced: true,
    ));

    // Future.delayed(const Duration(seconds: 4), () async {

    AppLinks().uriLinkStream.listen((Uri? uri) {
      log("Received new deep link ============> ${uri.toString()}");
      if (uri != null && uri.pathSegments.length >= 2 ) {
        blogIdNotifier.value = uri;
        log("Received  deep link id ============> ${uri.pathSegments[1]}");

      }
    }, onError: (err) {
      debugPrint("Deep link error: $err");
    });
    // });


    // if (!kIsWeb) {
    //   if (Firebase.apps.isEmpty) {
    //     await Firebase.initializeApp(
    //       name: "Serggo",
    //       options: DefaultFirebaseOptions.currentPlatform,
    //     );
    //     print("Firebase app initialized");
    //   } else {
    //     print("Firebase app already initialized");
    //   }
    //
    //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    //
    //   // Capture Flutter errors
    //   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    //
    // }
    // else {
    //   await Firebase.initializeApp(options: const FirebaseOptions(
    //     apiKey: 'AIzaSyDAf-NUb_zZVsJkblHmLLvFaoNu1mKZUeo',
    //     appId: '1:1041800447511:web:98c833b524be3d2d8ebe52',
    //     messagingSenderId: '1041800447511',
    //     projectId: 'serggo-e3be2',
    //     authDomain: 'serggo-e3be2.firebaseapp.com',
    //     storageBucket: 'serggo-e3be2.appspot.com',
    //     measurementId: 'G-W0TGBZYS0F',
    //   ));
    //
    //   // await FacebookAuth.instance.webAndDesktopInitialize(
    //   //   appId: "YOUR_FACEBOOK_KEY_HERE",
    //   //   cookie: true,
    //   //   xfbml: true,
    //   //   version: "v13.0",
    //   // );
    // }
    // Enable Firebase Crashlytics
    // Register service worker

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // if (!kIsWeb) {
    //   subscribeToAllUsers();
    // }
    // print("Subscribed to all_users topic!");




    // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  },(error, stack) {
   // if (!kIsWeb) { FirebaseCrashlytics.instance.recordError(error, stack);}print(error);
  });

  runApp(const ProxlinkApp());
}
void subscribeToAllUsers() async {
  await FirebaseMessaging.instance.subscribeToTopic("all_users");
  print("Subscribed to all_users topic!");
}
ValueNotifier<Uri?> blogIdNotifier = ValueNotifier(null);




// extension ProxiedUrl on String {
//   String get proxied => 'https://cors-anywhere.herokuapp.com/$this';
// }

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

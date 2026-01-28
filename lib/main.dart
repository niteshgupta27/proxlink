import 'dart:async';
import 'dart:developer';
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

/// 🔥 MUST be top-level & outside main
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  log('Background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // 1. Initialize Firebase outside the zone for stability
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint("Firebase already initialized or failed: $e");
  }

  // 2. Set up FCM background handler early
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await runZonedGuarded(() async {
    // 3. Configure Crashlytics & UI
    if (!kIsWeb) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // ... rest of your style
      ),
    );
    //
    // // Deep link listener
    // AppLinks().uriLinkStream.listen((uri) {
    //   if (uri != null && uri.pathSegments.length >= 2) {
    //     blogIdNotifier.value = uri;
    //   }
    // }, onError: (e) => debugPrint("Deep link error: $e"));

    runApp(const ProxlinkApp());
  }, (error, stack) {
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
  });
}
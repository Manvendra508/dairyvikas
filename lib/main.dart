// lib/main.dart
import 'package:DairyVikas/app/di/injection.dart';
import 'package:DairyVikas/core/other_services/network_service.dart';
import 'package:DairyVikas/core/other_services/notifications_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.instance.init();
  NotificationService.instance.tokenRefreshListener();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  /// Async Errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);

    return true;
  }; //

  final NetworkService networkService = NetworkService();

  networkService.initialize();
  await Injection.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(DairyVikas(networkService: networkService));
  });
}

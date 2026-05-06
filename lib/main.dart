// lib/main.dart
import 'package:dairysathi/app/di/injection.dart';
import 'package:dairysathi/core/other_services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';

Future<void> main() async {
  final NetworkService networkService = NetworkService();
  WidgetsFlutterBinding.ensureInitialized();
  networkService.initialize();
  await Injection.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(DairySathi(networkService: networkService));
  });
}

// lib/app.dart
import 'package:DairyVikas/app/localization/app_translation.dart';
import 'package:DairyVikas/common/common_widget/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import 'app/routes/app_router.dart';
import 'core/local_datasources/local_storage_service.dart';
import 'core/other_services/network_service.dart';

class DairyVikas extends StatelessWidget {
  final NetworkService networkService;
  const DairyVikas({super.key, required this.networkService});

  @override
  Widget build(BuildContext context) {
    final savedLocale = SharedPrefsService.instance.getSavedLocale();
    final router = AppRouter.router;

    return OKToast(
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) {
          return GetMaterialApp.router(
            title: 'Dairy Vikas',
            debugShowCheckedModeBanner: true,
            theme: ThemeData(useMaterial3: true),

            translations: AppTranslations(),
            locale: savedLocale ?? const Locale('en', 'US'),
            fallbackLocale: const Locale('en', 'US'),

            builder: (context, child) {
              return StreamBuilder<bool>(
                stream: networkService.connectionStream,
                builder: (context, snapshot) {
                  final isConnected = snapshot.data ?? true;

                  if (!isConnected) {
                    return const NoInternetScreen();
                  }

                  return child!;
                },
              );
            },

            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            routeInformationProvider: router.routeInformationProvider,
          );
        },
      ),
    );
  }
}

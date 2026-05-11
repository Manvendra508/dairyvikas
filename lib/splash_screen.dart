import 'dart:convert';
import 'dart:io';

import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/app_update_widget.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/network/api_endpoints.dart';
import 'package:DairyVikas/core/other_services/auth_service.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool hasUpdate = false;

  @override
  void initState() {
    super.initState();

    _firstMethod();
    if (!hasUpdate) {
      Future.delayed(const Duration(seconds: 2), () async {
        final isLoggedIn = await AuthService.isLoggedIn();
        final hasDairyDetailsSaved = await AuthService.isDairyDetailsSaved();

        if (isLoggedIn) {
          if (hasDairyDetailsSaved) {
            AppNavigation.goToDairyCenterSettingsPage();
          } else {
            AppNavigation.goToDashboardPage();
          }
        } else {
          AppNavigation.goToLoginAndRemoveAll();
        }
      });
    }
  }

  _firstMethod() async {
    await getAppVersion();
    await checkForUpdate();

    if (hasUpdate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialogForAppUpdate(context);
      });
    }
  }

  Future checkForUpdate() async {
    String platform = Platform.isAndroid
        ? 'android'
        : Platform.isIOS
        ? 'ios'
        : 'unknown';

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.checkAppUpdate),
        body: {'app_version': AppState.appVersion, 'platform': platform},
      );

      if (response.statusCode == 200) {
        final apiResponse = jsonDecode(response.body);
        if (apiResponse['success']) {
          hasUpdate = apiResponse['data']['update_required'];
        } else {
          hasUpdate = false;
        }
      } else {
        hasUpdate = false;
        return false;
      }
    } catch (e) {
      hasUpdate = false;
    }
  }

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppState.appVersion = packageInfo.version;
  }

  showDialogForAppUpdate(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(25.r),
          ),

          content: AppUpdateWidget(),
        );
      },
    );
  }

  Future<void> launchStoreUrl() async {
    Uri url;
    if (Platform.isAndroid) {
      url = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.dairyvikas.app',
      );
    } else {
      throw 'Unsupported platform';
    }

    // else if (Platform.isIOS) {
    //   url = Uri.parse('https://apps.apple.com/in/app/balwaan-b2b/id6670391935');
    // } else {
    //   throw 'Unsupported platform';
    // }
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.themeColor,
        width: 1.sw,
        height: 1.sh,
        child: Center(
          child: TextWidget(
            text: 'DairyVikas',
            fontSize: 30,
            textColor: AppColors.whiteColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

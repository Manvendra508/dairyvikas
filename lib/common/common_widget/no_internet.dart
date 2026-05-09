import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/assets_paths.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(AssetsPaths.noInternet),

                Gap.verticalGap(10),

                TextWidget(
                  text: 'No Internet Available!',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),

                Gap.verticalGap(8),
                TextWidget(
                  textAlign: TextAlign.center,
                  text: 'Please turn on your internet connection to continue.',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.grey600,
                ),

                Gap.verticalGap(25),

                InkWell(
                  onTap: () => AppSettings.openAppSettings(
                    type: AppSettingsType.wireless,
                  ),
                  child: AppButton(
                    title: 'Open Internet Setting',
                    buttonFontSize: 15.sp,
                    buttonFontWeight: FontWeight.w600,
                    isLoading: false.obs,
                    buttonBorderRaduids: 25.r,
                    shadowOpacity: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

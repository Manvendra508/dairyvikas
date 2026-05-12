import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppUpdateWidget extends StatelessWidget {
  const AppUpdateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 0.44.sh,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        color: AppColors.whiteColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              gradient: RadialGradient(
                colors: [
                  AppColors.secondaryDark.withValues(alpha: 0.08),
                  AppColors.whiteColor.withValues(alpha: 0.1),
                ],
                radius: 0.7,
              ),
            ),
            child: Center(
              child: AppIcons.appUpdate(
                size: 25.h,
                color: AppColors.secondaryDark,
              ),
            ),
          ),
          Gap.verticalGap(15.h),
          TextWidget(
            text: 'app_update_available',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
          Gap.verticalGap(7.h),
          TextWidget(
            text: 'app_update_message',
            textColor: AppColors.grey600,
            fontWeight: FontWeight.w500,
            maxline: 3,
            fontSize: 13.sp,
            textAlign: TextAlign.center,
          ),
          Gap.verticalGap(20),
          InkWell(
            onTap: () {
              AppNavigation.goBack();
            },
            child: AppButton(
              margin: EdgeInsets.symmetric(horizontal: 25.w),
              title: 'update_now',
              buttonFontWeight: FontWeight.w700,
              isLoading: false.obs,
            ),
          ),
          Gap.verticalGap(10),
          // InkWell(
          //   onTap: () => AppNavigation.goBack(),
          //   child: Container(
          //     height: 30.h,
          //     width: 100.w,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(30.r),
          //       color: AppColors.whiteColor.withValues(alpha : )(0.1),
          //     ),
          //     child: Center(
          //       child: TextWidget(
          //         text: 'maybe_later',

          //         textColor: AppColors.grey500,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

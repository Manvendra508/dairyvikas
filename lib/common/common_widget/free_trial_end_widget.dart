import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FreeTrialEndWidget extends StatelessWidget {
  final String languageCode;
  const FreeTrialEndWidget({super.key, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 0.53.sh,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        color: AppColors.whiteColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,

                gradient: RadialGradient(
                  colors: [
                    AppColors.secondaryDark.withOpacity(0.08),
                    AppColors.whiteColor.withOpacity(0.1),
                  ],
                  radius: 0.7,
                ),
              ),
              child: Center(
                child: AppIcons.lock(
                  size: 25.h,
                  color: AppColors.secondaryDark,
                ),
              ),
            ),
            Gap.verticalGap(15.h),
            TextWidget(
              text: 'free_trail_expired',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
            Gap.verticalGap(7.h),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    style: GoogleFonts.montserrat(
                      color: AppColors.grey600,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                    ),
                    text: "free_trial_expired_msg_part1".tr,
                  ),
                  TextSpan(
                    text: languageCode == 'en'
                        ? "free_trial_expired_msg_part2".tr
                        : '',
                    style: GoogleFonts.montserrat(
                      color: AppColors.secondaryDark,
                      fontWeight: FontWeight.w700,
                      height: 1.6,
                    ),
                  ),
                  TextSpan(
                    text: "free_trial_expired_msg_part3".tr,
                    style: GoogleFonts.montserrat(
                      color: AppColors.grey600,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            Gap.verticalGap(20),
            InkWell(
              onTap: () {
                Get.back();
                AppNavigation.goToSubscriptionPlanPage();
              },
              child: AppButton(
                margin: EdgeInsets.symmetric(horizontal: 25.w),
                title: 'upgrade_now',
                buttonFontWeight: FontWeight.w700,
                isLoading: false.obs,
              ),
            ),
            Gap.verticalGap(20),
            InkWell(
              onTap: () => AppNavigation.goBack(),
              child: Container(
                height: 30.h,
                width: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  color: AppColors.whiteColor.withOpacity(0.1),
                ),
                child: Center(
                  child: TextWidget(
                    text: 'maybe_later',

                    textColor: AppColors.grey500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

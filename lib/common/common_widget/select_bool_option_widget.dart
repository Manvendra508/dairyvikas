import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/cross_button.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/get_rx.dart';

class SelectBoolOptionWidget extends StatelessWidget {
  final String message;
  final String title;
  final VoidCallback callback;
  final double? height;
  const SelectBoolOptionWidget({
    super.key,
    required this.message,
    required this.title,
    required this.callback,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: height ?? 150.h,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: title,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),

                CrossButton(),
              ],
            ),
            Gap.verticalGap(4.h),
            Divider(thickness: 0.7, color: AppColors.grey200),
            Gap.verticalGap(4.h),
            TextWidget(
              text: message,
              maxline: 3,
              fontWeight: FontWeight.w600,

              textColor: AppColors.grey700,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => AppNavigation.goBack(),
                  child: AppButton(
                    buttonHeight: 35.h,
                    buttonWidth: 1.sw / 2.3,
                    title: 'cancel',
                    buttonFontWeight: FontWeight.w500,
                    isLoading: false.obs,
                    buttonBorderColor: AppColors.redColor.withOpacity(0.8),
                    buttonBorderRaduids: 4.r,
                    buttonColor: AppColors.whiteColor,
                    buttonTextColor: AppColors.redColor.withOpacity(0.8),
                  ),
                ),
                InkWell(
                  onTap: callback,
                  child: AppButton(
                    buttonHeight: 35.h,
                    buttonWidth: 1.sw / 2.3,
                    title: 'yes',
                    buttonFontWeight: FontWeight.w500,
                    isLoading: false.obs,
                    buttonBorderColor: AppColors.themeColor,
                    buttonBorderRaduids: 4.r,
                    buttonColor: AppColors.themeColor,
                    buttonTextColor: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
            Gap.verticalGap(1.h),
          ],
        ),
      ),
    );
  }
}

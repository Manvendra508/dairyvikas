import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppButton extends StatelessWidget {
  final String title;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? buttonBorderRaduids;
  final Color? buttonTextColor;
  final Color? buttonColor;
  final Color? buttonBorderColor;
  final FontWeight? buttonFontWeight;
  final RxBool isLoading;
  final EdgeInsetsGeometry? margin;
  final double? buttonFontSize;
  final double? shadowOpacity;
  final double? indicatorWidth;
  final double? indicatorHeight;
  final double? borderWidth;
  const AppButton({
    super.key,
    required this.title,
    this.buttonWidth,
    this.buttonHeight,
    this.buttonBorderRaduids,
    this.buttonTextColor,
    this.buttonColor,
    this.buttonFontWeight,
    required this.isLoading,
    this.margin,
    this.buttonBorderColor,
    this.shadowOpacity,
    this.buttonFontSize,
    this.indicatorHeight,
    this.indicatorWidth,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: buttonWidth ?? 1.sw,
        height: buttonHeight ?? 42.h,
        margin: margin,
        decoration: BoxDecoration(
          border: Border.all(
            width: borderWidth ?? 0.8,
            color: buttonBorderColor ?? AppColors.themeColor,
          ),
          color: isLoading.value
              ? (buttonColor ?? AppColors.themeColor)
              : buttonColor ?? AppColors.themeColor,
          borderRadius: BorderRadius.circular(buttonBorderRaduids ?? 8.r),

          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(
                alpha: shadowOpacity ?? 1,
              ),
              blurRadius: 6,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Visibility(
            visible: !isLoading.value,
            replacement: SizedBox(
              height: indicatorHeight ?? 17.h,
              width: indicatorWidth ?? 20.w,
              child: CircularProgressIndicator(
                color: AppColors.whiteColor,
                strokeWidth: 1.6,
              ),
            ),
            child: TextWidget(
              text: title.tr,
              fontSize: buttonFontSize,
              textColor: buttonTextColor ?? AppColors.whiteColor,
              fontWeight: buttonFontWeight ?? FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

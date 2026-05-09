import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CheckBoxWidget extends StatelessWidget {
  RxBool isSelected;
  final double? width;
  final double? height;
  final double? radius;
  final double? chekHeight;
  CheckBoxWidget({
    super.key,
    required this.isSelected,
    this.height,
    this.width,
    this.radius,
    this.chekHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: width ?? 18.5.w,
        height: height ?? 16.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 4.r),
          border: Border.all(
            width: 1,
            color: isSelected.value ? AppColors.themeColor : AppColors.grey400,
          ),
          color: isSelected.value ? AppColors.themeColor : AppColors.whiteColor,
        ),
        child: Center(
          child: isSelected.value
              ? Icon(
                  Icons.check,
                  color: AppColors.whiteColor,
                  size: chekHeight ?? 14.sp,
                )
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}

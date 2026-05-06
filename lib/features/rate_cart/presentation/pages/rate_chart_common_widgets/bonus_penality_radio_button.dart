import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BonusPenalityRadioButton extends StatelessWidget {
  final RxBool isActive;
  const BonusPenalityRadioButton({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 17.w,
      height: 17.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: isActive.value ? AppColors.themeColor : AppColors.darkBorder,
        ),
      ),
      child: Center(
        child: Container(
          width: 11.w,
          height: 11.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive.value ? AppColors.themeColor : AppColors.grey200,
          ),
        ),
      ),
    );
  }
}

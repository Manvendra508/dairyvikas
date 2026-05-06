import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CrossButton extends StatelessWidget {
  final Color? bgcolor;
  const CrossButton({super.key, this.bgcolor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppNavigation.goBack(),
      child: Container(
        width: 30.w,
        height: 30.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgcolor ?? AppColors.grey100,
        ),
        child: Center(child: AppIcons.cross(size: 10.sp)),
      ),
    );
  }
}

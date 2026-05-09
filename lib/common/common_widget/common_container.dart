import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final double? borderWidth;
  final EdgeInsetsGeometry? margin;
  final double? borderRaduis;
  final Color? bordercolor;
  final double? shadowOpacity;
  final Color? containerColor;
  const CommonContainer({
    super.key,
    required this.child,
    this.height,
    this.margin,
    this.bordercolor,
    this.borderWidth,
    this.width,
    this.containerColor,
    this.borderRaduis,
    this.shadowOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width ?? 1.sw,
      height: height,
      decoration: BoxDecoration(
        color: containerColor ?? AppColors.whiteColor,
        borderRadius: BorderRadius.circular(borderRaduis ?? 10.r),
        border: Border.all(
          width: borderWidth ?? 0.3,
          color: bordercolor ?? AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(shadowOpacity ?? 1),
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

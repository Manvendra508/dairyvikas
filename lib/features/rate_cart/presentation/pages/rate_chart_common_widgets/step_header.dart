import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_widget/common_container.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepHeader extends StatelessWidget {
  final bool isOnly;

  final Color bgColor;
  final double? radius;
  final String title;
  final VoidCallback callback;
  const StepHeader({
    super.key,
    required this.isOnly,
    required this.bgColor,
    this.radius,
    required this.title,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isOnly ? 1.sw / 1.06 : 1.sw / 2.2,
      height: 35,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius ?? 0.r),
          topRight: Radius.circular(radius ?? 0.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: title,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              textColor: AppColors.whiteColor,
            ),
            InkWell(
              onTap: callback,
              child: CommonContainer(
                shadowOpacity: 0.1,
                width: 19.w,
                height: 16.h,
                borderRaduis: 30.r,

                child: Center(
                  child: Icon(Icons.add, color: AppColors.blackColor, size: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

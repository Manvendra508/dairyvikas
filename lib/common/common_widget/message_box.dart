import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBox extends StatelessWidget {
  final String message;
  final bool isVisible;

  final bool isError;
  const MessageBox({
    super.key,
    required this.message,
    required this.isVisible,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isVisible ? 1 : 0,
      curve: Curves.easeInOut,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: isVisible
            ? Column(
                children: [
                  Container(
                    width: 1.sw,
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 10.w,
                    ),
                    decoration: BoxDecoration(
                      color: isError
                          ? AppColors.redColor.withOpacity(0.12)
                          : AppColors.darkgreenColor.withOpacity(0.12),
                      border: Border.all(
                        width: 0.6,
                        color: AppColors.whiteColor,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: TextWidget(
                        text: message,
                        fontSize: 12.sp,
                        textColor: isError
                            ? AppColors.redColor
                            : AppColors.darkgreenColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Gap.verticalGap(10),
                ],
              )
            : const SizedBox(), // smoothly collapses to zero height
      ),
    );
  }
}

import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/get_rx.dart';

import 'text_widget.dart';

class RetryWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final double topGap;
  const RetryWidget({super.key, required this.onRetry, this.topGap = 0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gap.verticalGap(topGap),
          TextWidget(
            text: 'something_went_wrong_from_server',
            fontSize: 14.sp,
            textColor: AppColors.grey600,
            fontWeight: FontWeight.w500,
          ),
          Gap.verticalGap(10),
          InkWell(
            onTap: onRetry,
            child: AppButton(
              buttonWidth: 130.w,
              buttonHeight: 30.h,
              title: 'try_again',
              isLoading: false.obs,
            ),
          ),
        ],
      ),
    );
  }
}

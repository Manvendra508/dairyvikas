import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart' show AppState;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppVersionText extends StatelessWidget {
  const AppVersionText({super.key});

  @override
  Widget build(BuildContext context) {
    return TextWidget(
      text: 'app_version'.trParams({'version': AppState.appVersion}),
      fontWeight: FontWeight.w500,
      textColor: AppColors.grey600,
      fontSize: 11.sp,
    );
  }
}

import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/assets_paths.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DairyVikasLoader extends StatelessWidget {
  const DairyVikasLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      color: AppColors.whiteColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AssetsPaths.loaderGif, height: 60.h),
            Gap.verticalGap(6),
            TextWidget(text: 'loading', fontWeight: FontWeight.w600),
          ],
        ),
      ),
    );
  }
}

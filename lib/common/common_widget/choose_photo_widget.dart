import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ChoosePhotoWidget extends StatelessWidget with CommonMixin {
  const ChoosePhotoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 40.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(
            'camera',
            ImageSource.camera,
            AppIcons.camera(color: AppColors.darkgreenColor),
            AppColors.darkgreenColor,
          ),
          Gap.horizentalGap(20),
          _buildButton(
            'gallary',
            ImageSource.gallery,
            AppIcons.gallary(color: AppColors.darkgreenColor),
            AppColors.darkgreenColor,
          ),
        ],
      ),
    );
  }

  _buildButton(String title, ImageSource source, Widget icon, Color color) {
    return InkWell(
      onTap: () async {
        await pickImage(source);
      },
      child: Container(
        width: 90.w,
        height: 35,
        decoration: BoxDecoration(
          color: AppColors.darkgreenColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(width: 0.8, color: color.withOpacity(0.9)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Gap.horizentalGap(4),
            TextWidget(
              text: title,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              textColor: color.withOpacity(0.9),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/app_regex.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/common_widget/app_button.dart';

class FixedRateWdget extends StatelessWidget with CommonMixin {
  final RxString fixedrRate;
  const FixedRateWdget({super.key, required this.fixedrRate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Gap.verticalGap(0.15.sh),
          TextWidget(
            text: 'fixed_rate',
            fontSize: 17.sp,
            textColor: AppColors.grey800,
            fontWeight: FontWeight.w500,
          ),
          Gap.verticalGap(5),
          Obx(
            () => TextWidget(
              text: '₹${fixedrRate.value}/kg',
              fontSize: 18.sp,
              textColor: AppColors.themeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: () => showDragableBottomSheet(
              context,
              _buildAddFixedRateForm('add_fixed_rate'),
            ),
            child: Container(
              margin: EdgeInsets.only(top: 20.h),
              width: 120.w,
              height: 30.h,
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: AppColors.themeColor),
                borderRadius: BorderRadius.circular(5.r),
                color: AppColors.whiteColor,
              ),
              child: Center(
                child: TextWidget(
                  text: 'change',
                  fontSize: 13.sp,
                  textColor: AppColors.themeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildAddFixedRateForm(String heading) {
    return SizedBox(
      width: 1.sw,
      height: 180.h,
      child: Column(
        children: [
          Gap.verticalGap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget(
                text: heading,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          Gap.verticalGap(3),
          Divider(thickness: 0.5),
          Gap.verticalGap(6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                _buildTextFormFiedForRate(
                  'enter_fixed_rate',
                  'fixed_rate',
                  fixedrRate,
                ),

                Gap.verticalGap(3),
                InkWell(
                  onTap: () => AppNavigation.goBack(),
                  child: AppButton(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    buttonHeight: 45.h,

                    buttonFontWeight: FontWeight.w600,
                    title: 'add',

                    isLoading: false.obs,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTextFormFiedForRate(String hint, String lable, RxString fixedRate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(text: lable, fontWeight: FontWeight.w500),
        Gap.verticalGap(3),
        SizedBox(
          width: 1.sw,
          height: 38.h,
          child: TextFormField(
            keyboardType: TextInputType.number,

            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            inputFormatters: [
              FilteringTextInputFormatter.allow(AppRegex.onlyNumber),
            ],
            onChanged: (value) {
              fixedRate.value = value;
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.5.h,
                horizontal: 7.w,
              ),
              focusedBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              hint: TextWidget(text: hint, textColor: AppColors.textLight),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/utils/app_regex.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DecimalTextformFeild extends StatelessWidget {
  final TextEditingController controller;
  final String lable;
  final String hint;
  final double fieldWidth;
  const DecimalTextformFeild({
    super.key,
    required this.controller,
    required this.lable,
    required this.hint,
    required this.fieldWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(text: lable, fontWeight: FontWeight.w500),
        Gap.verticalGap(3),
        SizedBox(
          width: fieldWidth,
          height: 35.h,
          child: TextFormField(
            readOnly: controller.text.isNotEmpty ? true : false,
            keyboardType: TextInputType.number,
            controller: controller,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            inputFormatters: [
              FilteringTextInputFormatter.allow(AppRegex.onlyNumber),
              // OneDecimalInputFormatter(),
            ],
            onChanged: (value) {
              // if (value.length == 3) {
              //   FocusScope.of(context).nextFocus();
              // }
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

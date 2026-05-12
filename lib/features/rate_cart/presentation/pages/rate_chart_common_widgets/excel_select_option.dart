import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ExcelSelectOption extends StatelessWidget {
  final VoidCallback chooseExcel;
  final VoidCallback uploadExcel;
  final RxString excelFile;
  final RxBool isUploading;
  const ExcelSelectOption({
    super.key,
    required this.chooseExcel,
    required this.excelFile,
    required this.uploadExcel,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      borderRaduis: 5.r,
      margin: EdgeInsets.only(top: 6.h),
      shadowOpacity: 0.1,
      width: 1.sw,

      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 8.h),
        child: Row(
          children: [
            Row(
              children: [
                TextWidget(
                  text: 'choose_excel',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.grey500,
                ),
              ],
            ),
            Container(
              width: 1.w,
              height: 35.h,
              color: AppColors.grey200,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => SizedBox(
                    width: 190.w,
                    child: TextWidget(
                      text: excelFile.value.isEmpty
                          ? 'select_excel'
                          : excelFile.value,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w500,
                      maxline: 3,
                    ),
                  ),
                ),
                Gap.verticalGap(5),
                Row(
                  children: [
                    Gap.horizentalGap(4),
                    Obx(
                      () => InkWell(
                        onTap: chooseExcel,
                        child: AppButton(
                          buttonBorderRaduids: 5.r,

                          buttonBorderColor: AppColors.themeColor.withValues(
                            alpha: 0.7,
                          ),
                          buttonColor: AppColors.whiteColor,
                          buttonTextColor: AppColors.themeColor,
                          buttonWidth: 70.w,
                          buttonHeight: 20.h,
                          buttonFontSize: 12.sp,
                          buttonFontWeight: FontWeight.w500,
                          title: excelFile.value.isNotEmpty
                              ? 'change'
                              : 'choose',
                          isLoading: false.obs,
                        ),
                      ),
                    ),
                    Gap.horizentalGap(7),
                    Obx(
                      () => Visibility(
                        visible: excelFile.value.isNotEmpty,
                        child: InkWell(
                          onTap: uploadExcel,
                          child: AppButton(
                            buttonBorderRaduids: 5.r,
                            indicatorHeight: 10.5.h,
                            indicatorWidth: 12.w,
                            buttonWidth: 70.w,
                            buttonHeight: 20.h,
                            buttonFontSize: 12.sp,
                            buttonFontWeight: FontWeight.w500,
                            title: 'upload',
                            isLoading: isUploading,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

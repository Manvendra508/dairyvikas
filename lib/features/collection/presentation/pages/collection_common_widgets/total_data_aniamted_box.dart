import 'package:DairyVikas/features/collection/presentation/controllers/adjust_collection_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../common/common_widget/common_container.dart';
import '../../../../../common/common_widget/text_widget.dart';
import '../../../../../core/utils/app_icons.dart';
import '../../../../../core/utils/gap.dart';

class TotalDataAniamtedBox extends StatelessWidget {
  final RxBool showBox;
  final RxDouble totalAmount;
  final RxDouble totalLiter;
  final RxDouble avgFat;
  final RxDouble avgSnf;
  final RxDouble avgClr;
  final RxDouble avgRate;
  TotalDataAniamtedBox({
    super.key,
    required this.showBox,
    required this.totalAmount,
    required this.totalLiter,
    required this.avgFat,
    required this.avgSnf,
    required this.avgClr,
    required this.avgRate,
  });

  final _adjustCollectionController = Get.find<AdjustCollectionController>();

  @override
  Widget build(BuildContext context) {
    return _buildTotalDataAnimatedBox();
  }

  _buildTotalDataAnimatedBox() {
    return Obx(
      () => Visibility(
        visible: showBox.value,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: CommonContainer(
            borderRaduis: 0.r,
            width: 1.sw,
            height: _adjustCollectionController.isShowFullDataOpen.value
                ? 135.h
                : 40.h,
            containerColor: AppColors.themeColor,
            bordercolor: AppColors.themeColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: _adjustCollectionController
                            .isShowFullDataOpen
                            .value,
                        replacement: TextWidget(
                          text: 'Show Total data',
                          fontSize: 12.5.sp,
                          textColor: AppColors.grey200,
                          fontWeight: FontWeight.w600,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: 'total_amount',
                              fontSize: 12.5.sp,
                              textColor: AppColors.grey200,
                              fontWeight: FontWeight.w600,
                            ),
                            Gap.verticalGap(4),
                            TextWidget(
                              text: '₹$totalAmount',
                              fontSize: 22.5.sp,
                              textColor: AppColors.grey200,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            _adjustCollectionController
                                .isShowFullDataOpen
                                .value = !_adjustCollectionController
                                .isShowFullDataOpen
                                .value,
                        child: Container(
                          width: 32.w,
                          height: 22.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: AppColors.whiteColor.withValues(alpha: 1),
                          ),
                          child: Center(
                            child: AnimatedRotation(
                              turns:
                                  _adjustCollectionController
                                      .isShowFullDataOpen
                                      .value
                                  ? 0.5
                                  : 0,
                              duration: const Duration(milliseconds: 250),
                              child: AppIcons.arrowUp(
                                size: 17,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible:
                        _adjustCollectionController.isShowFullDataOpen.value,
                    child: Column(
                      children: [
                        Gap.verticalGap(6),
                        Divider(thickness: 0.7, color: AppColors.grey200),
                        Gap.verticalGap(6),
                        Visibility(
                          visible: _adjustCollectionController
                              .isShowFullDataOpen
                              .value,
                          child: _buildTotalData(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildTotalData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildTotalDataText(
                      'liter',
                      textColor: AppColors.grey200,
                      fontsize: 11.sp,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildTotalDataText(
                      'fat',
                      textColor: AppColors.grey200,
                      fontsize: 11.sp,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildTotalDataText(
                      'snf',
                      textColor: AppColors.grey200,
                      fontsize: 11.sp,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildTotalDataText(
                      'clr',
                      textColor: AppColors.grey200,
                      fontsize: 11.sp,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildTotalDataText(
                      'rate',
                      textColor: AppColors.grey200,
                      fontsize: 11.sp,
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: Column(
              //     children: [
              //       _buildTotalDataText(
              //         'total',
              //         textColor: AppColors.grey200,
              //         fontsize: 11.sp,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 7.h, right: 12.w),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(children: [_buildTotalDataText('$totalLiter')]),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [_buildTotalDataText(avgFat.toStringAsFixed(2))],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [_buildTotalDataText(avgSnf.toStringAsFixed(2))],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [_buildTotalDataText(avgClr.toStringAsFixed(2))],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildTotalDataText('₹${avgRate.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: Column(children: [_buildTotalDataText('₹2000')]),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  _buildTotalDataText(String title, {Color? textColor, double? fontsize}) {
    return TextWidget(
      text: title.toUpperCase(),
      fontWeight: FontWeight.w600,
      fontSize: fontsize ?? 14.sp,
      textColor: textColor ?? AppColors.whiteColor,
    );
  }
}

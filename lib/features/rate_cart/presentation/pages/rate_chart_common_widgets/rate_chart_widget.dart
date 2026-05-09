import 'package:DairyVikas/app/extensions/string_ext.dart';
import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/model/rate_chart_model.dart';

class RateChartWidget extends StatelessWidget {
  final int index;
  final RateChartModel rateChart;
  final VoidCallback openCentersSheet;
  final VoidCallback openAssignedsuppliersScreen;
  const RateChartWidget({
    super.key,
    required this.rateChart,
    required this.index,
    required this.openCentersSheet,
    required this.openAssignedsuppliersScreen,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppState.currentRateChartForDetailsPage = rateChart;
        AppNavigation.goToRateChartDetailsPage(rateChart);
      },
      child: Stack(
        children: [
          Container(
            width: 1.sw,

            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(2.r),
              border: Border(
                bottom: BorderSide(color: AppColors.grey200, width: 0.7),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    left: 14.w,
                    right: 25.w,
                    bottom: 16.h,
                    top: 12.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0.w),
                            child: TextWidget(
                              text: '${index + 1}.',
                              fontSize: 12.sp,

                              textColor: AppColors.themeColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Gap.horizentalGap(0.10.sw),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  TextWidget(
                                    text: rateChart.name.capitalize,
                                    fontSize: rateChart.name.length > 25
                                        ? 12.sp
                                        : 13.sp,
                                    textColor: AppColors.grey800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  TextWidget(
                                    text: rateChart.milkTypeId == 1
                                        ? ' (CM)'
                                        : ' (BM)',
                                    fontSize: 13.sp,
                                    textColor: rateChart.milkTypeId == 1
                                        ? AppColors.redColor.withOpacity(0.7)
                                        : AppColors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                              Gap.verticalGap(3.h),
                              TextWidget(
                                text: rateChart.rateChartCategoryId == 1
                                    ? 'Collection Chart'
                                    : 'Milk Sale Chart',
                                fontSize: 11.5.sp,
                                textColor: AppColors.grey500,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TextWidget(
                          //   text: '₹50.00',
                          //   fontSize: 13.sp,
                          //   textColor: AppColors.grey800,
                          //   fontWeight: FontWeight.w600,
                          // ),
                          // Gap.horizentalGap(10),
                          // TextWidget(
                          //   text: rateChart.rateChartCategoryId == 1
                          //       ? 'Collection'
                          //       : 'Milk Sale',
                          //   fontSize: 11.5.sp,
                          //   textColor: AppColors.grey500,
                          //   fontWeight: FontWeight.w500,
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: 10,
            bottom: 4,
            child: Row(
              children: [
                InkWell(
                  onTap: openCentersSheet,
                  child: TextWidget(
                    text: 'Dairy(${rateChart.dairyCount})',
                    fontSize: 11.5.sp,
                    textColor: AppColors.voilate,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap.horizentalGap(10),
                InkWell(
                  onTap: openAssignedsuppliersScreen,
                  child: TextWidget(
                    text: rateChart.rateChartCategoryId == 1
                        ? 'Supplier(${rateChart.supplierCount})'
                        : 'Buyers(${rateChart.buyerCount})',
                    fontSize: 11.5.sp,
                    textColor: AppColors.voilate,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Visibility(
              visible: rateChart.isAssigned == 1,

              child: Container(
                width: 60.w,
                height: 15.h,
                decoration: BoxDecoration(
                  color: AppColors.themeColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(4.r),
                  ),
                ),
                child: Center(
                  child: TextWidget(
                    text: 'Assigned',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

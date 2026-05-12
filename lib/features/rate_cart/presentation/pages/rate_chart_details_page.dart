import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/app_loader.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/rate_cart/data/model/rate_chart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/fixed_chart.dart';
import '../../../../common/common_widget/select_bool_option_widget.dart';
import '../controllers/rate_chart_details_controller.dart';

class RateChartDetailsPage extends GetView<RateChartDetailsController>
    with CommonMixin {
  final RateChartModel rateChart;
  RateChartDetailsPage({super.key, required this.rateChart});

  final RateChartDetailsController _rateChartDetailsController =
      Get.find<RateChartDetailsController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        body: Obx(
          () => Visibility(
            visible: !_rateChartDetailsController.isProcessing.value,
            replacement: DairyVikasLoader(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.verticalGap(7.h),

                  DairyVikasAppBar(
                    title: 'rate_charts',
                    dairyName: AppState.dairyName.capitalize!,
                    trailingWidget:
                        !AppState.currentRateChartForDetailsPage.isEnabled
                        ? _buildAppBarInactiveButton(context)
                        : _buildAppBarActiveButton(context),
                  ),
                  Gap.verticalGap(7.h),
                  CommonContainer(
                    borderRaduis: 0.r,
                    shadowOpacity: 0.1,
                    width: 1.sw,
                    height: 40.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              TextWidget(
                                text: 'milk_type',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.grey500,
                              ),
                              TextWidget(
                                text:
                                    AppState
                                            .currentRateChartForDetailsPage
                                            .milkTypeId ==
                                        1
                                    ? 'cow_milk'
                                    : "buffalo_milk",
                                fontSize: 12.5.sp,

                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          Container(
                            width: 1.w,
                            height: 25.h,
                            color: AppColors.grey200,
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                          ),
                          Row(
                            children: [
                              TextWidget(
                                text: 'category',
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                                textColor: AppColors.grey500,
                              ),
                              TextWidget(
                                text:
                                    AppState
                                            .currentRateChartForDetailsPage
                                            .rateChartCategoryId ==
                                        1
                                    ? 'collection'
                                    : "milk_sale",
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  CommonContainer(
                    borderRaduis: 0.r,
                    shadowOpacity: 0.1,
                    width: 1.sw,
                    height: 40.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              TextWidget(
                                text: 'applied_to',
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.grey500,
                              ),
                            ],
                          ),
                          Container(
                            width: 1.w,
                            height: 25.h,
                            color: AppColors.grey200,
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                          ),
                          Row(
                            children: [
                              TextWidget(
                                text: 'dairy_dynamic'.trParams({
                                  'count':
                                      '${AppState.currentRateChartForDetailsPage.dairyCount}',
                                }),
                                fontWeight: FontWeight.w500,
                                fontSize: 12.5.sp,
                                textColor: AppColors.voilate,
                              ),
                              Gap.horizentalGap(8.w),
                              Container(
                                width: 5.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.voilate.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                              Gap.horizentalGap(8.w),
                              TextWidget(
                                text: 'supplier_dynamic'.trParams({
                                  'count':
                                      '${AppState.currentRateChartForDetailsPage.supplierCount}',
                                }),
                                fontWeight: FontWeight.w500,
                                fontSize: 12.5.sp,
                                textColor: AppColors.voilate,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap.verticalGap(8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: _rateChartDetailsController
                              .rateChartCommonController
                              .getRateChartTypeText(
                                AppState
                                    .currentRateChartForDetailsPage
                                    .chartType,
                              ),
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.themeColor,
                        ),

                        Row(
                          children: [
                            Visibility(
                              visible: !AppState
                                  .currentRateChartForDetailsPage
                                  .isEnabled,
                              child: InkWell(
                                onTap: () => showMyBottomSheet(
                                  context,
                                  SelectBoolOptionWidget(
                                    message: 'delete_rate_chart_warning',
                                    title: 'warning',
                                    callback: () async {
                                      AppNavigation.goBack();
                                      await _rateChartDetailsController
                                          .deleteRateChart();
                                    },
                                  ),
                                ),
                                child: AppButton(
                                  title: 'delete',
                                  isLoading: false.obs,
                                  buttonHeight: 22.h,
                                  buttonWidth: 70.w,
                                  buttonBorderRaduids: 4.r,
                                  buttonTextColor: AppColors.redColor
                                      .withValues(alpha: 0.8),
                                  buttonColor: AppColors.redColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  buttonBorderColor: AppColors.redColor
                                      .withValues(alpha: 0.8),
                                  shadowOpacity: 0.4,
                                  buttonFontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Gap.horizentalGap(10),
                            InkWell(
                              onTap: () {
                                AppState.isRateChartEdit = true;
                                AppNavigation.goToAddRateChartPage();
                              },
                              child: AppButton(
                                title: 'edit',
                                isLoading: false.obs,
                                buttonHeight: 22.h,
                                buttonWidth: 70.w,
                                buttonBorderRaduids: 4.r,
                                buttonTextColor: AppColors.themeColor,
                                buttonColor: AppColors.themeColor.withValues(
                                  alpha: 0.1,
                                ),
                                buttonBorderColor: AppColors.themeColor,
                                shadowOpacity: 0.4,
                                buttonFontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Gap.verticalGap(8.h),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 10.w,
                      ),
                      child: FreezeMatrix(
                        matrix: _rateChartDetailsController.mapper.rateChart,
                        snfValues:
                            AppState.currentRateChartForDetailsPage.chartType ==
                                    2 ||
                                AppState
                                        .currentRateChartForDetailsPage
                                        .chartType ==
                                    5 ||
                                AppState
                                        .currentRateChartForDetailsPage
                                        .chartType ==
                                    4
                            ? _rateChartDetailsController.mapper.clrValues ??
                                  [0.0]
                            : _rateChartDetailsController.mapper.snfValues ??
                                  [0.0],
                        fatValues: _rateChartDetailsController.mapper.fatValues,
                        isSingleType:
                            AppState.currentRateChartForDetailsPage.chartType ==
                                1 ||
                            AppState.currentRateChartForDetailsPage.chartType ==
                                2,
                        headText: _rateChartDetailsController
                            .getRateChartHeaderText(
                              AppState.currentRateChartForDetailsPage.chartType,
                            ),
                      ),
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

  _buildAppBarInactiveButton(BuildContext context) {
    return InkWell(
      onTap: () => showMyBottomSheet(
        context,
        SelectBoolOptionWidget(
          message: 'activate_rate_chart_warning',
          title: 'warning',
          callback: () async {
            AppNavigation.goBack();
            await _rateChartDetailsController.deactivateRateChart();
          },
        ),
      ),
      child: AppButton(
        buttonBorderRaduids: 20.r,
        buttonWidth: 85.w,

        buttonHeight: 30.h,
        title: 'inactive',
        buttonColor: AppColors.redColor.withValues(alpha: 0.8),
        buttonBorderColor: AppColors.redColor.withValues(alpha: 0.8),
        shadowOpacity: 0.6,
        buttonFontWeight: FontWeight.w600,
        isLoading: false.obs,
      ),
    );
  }

  _buildAppBarActiveButton(BuildContext context) {
    return InkWell(
      onTap: () => showMyBottomSheet(
        context,
        SelectBoolOptionWidget(
          height: 170.h,
          message: 'inactivate_rate_chart_warning',
          title: 'warning',
          callback: () async {
            AppNavigation.goBack();
            await _rateChartDetailsController.deactivateRateChart();
          },
        ),
      ),
      child: AppButton(
        buttonBorderRaduids: 20.r,
        buttonWidth: 65.w,

        buttonHeight: 27.h,
        title: 'active',
        buttonColor: AppColors.themeColor,
        buttonBorderColor: AppColors.themeColor,
        shadowOpacity: 0.6,
        buttonFontSize: 12.sp,
        buttonFontWeight: FontWeight.w600,
        isLoading: false.obs,
      ),
    );
  }
}

import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/app_loader.dart';
import 'package:DairyVikas/common/common_widget/check_box_widget.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/cross_button.dart';
import 'package:DairyVikas/common/common_widget/retry_widget.dart';
import 'package:DairyVikas/common/common_widget/shake_widget.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/rate_cart/presentation/controllers/all_rate_charts_controllers.dart';
import 'package:DairyVikas/features/rate_cart/presentation/pages/rate_chart_common_widgets/rate_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/model/rate_chart_model.dart';

class AllRateChartsPage extends GetView<AllRateChartsController>
    with CommonMixin {
  AllRateChartsPage({super.key});

  final AllRateChartsController _allRateChartsController =
      Get.find<AllRateChartsController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Obx(
            () => Visibility(
              visible: !_allRateChartsController.isLoadingChart.value,
              replacement: DairyVikasLoader(),
              child: Visibility(
                visible: !_allRateChartsController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () => _allRateChartsController.getAllRateCharts(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(10),

                    DairyVikasAppBar(
                      title: 'rate_charts',
                      dairyName: AppState.dairyName.capitalize!,
                      trailingWidget: _buildAppBarButton(),
                    ),
                    Gap.verticalGap(6),
                    Divider(thickness: 0.2),
                    Obx(
                      () => Row(
                        children: List.generate(
                          _allRateChartsController.statusFilters.length,
                          (index) => _buildChartStatusFilter(
                            _allRateChartsController
                                .statusFilters[index]['title'],
                            index,
                          ),
                        ),
                      ),
                    ),
                    Gap.verticalGap(5),
                    Obx(
                      () => Row(
                        children: List.generate(
                          _allRateChartsController.milkTypes.length,
                          (index) => _buildChartMilkTypeFilter(
                            _allRateChartsController.milkTypes[index]['value'],
                            index,
                          ),
                        ),
                      ),
                    ),

                    _buildTitleHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: GetBuilder<AllRateChartsController>(
                          builder: (controller) {
                            return Visibility(
                              visible: _allRateChartsController
                                  .filteredChartList
                                  .isNotEmpty,
                              replacement: Center(
                                child: Column(
                                  children: [
                                    Gap.verticalGap(0.2.sh),
                                    TextWidget(
                                      text: 'no_rate_charts_found',
                                      fontSize: 14.sp,
                                      textColor: AppColors.grey600,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center,
                                    ),
                                    Gap.verticalGap(10),
                                    InkWell(
                                      onTap: () =>
                                          AppNavigation.goToAddRateChartPage(),
                                      child: AppButton(
                                        buttonWidth: 100.w,
                                        buttonHeight: 30.h,
                                        shadowOpacity: 0.6,
                                        buttonBorderRaduids: 6.r,
                                        title: 'add_now',
                                        buttonFontWeight: FontWeight.w600,
                                        buttonFontSize: 12.sp,
                                        isLoading: false.obs,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              child: Column(
                                children: List.generate(
                                  _allRateChartsController
                                      .filteredChartList
                                      .length,
                                  (index) => RateChartWidget(
                                    rateChart: _allRateChartsController
                                        .filteredChartList[index],
                                    index: index,
                                    openCentersSheet: () => showMyBottomSheet(
                                      context,
                                      _buildDairyListToAssignChart(
                                        _allRateChartsController
                                                    .filteredChartList[index]
                                                    .dairyCount ==
                                                1
                                            ? 'unassign_to'
                                            : 'assign_to',
                                        _allRateChartsController
                                            .filteredChartList[index],
                                      ),
                                    ),
                                    openAssignedsuppliersScreen: () {
                                      int rateChartCategoryid =
                                          _allRateChartsController
                                              .filteredChartList[index]
                                              .rateChartCategoryId;
                                      AppState.chartIdForassignablesupplierScreen =
                                          _allRateChartsController
                                              .filteredChartList[index]
                                              .id
                                              .toString();
                                      if (rateChartCategoryid == 1) {
                                        // 1 is for collection and 2 for milk sale rate chart
                                        AppState.customerTypeForassignablSupplierScreen =
                                            AppState.supplierCustomerType;
                                      } else {
                                        AppState.customerTypeForassignablSupplierScreen =
                                            AppState.buyerCustomerType;
                                        // this is for if rate chart is type of milk sale. then to fetch only milk buyers.
                                      }
                                      AppNavigation.goToAssignedChartsSuppliersPage();
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildDairyListToAssignChart(String title, RateChartModel chart) {
    return Container(
      width: 1.sw,

      decoration: BoxDecoration(
        color: AppColors.themeColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: title,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
                CrossButton(bgcolor: AppColors.whiteColor),
              ],
            ),
            Gap.verticalGap(4.h),
            Divider(thickness: 0.7, color: AppColors.grey200),
            Visibility(
              visible: chart.dairyCount != 1,
              child: _buildDropdownField(
                hint: 'select_chart_shift',
                items: AppState.shifts,
                selectedValue: _allRateChartsController.selectedShift,
              ),
            ),
            Column(
              children: List.generate(
                1,
                (index) => CommonContainer(
                  containerColor: AppColors.themeColor.withValues(alpha: 0.03),
                  bordercolor: AppColors.themeColor,
                  margin: EdgeInsets.only(top: 7.h),
                  height: 50.h,
                  borderRaduis: 7.r,
                  shadowOpacity: 0.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    TextWidget(
                                      text: AppState.dairyName.capitalize
                                          .toString(),

                                      fontWeight: FontWeight.w700,
                                    ),
                                    Obx(
                                      () => TextWidget(
                                        text:
                                            _allRateChartsController
                                                    .selectedShift['name'] ==
                                                null
                                            ? ''
                                            : ' (${_allRateChartsController.selectedShift['name']}) ',
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500,
                                        textColor: AppColors.grey700,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    AppIcons.location(size: 11),
                                    Gap.horizentalGap(4),
                                    TextWidget(
                                      text:
                                          '${AppState.vendorDistrict}, ${AppState.vendorState}',
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      textColor: AppColors.themeColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            CheckBoxWidget(isSelected: true.obs),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Gap.verticalGap(15),
            InkWell(
              onTap: () {
                if (chart.dairyCount == 1) {
                  _allRateChartsController.unassignRateChartToDairy(
                    chart.id.toString(),
                  );
                } else {
                  _allRateChartsController.assignRateChartToDairy(
                    chart.id.toString(),
                  );
                }
              },
              child: AppButton(
                buttonHeight: 38.h,
                buttonWidth: 1.sw,
                // title: chart.dairyCount == 1 ? 'unassign' : 'assign',
                title: 'save',
                buttonFontSize: 15.sp,
                buttonFontWeight: FontWeight.w600,
                isLoading: false.obs,
                buttonBorderColor: chart.dairyCount == 1
                    ? AppColors.redColor.withValues(alpha: 0.8)
                    : AppColors.themeColor,
                buttonBorderRaduids: 8.r,
                buttonColor: chart.dairyCount == 1
                    ? AppColors.redColor.withValues(alpha: 0.8)
                    : AppColors.themeColor,
                buttonTextColor: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDropdownField({
    required String hint,
    required List<Map<String, dynamic>> items,
    required RxMap<String, dynamic> selectedValue,
  }) {
    return Obx(
      () => ShakeWidget(
        key: _allRateChartsController.shakeKey,
        duration: Duration(milliseconds: 400),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 7.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              width: 0.8,
              color: _allRateChartsController.hasShiftDropDownNotSelected.value
                  ? AppColors.redColor.withValues(alpha: 0.8)
                  : AppColors.lightBorder,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Map<String, dynamic>>(
              value: selectedValue.value.isEmpty ? null : selectedValue.value,
              isExpanded: true,
              hint: TextWidget(
                text: hint,
                fontSize: 12.sp,
                textColor: AppColors.textLight,
              ),
              items: items.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: TextWidget(
                    text: e['name'],
                    textColor: AppColors.blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                selectedValue.value = value;
                _allRateChartsController.hasShiftDropDownNotSelected.value =
                    false;
              },
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
            ),
          ),
        ),
      ),
    );
  }

  _buildAppBarButton() {
    return InkWell(
      onTap: () => AppNavigation.goToAddRateChartPage(),
      child: AppButton(
        buttonBorderRaduids: 20.r,
        buttonWidth: 60.w,
        buttonHeight: 27.h,
        buttonFontSize: 12.sp,
        title: 'add',

        shadowOpacity: 0.6,
        buttonFontWeight: FontWeight.w600,
        isLoading: false.obs,
      ),
    );
  }

  _buildChartStatusFilter(String title, int index) {
    return Obx(() {
      RxBool isSelected =
          (_allRateChartsController.currentStatusFilterIndex.value == index)
              .obs;
      return InkWell(
        splashColor: AppColors.transparentColor,

        onTap: () {
          _allRateChartsController.selectStatus(index);
        },
        child: Container(
          height: 25.h,
          margin: EdgeInsetsGeometry.only(
            left: index == 0 ? 14.w : 8.w,

            bottom: 10.h,
          ),
          decoration: BoxDecoration(
            color: isSelected.value
                ? AppColors.themeColor.withValues(alpha: 0.2)
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(30.r),

            border: Border.all(color: AppColors.grey300, width: 0.5),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextWidget(
                text: title,
                fontSize: 12.sp,
                textColor: isSelected.value
                    ? AppColors.themeColor
                    : AppColors.grey500,
                fontWeight: isSelected.value
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }

  _buildChartMilkTypeFilter(String title, int index) {
    RxBool isSelected = _allRateChartsController.milkTypes[index]['isSelected'];
    return Obx(
      () => InkWell(
        splashColor: AppColors.transparentColor,
        onTap: () {
          _allRateChartsController.selectMilkType(index);
        },
        child: Container(
          height: 25.h,
          margin: EdgeInsetsGeometry.only(
            left: index == 0 ? 14.w : 8.w,

            bottom: 10.h,
          ),
          decoration: BoxDecoration(
            color: isSelected.value
                ? AppColors.themeColor.withValues(alpha: 0.7)
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8.r),

            border: Border.all(color: AppColors.grey300, width: 0.5),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _allRateChartsController.milkTypes[index]['icon'],
                  Gap.horizentalGap(7.w),
                  TextWidget(
                    text: title,
                    fontSize: 11.sp,
                    textColor: isSelected.value
                        ? AppColors.whiteColor
                        : AppColors.grey800,
                    fontWeight: isSelected.value
                        ? FontWeight.w700
                        : FontWeight.w600,
                  ),
                  Visibility(
                    visible: isSelected.value,
                    child: Row(
                      children: [
                        Gap.horizentalGap(5.w),
                        AppIcons.cross(size: 8, color: AppColors.whiteColor),
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

  _buildTitleHeader() {
    return Container(
      width: 1.sw,
      height: 28.h,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(2.r),
        border: Border(bottom: BorderSide(color: AppColors.grey200, width: 1)),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.only(left: 14.w, right: 50.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextWidget(
                  text: 'sno',
                  fontSize: 12.sp,
                  textColor: AppColors.themeColor,
                  fontWeight: FontWeight.w500,
                ),
                Gap.horizentalGap(26),
                TextWidget(
                  text: 'type',
                  fontSize: 12.sp,
                  textColor: AppColors.themeColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            // TextWidget(
            //   text: 'rate',
            //   fontSize: 12.sp,
            //   textColor: AppColors.themeColor,
            //   fontWeight: FontWeight.w500,
            // ),
          ],
        ),
      ),
    );
  }
}

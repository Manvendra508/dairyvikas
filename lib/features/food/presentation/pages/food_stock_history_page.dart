import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/common_container.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/food/data/models/stock_history_model.dart';
import 'package:dairysathi/features/food/presentation/controllers/food_stock_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';
import '../../../../core/utils/app_icons.dart';

class FoodStockHistoryPage extends GetView<FoodStockHistoryController>
    with CommonMixin {
  FoodStockHistoryPage({super.key});

  final FoodStockHistoryController _foodStockHistoryController =
      Get.find<FoodStockHistoryController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Obx(
            () => Visibility(
              visible: !_foodStockHistoryController.isLoading.value,
              replacement: DairySathiLoader(),
              child: Visibility(
                visible: !_foodStockHistoryController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () =>
                      _foodStockHistoryController.getFoodtStockHistory(),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(10),

                    DairySathiAppBar(
                      title: 'stock_history',
                      dairyName: AppState.dairyName.capitalize!,

                      trailingWidget: _buildAppBarButton(),
                    ),
                    Gap.verticalGap(6),
                    Divider(thickness: 0.2),
                    _buildDateFilter(context),
                    Gap.verticalGap(10),
                    Expanded(
                      child: GetBuilder<FoodStockHistoryController>(
                        builder: (controller) {
                          return Visibility(
                            visible: _foodStockHistoryController
                                .filteredStocks
                                .isNotEmpty,
                            replacement: _buildNotFoundDataWidget(),

                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _foodStockHistoryController
                                  .filteredStocks
                                  .length,
                              itemBuilder: (context, index) {
                                return _buildFoodStockHistoryWidget(
                                  _foodStockHistoryController
                                      .filteredStocks[index],
                                );
                              },
                            ),
                          );
                        },
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

  _buildDateFilter(BuildContext context) {
    return InkWell(
      onTap: () => showMyBottomSheet(
        context,
        _buildDateRangeWidget('select_date_range'),
      ),
      child: CommonContainer(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        width: 1.sw,
        height: 38.h,
        containerColor: AppColors.whiteColor,
        bordercolor: AppColors.grey300,
        shadowOpacity: 0.2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AppIcons.calendar(
                    size: 14,
                    color: _foodStockHistoryController.selectedDateRange.isEmpty
                        ? AppColors.grey400
                        : AppColors.themeColor,
                  ),
                  Gap.horizentalGap(10),
                  TextWidget(
                    text: _foodStockHistoryController.selectedDateRange.isEmpty
                        ? 'no_date_range_available'
                        : '${_foodStockHistoryController.selectedDateRange['start']} - ${_foodStockHistoryController.selectedDateRange['end']}',
                    fontSize: 13.sp,
                    textColor:
                        _foodStockHistoryController.selectedDateRange.isEmpty
                        ? AppColors.grey400
                        : AppColors.grey900,

                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              TextWidget(
                text: 'change',
                fontSize: 12.sp,
                textColor: _foodStockHistoryController.selectedDateRange.isEmpty
                    ? AppColors.grey400
                    : AppColors.themeColor,

                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildDateRangeWidget(String title) {
    return Container(
      width: 1.sw,
      height: 0.6.sh,
      decoration: BoxDecoration(
        color: AppColors.themeColor.withOpacity(0.1),
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
                InkWell(
                  onTap: () => AppNavigation.goBack(),
                  child: AppIcons.cross(),
                ),
              ],
            ),
            Gap.verticalGap(4.h),
            Divider(thickness: 0.7, color: AppColors.grey200),
            Gap.verticalGap(4.h),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    AppState.dateRanges.length,
                    (index) => InkWell(
                      onTap: () =>
                          _foodStockHistoryController.selectDateRange(index),
                      child: Container(
                        margin: EdgeInsets.only(top: 5.h),
                        width: 1.sw,
                        height: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color:
                              _foodStockHistoryController
                                      .currentDateRangeIndex
                                      .value ==
                                  index
                              ? AppColors.themeColor.withOpacity(0.02)
                              : AppColors.whiteColor,
                          border: Border.all(
                            width: 0.4,
                            color:
                                _foodStockHistoryController
                                        .currentDateRangeIndex
                                        .value ==
                                    index
                                ? AppColors.themeColor
                                : AppColors.whiteColor,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                text: AppState.dateRanges[index]['start'],
                              ),
                              TextWidget(
                                text: '-',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.h,
                              ),

                              TextWidget(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                text: AppState.dateRanges[index]['end'],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildFoodStockHistoryWidget(StockHistoryModel stockHistoryItem) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            AppState.currentStockHistoryItem = stockHistoryItem;
            AppState.isFoodStockEdit = true;
            AppNavigation.goToAddFoodStockPage(false);
          },
          child: CommonContainer(
            shadowOpacity: 0.3,
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            width: 1.sw,
            borderRaduis: 14.r,
            bordercolor: AppColors.whiteColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: stockHistoryItem.itemName.capitalize!,
                            fontWeight: FontWeight.w600,
                          ),
                          Gap.verticalGap(1.h),
                          TextWidget(
                            text: 'added'.trParams({
                              'date': formatDate(stockHistoryItem.purchaseDate),
                            }),
                            fontSize: 11.sp,
                            textColor: AppColors.grey400,
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: AppColors.grey100,
                          border: Border.all(
                            width: 0.3,
                            color: AppColors.grey200,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 9.w,
                              vertical: 3.h,
                            ),
                            child: TextWidget(
                              text: 'per'.trParams({
                                'count': stockHistoryItem.unit.toUpperCase(),
                              }),
                              textColor: AppColors.grey600.withOpacity(0.8),
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Gap.verticalGap(10),
                  Divider(thickness: 0.7, color: AppColors.grey100),
                  Gap.verticalGap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        //  crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap.horizentalGap(7),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: 'total_qty',
                                textColor: AppColors.grey400.withOpacity(0.8),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              Gap.verticalGap(2),
                              Row(
                                children: [
                                  TextWidget(
                                    text: stockHistoryItem.purchasedQuantity
                                        .toString(),
                                    textColor: AppColors.blackColor,
                                    fontSize: 15.5.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Gap.horizentalGap(3),
                                  TextWidget(
                                    text: 'units',
                                    textColor: AppColors.grey500,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 0.7,
                        color: AppColors.grey200,
                        height: 30.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: Row(
                          children: [
                            Gap.horizentalGap(5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: 'buy_price',
                                  textColor: AppColors.grey400.withOpacity(0.8),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                Gap.verticalGap(2),
                                TextWidget(
                                  text: '₹${stockHistoryItem.purchasePrice}',

                                  textColor: AppColors.blackColor,
                                  fontSize: 14.5.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          child: stockHistoryItem.remainingQuantity != 0
              ? SizedBox.shrink()
              : CommonContainer(
                  shadowOpacity: 0.1,
                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  width: 1.sw,
                  height: 125.h,
                  borderRaduis: 14.r,
                  bordercolor: AppColors.whiteColor,
                  containerColor: AppColors.grey100.withOpacity(0.5),
                  // containerColor: AppColors.blackColor.withOpacity(0.8),
                  child: Center(
                    child: TextWidget(
                      text: 'out_of_stock_lower',
                      textColor: AppColors.redColor.withOpacity(0.8),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  _buildNotFoundDataWidget() {
    return Center(
      child: Column(
        children: [
          Gap.verticalGap(0.2.sh),
          TextWidget(
            text: 'no_history_found',
            fontSize: 14.sp,
            textColor: AppColors.grey600,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          Gap.verticalGap(10),
          InkWell(
            onTap: () => AppNavigation.goToAddFoodStockPage(false),
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
    );
  }

  _buildAppBarButton() {
    return InkWell(
      onTap: () {
        AppState.currentStockItem =
            _foodStockHistoryController.selectedFoodItem;
        AppNavigation.goToAddFoodStockPage(false);
      },
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
}

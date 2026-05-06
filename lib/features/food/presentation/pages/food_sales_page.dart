import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/common_container.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/food/data/models/sale_model.dart';
import 'package:dairysathi/features/food/presentation/controllers/food_sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';
import '../../../../core/utils/app_icons.dart';
import '../controllers/food_stock_controller.dart';

class FoodSalesPage extends GetView<FoodSalesController> with CommonMixin {
  FoodSalesPage({super.key});

  final FoodSalesController _foodSalesController =
      Get.find<FoodSalesController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Obx(
            () => Visibility(
              visible: !_foodSalesController.isLoading.value,
              replacement: DairySathiLoader(),
              child: Visibility(
                visible: !_foodSalesController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () => _foodSalesController.getFoodtSales(),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(10),

                    DairySathiAppBar(
                      title: 'food_sales',
                      dairyName: AppState.dairyName.capitalize!,

                      trailingWidget: _buildAppBarButton(),
                    ),
                    Gap.verticalGap(6),
                    Divider(thickness: 0.2),
                    // _buildDateFilter(context),
                    Obx(
                      () => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                          children: List.generate(
                            _foodSalesController.dateFilters.length,
                            (index) => _buildFoodSalesDateFilter(
                              _foodSalesController.dateFilters[index]['title'],
                              index,
                              context,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap.verticalGap(10),
                    Expanded(
                      child: GetBuilder<FoodStockController>(
                        builder: (controller) {
                          return Visibility(
                            visible:
                                _foodSalesController.filteredSales.isNotEmpty,
                            replacement: _buildNotFoundDataWidget(),

                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount:
                                  _foodSalesController.filteredSales.length,
                              itemBuilder: (context, index) {
                                return _buildFoodSaleWidget(
                                  _foodSalesController.filteredSales[index],
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

  _buildFoodSalesDateFilter(String title, int index, BuildContext context) {
    return Obx(() {
      RxBool isSelected =
          (_foodSalesController.currentDateFilterIndex.value == index).obs;
      return InkWell(
        splashColor: AppColors.transparentColor,
        onTap: () {
          _foodSalesController.selectDateFilter(index, context);
        },
        child: Container(
          height: 25.h,
          margin: EdgeInsetsGeometry.only(
            left: index == 0 ? 14.w : 8.w,
            top: 4.h,
            bottom: 10.h,
          ),
          decoration: BoxDecoration(
            color: isSelected.value
                ? AppColors.themeColor.withOpacity(0.2)
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(30.r),

            border: Border.all(color: AppColors.grey300, width: 0.5),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextWidget(
                text: title,
                fontSize: 10.sp,
                textColor: isSelected.value
                    ? AppColors.themeColor
                    : AppColors.grey600,
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

  _buildFoodSaleWidget(SaleModel sale) {
    return InkWell(
      onTap: () {
        AppState.currentFoodSale = sale;
        AppState.isFoodSaleEdit = true;
        AppNavigation.goToAddFoodSalePage();
      },
      child: CommonContainer(
        shadowOpacity: 0.5,
        margin: EdgeInsets.only(top: 10.h),

        width: 1.sw,
        borderRaduis: 0.r,
        bordercolor: AppColors.whiteColor,
        child: Column(
          children: [
            Container(
              width: 1.sw,
              height: 42.h,
              decoration: BoxDecoration(
                color: AppColors.grey400.withOpacity(0.05),
                border: Border.symmetric(
                  horizontal: BorderSide(
                    width: 0.4,
                    color: AppColors.themeColor.withOpacity(0.2),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.themeColor.withOpacity(0.05),
                              ),
                              child: Center(
                                child: TextWidget(
                                  text: sale.saleBuyer == null
                                      ? sale.saleSupplier!.supplierName
                                            .substring(0, 1)
                                            .toUpperCase()
                                      : sale.saleBuyer!.buyerName
                                            .substring(0, 1)
                                            .toUpperCase(),
                                  textColor: AppColors.themeColor,
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Gap.horizentalGap(5),

                            // Container(
                            //   margin: EdgeInsets.symmetric(horizontal: 7.w),
                            //   width: 4.w,
                            //   height: 4.h,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: AppColors.blackColor,
                            //   ),
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: sale.saleBuyer == null
                                      ? sale.saleSupplier!.supplierName
                                      : sale.saleBuyer!.buyerName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.sp,
                                  textColor: AppColors.themeColor,
                                ),
                                Gap.verticalGap(2),
                                Row(
                                  children: [
                                    TextWidget(
                                      text: 'code:'.trParams({
                                        "code": sale.saleBuyer == null
                                            ? sale.saleSupplier!.supplierCode
                                            : sale.saleBuyer!.buyerCode,
                                      }),

                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.sp,
                                      textColor: AppColors.grey500,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Gap.verticalGap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.horizentalGap(7),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: sale.saleItemDetails.itemName,
                            textColor: AppColors.blackColor.withOpacity(0.8),

                            fontWeight: FontWeight.w600,
                          ),
                          Gap.verticalGap(2),
                          Gap.verticalGap(1.h),
                          TextWidget(
                            text: 'created_date'.trParams({
                              'date': formatDate(sale.createdAt),
                            }),

                            fontSize: 11.sp,
                            textColor: AppColors.grey400,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Row(
                    children: [
                      Gap.horizentalGap(7),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: '${sale.quantity}kg × ₹${sale.sellingPrice}',
                            textColor: AppColors.redColor.withOpacity(0.8),
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          Gap.verticalGap(3),
                          TextWidget(
                            text: '₹${sale.quantity * sale.sellingPrice}',
                            textColor: AppColors.themeColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap.verticalGap(10),
          ],
        ),
      ),
    );
  }

  _buildNotFoundDataWidget() {
    return Center(
      child: Column(
        children: [
          Gap.verticalGap(0.2.sh),
          TextWidget(
            text: 'food_stock_empty',
            fontSize: 14.sp,
            textColor: AppColors.grey600,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          Gap.verticalGap(10),
          InkWell(
            onTap: () => AppNavigation.goToAddFoodSalePage(),
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
    return Row(
      children: [
        InkWell(
          onTap: () => AppNavigation.goToAddFoodSalePage(),
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
        ),
        _buildMenuPopUp(),
      ],
    );
  }

  _buildMenuPopUp() {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      menuPadding: EdgeInsets.zero,
      icon: Padding(
        padding: EdgeInsets.only(left: 12.w),
        child: AppIcons.more(),
      ),
      popUpAnimationStyle: AnimationStyle(
        duration: Duration(milliseconds: 450),
        curve: Curves.bounceInOut,
      ),
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            onTap: () => AppNavigation.goToFoodStocksPage(),
            height: 20,
            padding: EdgeInsets.only(bottom: 14.h, left: 7.h, top: 5.h),
            child: _buildPopMenuTextWidget('food_stock'),
          ),

          PopupMenuItem(
            onTap: () => AppNavigation.goToAllDealerPage(),
            height: 20,
            padding: EdgeInsets.only(bottom: 14.h, left: 7.h),

            child: _buildPopMenuTextWidget('food_dealers'),
          ),
        ];
      },
    );
  }

  _buildPopMenuTextWidget(String title) {
    return TextWidget(
      text: title,
      fontSize: 12.sp,
      textColor: AppColors.grey800,
      fontWeight: FontWeight.w500,
    );
  }
}

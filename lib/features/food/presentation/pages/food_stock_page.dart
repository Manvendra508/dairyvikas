import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/food/data/models/stock_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';
import '../controllers/food_stock_controller.dart';
import '../food_comon_widgets/stock_indicator.dart';

class FoodStockPage extends GetView<FoodStockController> with CommonMixin {
  FoodStockPage({super.key});

  final FoodStockController _allMilkSuppliersController =
      Get.find<FoodStockController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        //   backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Obx(
            () => Visibility(
              visible: !_allMilkSuppliersController.isLoading.value,
              replacement: DairyVikasLoader(),
              child: Visibility(
                visible: !_allMilkSuppliersController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () => _allMilkSuppliersController.getFoodtStock(),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(10),

                    DairyVikasAppBar(
                      title: 'food_stock',
                      dairyName: AppState.dairyName.capitalize!,

                      trailingWidget: _buildAppBarButton(),
                    ),
                    Gap.verticalGap(6),
                    Divider(thickness: 0.2),

                    Obx(
                      () => Row(
                        children: List.generate(
                          _allMilkSuppliersController.statusFilters.length,
                          (index) => _buildFoodStockStatusFilter(
                            _allMilkSuppliersController
                                .statusFilters[index]['title'],
                            index,
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: GetBuilder<FoodStockController>(
                        builder: (controller) {
                          return Visibility(
                            visible: _allMilkSuppliersController
                                .filteredStocks
                                .isNotEmpty,
                            replacement: _buildNotFoundDataWidget(),

                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _allMilkSuppliersController
                                  .filteredStocks
                                  .length,
                              itemBuilder: (context, index) {
                                return _buildFoodStockWidget(
                                  _allMilkSuppliersController
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

  _buildFoodStockWidget(StockModel stockItem) {
    bool isActive = stockItem.stockLeft > 0;
    return Stack(
      children: [
        Positioned(
          child: CommonContainer(
            shadowOpacity: 0.1,
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            width: 1.sw,
            height: 173.h,
            borderRaduis: 14.r,
            bordercolor: AppColors.whiteColor,
            containerColor: AppColors.redColor.withValues(alpha: 1),
            child: Container(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: isActive ? 0 : 4),
          child: InkWell(
            onTap: () {
              AppState.currentStock = stockItem;
              AppNavigation.goToFoodStockHistoryPage();
            },
            child: CommonContainer(
              shadowOpacity: 0.3,
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              width: 1.sw,
              borderRaduis: 14.r,
              bordercolor: AppColors.whiteColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
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
                              text: stockItem.itemName.capitalize!,
                              fontWeight: FontWeight.w600,
                            ),
                            Gap.verticalGap(1.h),
                            stockItem.updatedAt.isEmpty
                                ? SizedBox.shrink()
                                : TextWidget(
                                    text: 'added'.trParams({
                                      'date': formatDate(stockItem.updatedAt),
                                    }),
                                    fontSize: 11.sp,
                                    textColor: AppColors.grey400,
                                  ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            color: isActive
                                ? AppColors.themeColor.withValues(alpha: 0.1)
                                : AppColors.redColor.withValues(alpha: 0.1),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 9.w,
                                vertical: 3.h,
                              ),
                              child: TextWidget(
                                text: isActive ? 'in_stock' : 'out_of_stock',
                                textColor: isActive
                                    ? AppColors.themeColor.withValues(
                                        alpha: 0.8,
                                      )
                                    : AppColors.redColor.withValues(alpha: 0.8),
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Gap.verticalGap(5),
                    Divider(thickness: 0.7, color: AppColors.grey100),
                    Gap.verticalGap(5),
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
                                  textColor: AppColors.grey400.withValues(
                                    alpha: 0.8,
                                  ),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                Gap.verticalGap(2),
                                Row(
                                  children: [
                                    TextWidget(
                                      text: stockItem.totalBought.toString(),
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

                        Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: Row(
                            //  crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap.horizentalGap(7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: 'sold/stock',
                                    textColor: AppColors.grey400.withValues(
                                      alpha: 0.8,
                                    ),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Gap.verticalGap(2),
                                  Row(
                                    children: [
                                      TextWidget(
                                        text:
                                            '${stockItem.totalSold}/${stockItem.stockLeft}',
                                        textColor: isActive
                                            ? AppColors.blackColor
                                            : AppColors.redColor.withValues(
                                                alpha: 0.8,
                                              ),
                                        fontSize: 15.5.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                  Gap.verticalGap(5),
                                  SizedBox(
                                    width: 100.w,
                                    height: 5.h,
                                    child: StockLineIndicator(
                                      value: stockItem.stockLeft.toDouble(),
                                      min: 0,
                                      max: stockItem.totalBought.toDouble(),
                                      activeColor: AppColors.themeColor,
                                      height: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap.verticalGap(7),
                    Divider(thickness: 0.7, color: AppColors.grey100),
                    Gap.verticalGap(4.2),

                    Padding(
                      padding: EdgeInsets.only(left: 8.w, right: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: 'sale_rate',
                                textColor: AppColors.grey400.withValues(
                                  alpha: 0.8,
                                ),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              Gap.verticalGap(2),
                              TextWidget(
                                text: '₹${stockItem.sellingPrice}',

                                textColor: AppColors.blackColor,
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                          Container(
                            width: 0.7,
                            color: AppColors.grey200,
                            height: 30.h,
                          ),

                          Container(
                            width: 150.w,
                            height: 35.h,
                            color: AppColors.whiteColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'history',

                                  textColor: AppColors.blackColor.withValues(
                                    alpha: 0.7,
                                  ),
                                  fontSize: 14.5.sp,
                                  fontWeight: FontWeight.w700,
                                ),

                                Gap.horizentalGap(15),
                                AppIcons.arrowForward(size: 11.sp),
                              ],
                            ),
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
      ],
    );
  }

  // _buildFoodWidget(bool isActive) {
  //   return Stack(
  //     children: [
  //       Positioned(
  //         child: CommonContainer(
  //           shadowOpacity: 0.1,
  //           margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
  //           width: 1.sw,
  //           height: 182.h,
  //           borderRaduis: 14.r,
  //           bordercolor: AppColors.whiteColor,
  //           containerColor: AppColors.redColor.withValues(alpha : 1),
  //           child: Container(),
  //         ),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.only(left: isActive ? 0 : 4),
  //         child: CommonContainer(
  //           shadowOpacity: 0.3,
  //           margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
  //           width: 1.sw,
  //           borderRaduis: 14.r,
  //           bordercolor: AppColors.whiteColor,
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         TextWidget(
  //                           text: 'Mix Pashu Ahhaar',
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                         Gap.verticalGap(1.h),
  //                         TextWidget(
  //                           text: 'Added: 09/01/2026',
  //                           fontSize: 11.sp,
  //                           textColor: AppColors.grey400,
  //                         ),
  //                       ],
  //                     ),
  //                     Container(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(30.r),
  //                         color: isActive
  //                             ? AppColors.themeColor.withValues(alpha : 0.1)
  //                             : AppColors.redColor.withValues(alpha : 0.1),
  //                       ),
  //                       child: Center(
  //                         child: Padding(
  //                           padding: EdgeInsets.symmetric(
  //                             horizontal: 9.w,
  //                             vertical: 3.h,
  //                           ),
  //                           child: TextWidget(
  //                             text: isActive ? 'IN STOCK' : 'OUT OF STOCK',
  //                             textColor: isActive
  //                                 ? AppColors.themeColor.withValues(alpha : 0.8)
  //                                 : AppColors.redColor.withValues(alpha : 0.8),
  //                             fontSize: 9.5.sp,
  //                             fontWeight: FontWeight.w700,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),

  //                 Gap.verticalGap(20),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Row(
  //                       //  crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Container(
  //                           width: 50.w,
  //                           height: 40.h,
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(12.r),
  //                             color: AppColors.grey100.withValues(alpha : 0.6),
  //                           ),
  //                           child: Center(
  //                             child: AppIcons.units(
  //                               color: AppColors.themeColor,
  //                               size: 25,
  //                             ),
  //                           ),
  //                         ),
  //                         Gap.horizentalGap(7),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             TextWidget(
  //                               text: 'TOTAL QTY',
  //                               textColor: AppColors.grey400.withValues(alpha : 0.8),
  //                               fontSize: 11.sp,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                             Gap.verticalGap(2),
  //                             Row(
  //                               children: [
  //                                 TextWidget(
  //                                   text: '25',
  //                                   textColor: AppColors.blackColor,
  //                                   fontSize: 15.5.sp,
  //                                   fontWeight: FontWeight.w600,
  //                                 ),
  //                                 Gap.horizentalGap(3),
  //                                 TextWidget(
  //                                   text: 'Units',
  //                                   textColor: AppColors.grey500,
  //                                   fontSize: 11.sp,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),

  //                     Row(
  //                       //  crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Container(
  //                           width: 50.w,
  //                           height: 40.h,
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(12.r),
  //                             color: AppColors.grey100.withValues(alpha : 0.6),
  //                           ),
  //                           child: Center(
  //                             child: AppIcons.stock(
  //                               color: AppColors.themeColor,
  //                               size: 25,
  //                             ),
  //                           ),
  //                         ),
  //                         Gap.horizentalGap(7),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             TextWidget(
  //                               text: 'SOLD/STOCK',
  //                               textColor: AppColors.grey400.withValues(alpha : 0.8),
  //                               fontSize: 11.sp,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                             Gap.verticalGap(2),
  //                             Row(
  //                               children: [
  //                                 TextWidget(
  //                                   text: '10/30',
  //                                   textColor: isActive
  //                                       ? AppColors.blackColor
  //                                       : AppColors.redColor.withValues(alpha : 0.8),
  //                                   fontSize: 15.5.sp,
  //                                   fontWeight: FontWeight.w600,
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 Gap.verticalGap(15),
  //                 Divider(thickness: 0.7, color: AppColors.grey100),
  //                 Gap.verticalGap(7),

  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             TextWidget(
  //                               text: 'Buy Rate',
  //                               textColor: AppColors.grey400.withValues(alpha : 0.8),
  //                               fontSize: 11.sp,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                             Gap.verticalGap(2),
  //                             Row(
  //                               children: [
  //                                 TextWidget(
  //                                   text: '₹200.0',
  //                                   textColor: AppColors.blackColor,
  //                                   fontSize: 14.5.sp,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                         Container(
  //                           margin: EdgeInsets.symmetric(horizontal: 15.w),
  //                           width: 0.7,
  //                           color: AppColors.grey200,
  //                           height: 30.h,
  //                         ),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             TextWidget(
  //                               text: 'Sale Rate',
  //                               textColor: AppColors.grey400.withValues(alpha : 0.8),
  //                               fontSize: 11.sp,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                             Gap.verticalGap(2),
  //                             Row(
  //                               children: [
  //                                 TextWidget(
  //                                   text: '₹200.0',
  //                                   textColor: AppColors.themeColor,
  //                                   fontSize: 14.5.sp,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),

  //                     AppIcons.arrowForward(),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
            onTap: () => AppNavigation.goToAddFoodStockPage(true),
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
      onTap: () => AppNavigation.goToAddFoodStockPage(true),
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

  _buildFoodStockStatusFilter(String title, int index) {
    return Obx(() {
      RxBool isSelected =
          (_allMilkSuppliersController.currentStatusFilterIndex.value == index)
              .obs;
      return InkWell(
        splashColor: AppColors.transparentColor,
        onTap: () {
          _allMilkSuppliersController.selectStatus(index);
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
}

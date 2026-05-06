import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/common_container.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/milk_sale/presentation/pages/milk_sale_common_widget/milk_sale_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';
import '../controllers/all_milk_sales_controller.dart';

class AllMilkSalesPages extends GetView<AllMilkSalesControllers>
    with CommonMixin {
  AllMilkSalesPages({super.key});

  final AllMilkSalesControllers _allMilkSalesControllers =
      Get.find<AllMilkSalesControllers>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: _buildTotalCalculatedData(),
        // backgroundColor: AppColors.whiteColor,
        body: Obx(
          () => Visibility(
            visible: !_allMilkSalesControllers.isLoading.value,
            replacement: DairySathiLoader(),
            child: Visibility(
              visible: !_allMilkSalesControllers.hasError.value,
              replacement: RetryWidget(
                onRetry: () => _allMilkSalesControllers.getAllMilkSale(),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.verticalGap(20),

                  DairySathiAppBar(
                    title: 'milk_sale',
                    dairyName: AppState.dairyName.capitalize!,

                    //  trailingWidget: _buildAppBarButton(context),
                  ),
                  Gap.verticalGap(6),
                  Divider(thickness: 0.2),

                  Gap.verticalGap(5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActions(
                          'add_sale',
                          AppColors.greenColor,

                          AppIcons.add(color: AppColors.greenColor),
                          1,
                        ),
                        _buildActions(
                          'milk_buyers',
                          AppColors.blue,
                          AppIcons.milkbuyers(color: AppColors.blue),
                          2,
                        ),
                        _buildActions(
                          'bill',
                          AppColors.voilate,
                          AppIcons.bill(color: AppColors.voilate),
                          3,
                        ),
                        // _buildActions(
                        //   'khata',
                        //   AppColors.secondary,
                        //   AppIcons.khata(color: AppColors.secondary),
                        //   4,
                        // ),
                      ],
                    ),
                  ),
                  Gap.verticalGap(10),

                  _buildTopFilters(context),
                  Gap.verticalGap(10),
                  _buildTitleHeader(),

                  Expanded(
                    child: Obx(() {
                      final list = _allMilkSalesControllers.filteredMilkSales;

                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        switchInCurve: Curves.bounceInOut,
                        switchOutCurve: Curves.bounceInOut,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: list.isEmpty
                            ? SingleChildScrollView(
                                key: const ValueKey('empty'),
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                child: _buildNotFounddataWidget(),
                              )
                            : ListView.builder(
                                key: ValueKey(list.length),
                                physics: const BouncingScrollPhysics(),
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return MilkSaleWidget(
                                    milkSale: list[index],
                                    index: index,
                                  );
                                },
                              ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildActions(String title, Color color, Widget icon, int id) {
    return InkWell(
      onTap: () {
        if (id == 1) {
          AppNavigation.goToAddMilkSalePage();
        } else if (id == 2) {
          AppNavigation.goToMilkBuyersPage();
        } else if (id == 3) {
        } else {}
      },
      child: CommonContainer(
        width: 110.w,
        height: 75.h,
        borderRaduis: 13.r,
        containerColor: AppColors.whiteColor,
        shadowOpacity: 0.2,
        bordercolor: AppColors.grey100,
        borderWidth: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 35.w,
              height: 35.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.13),
              ),
              child: Center(child: icon),
            ),
            Gap.verticalGap(8),
            TextWidget(
              text: title,
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
            ),
          ],
        ),
      ),
    );
  }

  _buildTotalCalculatedData() {
    return Obx(
      () => AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Visibility(
          visible: _allMilkSalesControllers.filteredMilkSales.isNotEmpty,
          child: CommonContainer(
            borderRaduis: 0.r,
            width: 1.sw,
            height: _allMilkSalesControllers.isShowFullDataOpen.value
                ? 165.h
                : 43.h,
            containerColor: AppColors.whiteColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: _allMilkSalesControllers.isShowFullDataOpen.value
                            ? 'hide_full_data'
                            : 'show_full_data',
                        fontSize: 13.5.sp,
                        textColor: AppColors.grey600,
                        fontWeight: FontWeight.w600,
                      ),
                      InkWell(
                        onTap: () =>
                            _allMilkSalesControllers.isShowFullDataOpen.value =
                                !_allMilkSalesControllers
                                    .isShowFullDataOpen
                                    .value,
                        child: Container(
                          width: 32.w,
                          height: 22.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: AppColors.themeColor.withOpacity(0.8),
                          ),
                          child: Center(
                            child: AnimatedRotation(
                              turns:
                                  _allMilkSalesControllers
                                      .isShowFullDataOpen
                                      .value
                                  ? 0.5
                                  : 0,
                              duration: const Duration(milliseconds: 250),
                              child: AppIcons.arrowUp(
                                size: 17,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: _allMilkSalesControllers.isShowFullDataOpen.value,
                    child: Column(
                      children: [
                        Gap.verticalGap(5),
                        Divider(color: AppColors.grey100),
                        Gap.verticalGap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              spacing: 4.h,
                              children: [
                                TextWidget(
                                  text: 'snf',
                                  fontSize: 11.sp,
                                  textColor: AppColors.grey400,
                                  fontWeight: FontWeight.w600,
                                ),
                                TextWidget(
                                  text: _allMilkSalesControllers.avgSnf
                                      .toStringAsFixed(2),
                                  fontSize: 15.sp,
                                  textColor: AppColors.grey800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            Column(
                              spacing: 4.h,
                              children: [
                                TextWidget(
                                  text: 'fat',
                                  fontSize: 11.sp,
                                  textColor: AppColors.grey400,
                                  fontWeight: FontWeight.w600,
                                ),
                                TextWidget(
                                  text: _allMilkSalesControllers.avgFat
                                      .toStringAsFixed(2),
                                  fontSize: 15.sp,
                                  textColor: AppColors.grey800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            Column(
                              spacing: 4.h,
                              children: [
                                TextWidget(
                                  text: 'liter',
                                  fontSize: 11.sp,
                                  textColor: AppColors.grey400,
                                  fontWeight: FontWeight.w600,
                                ),
                                TextWidget(
                                  text:
                                      '${_allMilkSalesControllers.totalLitre}',
                                  fontSize: 15.sp,
                                  textColor: AppColors.grey800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            Column(
                              spacing: 4.h,
                              children: [
                                TextWidget(
                                  text: 'rate',
                                  fontSize: 11.sp,
                                  textColor: AppColors.grey400,
                                  fontWeight: FontWeight.w600,
                                ),
                                TextWidget(
                                  text: _allMilkSalesControllers.avgRate
                                      .toStringAsFixed(2),
                                  fontSize: 15.sp,
                                  textColor: AppColors.grey800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            Column(
                              spacing: 4.h,
                              children: [
                                TextWidget(
                                  text: 'amount',
                                  fontSize: 11.sp,
                                  textColor: AppColors.grey400,
                                  fontWeight: FontWeight.w600,
                                ),
                                TextWidget(
                                  text:
                                      '₹${_allMilkSalesControllers.totalAmount.toStringAsFixed(2)}',
                                  fontSize: 15.sp,
                                  textColor: AppColors.grey800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Gap.verticalGap(5),
                        Divider(color: AppColors.grey100),
                        Gap.verticalGap(5),
                        _buildCountBox(),
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

  _buildTopFilters(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => _allMilkSalesControllers.pickDateForFilter(context),
            child: Container(
              width: 110.w,
              height: 32.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),

                border: Border.all(width: 1, color: AppColors.grey300),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => TextWidget(
                        text: _allMilkSalesControllers.curentDate.value,
                        fontSize: 12.sp,
                        textColor: AppColors.grey700,

                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AppIcons.calendar(size: 12, color: AppColors.grey700),
                  ],
                ),
              ),
            ),
          ),
          _buildDropdownField(
            hint: '',
            items: _allMilkSalesControllers.milkTypes,
            selectedValue: _allMilkSalesControllers.selectedMilkType,
            id: 1,
          ),
          _buildDropdownField(
            hint: '',
            items: _allMilkSalesControllers.shiftFilters.take(3).toList(),
            selectedValue: _allMilkSalesControllers.selectedShift,
            id: 2,
          ),
        ],
      ),
    );
  }

  _buildDropdownField({
    required String hint,
    required List<Map<String, dynamic>> items,
    required RxMap<String, dynamic> selectedValue,
    required int id,
  }) {
    return Obx(
      () => Container(
        width: 110.w,
        height: 32.h,
        padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 7.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(width: 1, color: AppColors.grey300),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Map<String, dynamic>>(
            value: selectedValue.value.isEmpty ? null : selectedValue.value,
            isExpanded: true,
            hint: TextWidget(
              text: hint,
              fontSize: 12.sp,
              textColor: AppColors.grey700,
              fontWeight: FontWeight.w500,
            ),
            items: items.map((e) {
              return DropdownMenuItem(
                value: e,
                child: TextWidget(
                  text: id == 1 ? e['value'] : e['name'],
                  textColor: AppColors.grey700,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              selectedValue.value = value;
              _allMilkSalesControllers.filterMilkSales();
            },
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.grey700),
          ),
        ),
      ),
    );
  }

  _buildNotFounddataWidget() {
    return Center(
      child: Column(
        children: [
          TextWidget(
            text: 'no_milksale_found',
            fontSize: 14.sp,
            textColor: AppColors.grey600,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          Gap.verticalGap(10),
          InkWell(
            onTap: () => AppNavigation.goToAddMilkSalePage(),
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

  _buildCountBox() {
    return CommonContainer(
      width: 1.sw,
      height: 40.h,

      borderRaduis: 8.r,
      shadowOpacity: 0.3,
      borderWidth: 0.5,
      bordercolor: AppColors.themeColor,
      containerColor: AppColors.whiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              TextWidget(
                text: 'absent:',
                fontWeight: FontWeight.w600,
                fontSize: 11.5.sp,
                textColor: AppColors.themeColor,
              ),
              Gap.horizentalGap(5),
              TextWidget(
                text: _allMilkSalesControllers
                    .milkSuppliersResponseModel
                    .activeCount,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.grey800,
              ),
            ],
          ),
          Row(
            children: [
              TextWidget(
                text: 'present:',
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.redColor.withOpacity(0.7),
              ),
              Gap.horizentalGap(5),
              TextWidget(
                text: _allMilkSalesControllers
                    .milkSuppliersResponseModel
                    .inactiveCount,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.grey800,
              ),
            ],
          ),
          Row(
            children: [
              TextWidget(
                text: 'active:',
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.grey800,
              ),
              Gap.horizentalGap(5),
              TextWidget(
                text: _allMilkSalesControllers
                    .milkSuppliersResponseModel
                    .totalCount,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.grey800,
              ),
            ],
          ),
        ],
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
        padding: EdgeInsetsGeometry.only(left: 14.w, right: 23.w),
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
                Gap.horizentalGap(17),
                TextWidget(
                  text: 'names/details',
                  fontSize: 12.sp,
                  textColor: AppColors.themeColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            TextWidget(
              text: 'amount',
              fontSize: 12.sp,
              textColor: AppColors.themeColor,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}

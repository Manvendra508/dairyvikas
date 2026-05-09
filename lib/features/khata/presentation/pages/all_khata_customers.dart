import 'dart:math';

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
import 'package:DairyVikas/features/khata/data/models/khatabook_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';
import '../controllers/all_khata_customers_controller.dart';

class AllKhataCustomers extends GetView<AllKhataCustomersController>
    with CommonMixin {
  AllKhataCustomers({super.key});

  final AllKhataCustomersController _allKhataCustomersController =
      Get.find<AllKhataCustomersController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.whiteColor.withOpacity(0.98),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Obx(
            () => Visibility(
              visible: !_allKhataCustomersController.isLoading.value,
              replacement: DairyVikasLoader(),
              child: Visibility(
                visible: !_allKhataCustomersController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () =>
                      _allKhataCustomersController.getAllKhataCustomers(),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(10),

                    DairyVikasAppBar(
                      title: 'khata dashboard',
                      dairyName: AppState.dairyName.capitalize!,

                      trailingWidget: _buildAppBarButton(),
                    ),
                    Gap.verticalGap(8),
                    Container(width: 1.sw, color: AppColors.grey100, height: 1),
                    Container(
                      width: 1.sw,
                      height: 153.h,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: AppColors.grey100,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Gap.verticalGap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildSummeryBox(
                                AppColors.redColor,
                                1,
                                _allKhataCustomersController.totalDebit,
                              ),
                              _buildSummeryBox(
                                AppColors.darkgreenColor,
                                2,
                                _allKhataCustomersController.totalCredit,
                              ),
                            ],
                          ),
                          Gap.verticalGap(18),

                          _buildTextFormFieldForSearch(context),
                        ],
                      ),
                    ),

                    Gap.verticalGap(6),

                    Expanded(
                      child: GetBuilder<AllKhataCustomersController>(
                        builder: (controller) {
                          return Visibility(
                            visible: _allKhataCustomersController
                                .filteredKhataCustomers
                                .isNotEmpty,
                            replacement: _buildNotFoundDataWidget(),

                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _allKhataCustomersController
                                  .filteredKhataCustomers
                                  .length,
                              itemBuilder: (context, index) {
                                return _buildKhataCustomerWidget(
                                  _allKhataCustomersController
                                      .filteredKhataCustomers[index],
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

  _buildSummeryBox(Color color, int id, int amount) {
    return CommonContainer(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      width: 1.sw / 2.2,
      height: 80.h,
      shadowOpacity: 0.1,
      containerColor: color.withOpacity(0.1),
      bordercolor: color.withOpacity(0.8),
      borderWidth: 0.2,
      child: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              text: id == 2 ? 'you_will_get' : 'you_will_give',
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
              textColor: color,
            ),
            Gap.verticalGap(3),
            TextWidget(
              text: '₹$amount',
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
              textColor: color,
            ),
            Gap.verticalGap(10),
            Row(
              children: [
                Visibility(
                  visible: id == 1,
                  replacement: AppIcons.payableArrow(color: color),
                  child: Transform.rotate(
                    angle: -pi / 1,
                    child: AppIcons.payableArrow(color: color),
                  ),
                ),
                Gap.horizentalGap(3),
                TextWidget(
                  text: id == 2
                      ? 'receivalbes'.trParams({
                          'count':
                              _allKhataCustomersController.totalReceivables,
                        })
                      : 'payee'.trParams({
                          'count': _allKhataCustomersController.totalPayee,
                        }),
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp,
                  textColor: color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildTextFormFieldForSearch(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              width: 1.sw / 1.07,
              height: 35.h,
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _allKhataCustomersController.searchController,
                cursorColor: AppColors.grey500,
                cursorHeight: 20,
                onChanged: (value) =>
                    _allKhataCustomersController.searchRecord(value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.grey100,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 18.5.h,
                    horizontal: 25.w,
                  ),

                  focusedBorder: OutlineInputBorder(
                    gapPadding: 5.w,
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      width: 0.8,
                      color: AppColors.grey100.withOpacity(0.4),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 5.w,
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      width: 0.8,
                      color: AppColors.grey200.withOpacity(0.4),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      width: 0.8,
                      color: AppColors.grey200.withOpacity(0.4),
                    ),
                  ),

                  hint: TextWidget(
                    text: 'search',
                    fontSize: 11.sp,
                    textColor: AppColors.grey300,
                  ),
                ),
              ),
            ),
            // Gap.horizentalGap(2),
            // InkWell(
            //   // onTap: () => showMyBottomSheet(
            //   //   context,
            //   //   _buildCommonBottomSheetWidget('sort_by', _buildSortWidget()),
            //   // ),
            //   child: AppIcons.sort(size: 20, color: AppColors.grey600),
            // ),
          ],
        ),
        Positioned(
          top: 15,
          left: 20,
          child: AppIcons.search(color: AppColors.grey300),
        ),
      ],
    );
  }

  _buildKhataCustomerWidget(KhatabookUserModel user) {
    return InkWell(
      onTap: () {
        AppState.currentKhataBookCustomerForUpdate = user;
        AppNavigation.goToAddKhataEntriesPage();
      },
      child: CommonContainer(
        shadowOpacity: 0.3,
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        width: 1.sw,

        borderRaduis: 10.r,
        bordercolor: AppColors.grey200,
        borderWidth: 0.4,

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.h,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.themeColor.withOpacity(0.06),
                      border: Border.all(
                        width: 0.6,
                        color: AppColors.themeColor,
                      ),
                    ),
                    child: Center(
                      child: TextWidget(
                        text: user.name.substring(0, 1).toUpperCase(),

                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        textColor: AppColors.themeColor,
                      ),
                    ),
                  ),
                  Gap.horizentalGap(6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180.w,
                        child: TextWidget(
                          text: user.name.capitalizeFirst!,
                          textColor: AppColors.grey800,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap.verticalGap(2),
                      TextWidget(
                        text: user.mobile.contains('+91')
                            ? user.mobile
                            : '+91-${user.mobile}',
                        textColor: AppColors.grey500,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
              Gap.verticalGap(20),
              Container(width: 1.sw, color: AppColors.grey100, height: 1),
              Gap.verticalGap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text:
                            '₹${user.balance.isNegative ? (-user.balance) : user.balance} ${user.balance.isNegative ? 'Due' : "Adv"}',
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        textColor: user.balance.isNegative
                            ? AppColors.redColor.withOpacity(0.8)
                            : AppColors.themeColor,
                      ),
                      Gap.verticalGap(1),
                      TextWidget(
                        text: _allKhataCustomersController.timeAgo(
                          user.latestEntryDate,
                        ),
                        textColor: AppColors.grey500,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          AppState.iskhataCustomerEdit = true;
                          AppState.currentKhataBookCustomerForUpdate = user;
                          AppNavigation.goToAddKhataCustomerPage();
                        },
                        child: AppButton(
                          title: 'update',
                          isLoading: false.obs,
                          buttonWidth: 80.w,
                          shadowOpacity: 0.2,
                          buttonHeight: 23.h,
                          buttonBorderColor: AppColors.themeColor,
                          buttonColor: AppColors.whiteColor,
                          buttonTextColor: AppColors.themeColor,
                          buttonFontSize: 12.sp,
                          buttonBorderRaduids: 5.r,
                          buttonFontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap.horizentalGap(8),
                      InkWell(
                        onTap: () => makePhoneCall(user.mobile),
                        child: Container(
                          width: 60.h,
                          height: 25.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: AppColors.themeColor,
                            border: Border.all(
                              width: 0.6,
                              color: AppColors.themeColor,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppIcons.call(
                                color: AppColors.whiteColor,
                                size: 10.sp,
                              ),
                              Gap.horizentalGap(6),
                              TextWidget(
                                text: 'call',
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                                textColor: AppColors.whiteColor,
                              ),
                            ],
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
      ),
    );
  }

  _buildNotFoundDataWidget() {
    return Center(
      child: _allKhataCustomersController.searchController.text.isNotEmpty
          ? TextWidget(
              text: 'no_record_found!',
              fontSize: 14.sp,
              textColor: AppColors.grey600,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            )
          : Column(
              children: [
                Gap.verticalGap(0.2.sh),
                TextWidget(
                  text: 'no_khata_customer_available',
                  fontSize: 14.sp,
                  textColor: AppColors.grey600,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                Gap.verticalGap(10),
                InkWell(
                  onTap: () => AppNavigation.goToAddKhataCustomerPage(),
                  child: AppButton(
                    buttonWidth: 100.w,
                    buttonHeight: 30.h,
                    shadowOpacity: 0.6,
                    buttonBorderRaduids: 6.r,
                    title: 'add_customer',
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
      onTap: () => AppNavigation.goToAddKhataCustomerPage(),
      child: AppButton(
        buttonBorderRaduids: 20.r,
        buttonWidth: 105.w,
        buttonHeight: 27.h,
        buttonFontSize: 11.sp,
        title: 'add_customer',

        shadowOpacity: 0.6,
        buttonFontWeight: FontWeight.w600,
        isLoading: false.obs,
      ),
    );
  }
}

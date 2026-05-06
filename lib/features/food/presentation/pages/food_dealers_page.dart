import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/food/data/models/dealer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';
import '../controllers/food_dealers_controller.dart';

class FoodDealersPage extends GetView<FoodDealersController> with CommonMixin {
  FoodDealersPage({super.key});

  final FoodDealersController _foodDealersController =
      Get.find<FoodDealersController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Obx(
            () => Visibility(
              visible: !_foodDealersController.isLoading.value,
              replacement: DairySathiLoader(),
              child: Visibility(
                visible: !_foodDealersController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () => _foodDealersController.getAllFoodDealers(),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(10),

                    DairySathiAppBar(
                      title: 'food_dealers',
                      dairyName: AppState.dairyName.capitalize!,

                      trailingWidget: _buildAppBarButton(),
                    ),
                    Gap.verticalGap(6),
                    Divider(thickness: 0.2),

                    Gap.verticalGap(10),

                    _buildTextFormFieldForSearchMilkSupplier(),
                    Gap.verticalGap(10),
                    _buildTitleHeader(),
                    Expanded(
                      child: GetBuilder<FoodDealersController>(
                        builder: (controller) {
                          return Visibility(
                            visible: _foodDealersController
                                .filteredDealers
                                .isNotEmpty,
                            replacement: _buildNotFounddataWidget(),

                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount:
                                  _foodDealersController.filteredDealers.length,
                              itemBuilder: (context, index) {
                                return _buildMilkDealerWidget(
                                  index,
                                  _foodDealersController.filteredDealers[index],
                                  context,
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

  _buildNotFounddataWidget() {
    return Center(
      child: Column(
        children: [
          Gap.verticalGap(0.2.sh),
          TextWidget(
            text: 'no_dealer_found',
            fontSize: 14.sp,
            textColor: AppColors.grey600,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          Gap.verticalGap(10),
          InkWell(
            onTap: () => AppNavigation.goToAddDealerPage(),
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

  _buildTextFormFieldForSearchMilkSupplier() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          height: 35.h,
          child: TextFormField(
            keyboardType: TextInputType.text,
            controller: _foodDealersController.searchController,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            onChanged: (value) => _foodDealersController.searchDealer(value),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.whiteColor,
              contentPadding: EdgeInsets.symmetric(
                vertical: 13.5.h,
                horizontal: 25.w,
              ),

              focusedBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.themeColor.withOpacity(0.4),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.themeColor.withOpacity(0.4),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.themeColor.withOpacity(0.4),
                ),
              ),

              hint: TextWidget(
                text: 'search_dealer',
                fontSize: 13.sp,
                textColor: AppColors.grey300,
              ),
            ),
          ),
        ),
        Positioned(
          top: 15,
          left: 20,
          child: AppIcons.search(color: AppColors.grey300),
        ),
      ],
    );
  }

  _buildMilkDealerWidget(int index, DealerModel dealer, BuildContext context) {
    return InkWell(
      onTap: () {
        AppState.currentDealerForUpdate = dealer;
        AppState.isDealerEdit = true;
        AppNavigation.goToAddDealerPage();
      },
      child: Container(
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
                bottom: 12.h,
                top: 12.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            text: dealer.dealerName
                                .substring(0, 1)
                                .toUpperCase(),

                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            textColor: AppColors.themeColor,
                          ),
                        ),
                      ),
                      Gap.horizentalGap(0.08.sw),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 180.w,
                            child: TextWidget(
                              text: dealer.dealerName.capitalize!,
                              textColor: AppColors.grey800,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Gap.verticalGap(4.h),
                          Row(
                            children: [
                              TextWidget(
                                text: '+91-${dealer.mobile}',
                                fontSize: 11.sp,
                                textColor: AppColors.grey400,

                                fontWeight: FontWeight.w600,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 6.w),
                                height: 12.h,
                                width: 1,
                                color: AppColors.grey300,
                              ),
                              TextWidget(
                                text: 'code:'.trParams({
                                  'code': dealer.dealerCode,
                                }),
                                fontSize: 11.sp,
                                textColor: AppColors.grey400,
                                fontWeight: FontWeight.w600,
                              ),
                              // InkWell(
                              //   // onTap: () =>
                              //   //     _milkBuyersController.showDeleteBuyerOption(
                              //   //       context,
                              //   //       milkBuyer.id.toString(),
                              //   //       milkBuyer.buyerName,
                              //   //     ),
                              //   child: TextWidget(
                              //     text: 'remove',
                              //     textColor: AppColors.redColor,

                              //     fontSize: 11.sp,
                              //     fontWeight: FontWeight.w600,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  Container(
                    width: 30.h,
                    height: 25.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: AppColors.whiteColor.withOpacity(0.06),
                      border: Border.all(
                        width: 0.6,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () => makePhoneCall(dealer.mobile),
                        child: AppIcons.call(
                          size: 13,
                          color: AppColors.themeColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAppBarButton() {
    return InkWell(
      onTap: () => AppNavigation.goToAddDealerPage(),
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
        padding: EdgeInsetsGeometry.only(left: 14.w, right: 35.w),
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
                Gap.horizentalGap(43.w),
                TextWidget(
                  text: 'names/details',
                  fontSize: 12.sp,
                  textColor: AppColors.themeColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            TextWidget(
              text: 'call',
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

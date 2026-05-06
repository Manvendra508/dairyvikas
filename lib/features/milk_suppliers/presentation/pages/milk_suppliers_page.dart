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
import 'package:dairysathi/features/milk_suppliers/presentation/controllers/get_milk_suppliers_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';
import '../../../../common/common_widget/select_bool_option_widget.dart';
import '../../data/model/milk_supplier_model.dart';

class AllMilkSuppliersPage extends GetView<AllMilkSuppliersController>
    with CommonMixin {
  AllMilkSuppliersPage({super.key});

  final AllMilkSuppliersController _allMilkSuppliersController =
      Get.find<AllMilkSuppliersController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Obx(
            () => Visibility(
              visible: !_allMilkSuppliersController.isLoading.value,
              replacement: DairySathiLoader(),
              child: Visibility(
                visible: !_allMilkSuppliersController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () =>
                      _allMilkSuppliersController.getAllMilkSuppliers(),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(10),

                    DairySathiAppBar(
                      title: 'all_supplier',
                      dairyName: AppState.dairyName.capitalize!,

                      trailingWidget: _buildAppBarButton(),
                    ),
                    Gap.verticalGap(6),
                    Divider(thickness: 0.2),

                    Obx(
                      () => Row(
                        children: List.generate(
                          _allMilkSuppliersController.statusFilters.length,
                          (index) => _buildSupplierStatusFilter(
                            _allMilkSuppliersController
                                .statusFilters[index]['title'],
                            index,
                          ),
                        ),
                      ),
                    ),

                    _buildCountBox(),
                    Gap.verticalGap(10),

                    _buildTextFormFieldForSearchMilkSupplier(),
                    Gap.verticalGap(10),
                    _buildTitleHeader(),
                    Expanded(
                      child: GetBuilder<AllMilkSuppliersController>(
                        builder: (controller) {
                          return Visibility(
                            visible: _allMilkSuppliersController
                                .filteredSuppliersList
                                .isNotEmpty,
                            replacement: _buildNotFounddataWidget(),

                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _allMilkSuppliersController
                                  .filteredSuppliersList
                                  .length,
                              itemBuilder: (context, index) {
                                return _buildMilkSupplierWidget(
                                  index,
                                  _allMilkSuppliersController
                                      .filteredSuppliersList[index],
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
            text: 'no_supplier_found',
            fontSize: 14.sp,
            textColor: AppColors.grey600,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          Gap.verticalGap(10),
          InkWell(
            onTap: () => AppNavigation.goToAddMilkSupplierPage(),
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
            controller: _allMilkSuppliersController.searchController,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            onChanged: (value) =>
                _allMilkSuppliersController.searchSupplier(value),
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
                text: 'search_supplier',
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

  _buildCountBox() {
    return CommonContainer(
      width: 1.sw,
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
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
                text: 'active:',
                fontWeight: FontWeight.w600,
                fontSize: 11.5.sp,
                textColor: AppColors.themeColor,
              ),
              Gap.horizentalGap(5),
              TextWidget(
                text:
                    '${_allMilkSuppliersController.milkSuppliersResponseModel.activeCount}/200',
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.grey800,
              ),
            ],
          ),
          Row(
            children: [
              TextWidget(
                text: 'inactive:',
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.redColor.withOpacity(0.7),
              ),
              Gap.horizentalGap(5),
              TextWidget(
                text: _allMilkSuppliersController
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
                text: 'total:',
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.grey800,
              ),
              Gap.horizentalGap(5),
              TextWidget(
                text: _allMilkSuppliersController
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

  _buildMilkSupplierWidget(
    int index,
    MilkSupplierModel milkSupplier,
    BuildContext context,
  ) {
    bool isActive = milkSupplier.status;
    return InkWell(
      onTap: () => AppNavigation.goToMilkSupplierDetailsPage(milkSupplier),
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
                      Padding(
                        padding: EdgeInsets.only(left: 8.0.w),
                        child: TextWidget(
                          text: '${index + 1}.',
                          fontSize: 12.sp,

                          textColor: isActive
                              ? AppColors.blackColor
                              : AppColors.grey300,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap.horizentalGap(0.08.sw),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 180.w,
                            child: TextWidget(
                              text: milkSupplier.supplierName.capitalize!,
                              textColor: isActive
                                  ? AppColors.grey800
                                  : AppColors.grey300,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Gap.verticalGap(4.h),
                          TextWidget(
                            text: '+91-${milkSupplier.supplierMobile}',
                            fontSize: 11.sp,
                            textColor: isActive
                                ? AppColors.grey400
                                : AppColors.grey300,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => showMyBottomSheet(
                          context,
                          SelectBoolOptionWidget(
                            message: isActive
                                ? 'supplier_active_inactive_message'
                                : "supplier_inactive_active_message",
                            title: 'warning',
                            callback: () async {
                              AppNavigation.goBack();
                              await _allMilkSuppliersController
                                  .changeCutomerStatus(milkSupplier);
                            },
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            color: isActive
                                ? AppColors.themeColor.withOpacity(0.1)
                                : AppColors.redColor.withOpacity(0.1),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 9.w,
                                vertical: 3.h,
                              ),
                              child: TextWidget(
                                text: isActive ? 'active' : 'inactive',
                                textColor: isActive
                                    ? AppColors.themeColor
                                    : AppColors.redColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap.horizentalGap(12),
                      InkWell(
                        onTap: () => isActive
                            ? makePhoneCall(milkSupplier.supplierMobile)
                            : null,
                        child: AppIcons.call(
                          size: 13,
                          color: isActive
                              ? AppColors.themeColor
                              : AppColors.grey300,
                        ),
                      ),
                    ],
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
      onTap: () => AppNavigation.goToAddMilkSupplierPage(),
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

  _buildSupplierStatusFilter(String title, int index) {
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
                Gap.horizentalGap(17),
                TextWidget(
                  text: 'suppliers',
                  fontSize: 12.sp,
                  textColor: AppColors.themeColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            TextWidget(
              text: 'actions',
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

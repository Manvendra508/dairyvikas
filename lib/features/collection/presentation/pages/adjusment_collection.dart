import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/common_container.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/app_regex.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/collection/presentation/pages/collection_common_widgets/total_data_aniamted_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';
import '../../../../core/utils/app_navigation.dart';
import '../../../milk_suppliers/data/model/milk_supplier_model.dart';
import '../controllers/adjust_collection_controller.dart';
import 'collection_common_widgets/collection_adjustment_card.dart';
import 'collection_common_widgets/searched_supplier_info.dart';

class AdjustCollectionPage extends GetView<AdjustCollectionController>
    with CommonMixin {
  AdjustCollectionPage({super.key});

  final AdjustCollectionController _adjustCollectionController =
      Get.find<AdjustCollectionController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.grey100,
        bottomNavigationBar: TotalDataAniamtedBox(
          showBox: _adjustCollectionController.showBottomBox,
          totalAmount: _adjustCollectionController.totalAmount,
          totalLiter: _adjustCollectionController.totalLitre,
          avgFat: _adjustCollectionController.avgFat,
          avgSnf: _adjustCollectionController.avgSnf,
          avgClr: _adjustCollectionController.avgClr,
          avgRate: _adjustCollectionController.avgRate,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Obx(
            () => Visibility(
              visible: !_adjustCollectionController.isLoading.value,
              replacement: DairySathiLoader(),
              child: Visibility(
                visible: !_adjustCollectionController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () =>
                      _adjustCollectionController.getCollectionsForAdjusment(),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(10),

                    DairySathiAppBar(
                      title: 'adjust_collection',

                      dairyName: AppState.dairyName.capitalize!,
                    ),
                    Gap.verticalGap(6),

                    Divider(thickness: 0.2),

                    _buildDateFilter(context),
                    Gap.verticalGap(6),
                    _buildFieldForSearchMilkSupplierCollection(context),
                    Gap.verticalGap(6),
                    Expanded(
                      child: Obx(
                        () => Visibility(
                          visible: _adjustCollectionController
                              .supplierCollection
                              .isNotEmpty,
                          replacement: SingleChildScrollView(
                            child: _buildSearchCollectionButton(),
                          ),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: _adjustCollectionController
                                .supplierCollection
                                .length,
                            itemBuilder: (context, index) {
                              return Collectionadjustmentcard(
                                collection: _adjustCollectionController
                                    .supplierCollection[index],
                                supplierCode: _adjustCollectionController
                                    .searchedSupplier
                                    .milkSupplierCode,
                                collectionDate: _adjustCollectionController
                                    .supplierCollection[index]['row_date'],
                              );
                            },
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
      ),
    );
  }

  _buildSearchCollectionButton() {
    return Center(
      child: Column(
        children: [
          Gap.verticalGap(0.2.sh),
          TextWidget(
            text: 'search_suppliers_by_code_message'.trParams({
              'start': _adjustCollectionController.selectedDateRange['start'],
              'end': _adjustCollectionController.selectedDateRange['end'],
            }),
            fontSize: 11.sp,
            textColor: AppColors.grey600,

            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          Gap.verticalGap(10),
          InkWell(
            onTap: () =>
                _adjustCollectionController.getCollectionsForAdjusment(),
            child: AppButton(
              buttonWidth: 100.w,
              buttonHeight: 30.h,
              shadowOpacity: 0.6,
              buttonBorderRaduids: 6.r,
              title: 'search',
              buttonBorderColor:
                  _adjustCollectionController.isSupplierFoundByCode.value
                  ? AppColors.themeColor
                  : AppColors.grey300,
              buttonTextColor:
                  _adjustCollectionController.isSupplierFoundByCode.value
                  ? AppColors.whiteColor
                  : AppColors.grey600,
              buttonFontWeight: FontWeight.w600,
              buttonColor:
                  _adjustCollectionController.isSupplierFoundByCode.value
                  ? AppColors.themeColor
                  : AppColors.grey300,
              isLoading: false.obs,
            ),
          ),
        ],
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
                  AppIcons.calendar(size: 14, color: AppColors.themeColor),
                  Gap.horizentalGap(10),
                  TextWidget(
                    text: _adjustCollectionController.selectedDateRange.isEmpty
                        ? 'no_date_range_available'
                        : '${_adjustCollectionController.selectedDateRange['start']} - ${_adjustCollectionController.selectedDateRange['end']}',
                    fontSize: 13.sp,
                    textColor: AppColors.grey900,

                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              TextWidget(
                text: 'change',
                fontSize: 12.sp,
                textColor: AppColors.themeColor,

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
                          _adjustCollectionController.selectDateRange(index),
                      child: Container(
                        margin: EdgeInsets.only(top: 5.h),
                        width: 1.sw,
                        height: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color:
                              _adjustCollectionController
                                      .currentDateRangeIndex
                                      .value ==
                                  index
                              ? AppColors.themeColor.withOpacity(0.02)
                              : AppColors.whiteColor,
                          border: Border.all(
                            width: 0.4,
                            color:
                                _adjustCollectionController
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

  _buildFieldForSearchMilkSupplierCollection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Row(
              children: [
                Obx(
                  () => Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    width: 0.8.sw,
                    height: 34.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: AppColors.whiteColor,
                      border: Border.all(
                        width: 0.5,
                        color:
                            _adjustCollectionController.isSupplierInActive.value
                            ? AppColors.redColor.withOpacity(0.8)
                            : AppColors.themeColor,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 130.w,
                            child: _buildTextFormFeildForSupplierCode(
                              _adjustCollectionController.supplierCode,
                              'code',
                              1,
                              TextInputType.number,
                            ),
                          ),
                          InkWell(
                            splashColor: AppColors.transparentColor,
                            onTap: () => _adjustCollectionController
                                .getCollectionsForAdjusment(),
                            child: Container(
                              height: 25.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                color: AppColors.themeColor.withOpacity(0.1),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 9.w,
                                    vertical: 3.h,
                                  ),
                                  child: TextWidget(
                                    text: 'search_collection',
                                    textColor: AppColors.themeColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap.horizentalGap(2),
                InkWell(
                  onTap: () => showMyBottomSheet(
                    context,
                    _buildSupplierList('select_suppliers'),
                  ),
                  child: CommonContainer(
                    width: 40.w,
                    height: 36.h,
                    borderRaduis: 8.r,
                    containerColor: AppColors.whiteColor,
                    bordercolor: AppColors.grey300,
                    child: Center(
                      child: AppIcons.milkSeller(
                        size: 16,
                        color: AppColors.grey700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              top: 15,
              left: 20,
              child: AppIcons.search(color: AppColors.grey300),
            ),
          ],
        ),
        Gap.verticalGap(4),

        Obx(
          () => Visibility(
            visible:
                _adjustCollectionController.isSupplierFoundByCode.value &&
                !_adjustCollectionController.isSupplierInActive.value,
            child: Padding(
              padding: EdgeInsetsGeometry.only(left: 10.w),
              child: SearchedSupplierInfo(
                supplier: _adjustCollectionController.searchedSupplier,
              ),
            ),
          ),
        ),

        Obx(
          () => Visibility(
            visible: _adjustCollectionController.isSupplierInActive.value,
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: TextWidget(
                text: 'is_inactive'.trParams({
                  'name':
                      '${_adjustCollectionController.searchedSupplier.supplierName} is inactive.',
                }),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                textColor: AppColors.redColor.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildTextFormFeildForSupplierCode(
    TextEditingController controller,
    String hint,
    int id,
    TextInputType inputType,
  ) {
    return TextFormField(
      keyboardType: inputType,
      controller: controller,
      cursorColor: AppColors.grey500,
      cursorHeight: 20,

      inputFormatters: [FilteringTextInputFormatter.allow(AppRegex.onlyNumber)],
      onChanged: (value) => _adjustCollectionController.searchSuppliers(value),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20.w, bottom: 5.h),
        border: InputBorder.none,
        hint: TextWidget(
          text: hint,
          fontSize: 11.sp,
          textColor: AppColors.textLight,
        ),
      ),
    );
  }

  _buildSupplierList(String title) {
    return Container(
      width: 1.sw,
      height: 0.85.sh,
      decoration: BoxDecoration(
        color: AppColors.themeColor.withOpacity(0.07),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
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
            _buildTextFormFieldForSearchMilkSupplier(),

            Gap.verticalGap(7.h),

            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount:
                      _adjustCollectionController.filteredmMlkSuppliers.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => _buildCustomerCard(
                    _adjustCollectionController.filteredmMlkSuppliers[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTextFormFieldForSearchMilkSupplier() {
    return Stack(
      children: [
        SizedBox(
          width: 1.sw,

          height: 35.h,
          child: TextFormField(
            keyboardType: TextInputType.text,

            cursorColor: AppColors.grey500,
            cursorHeight: 17,
            onChanged: (value) =>
                _adjustCollectionController.searchSupplierInList(value),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.whiteColor,
              contentPadding: EdgeInsets.symmetric(
                vertical: 18.5.h,
                horizontal: 35.w,
              ),

              focusedBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
              ),

              hint: TextWidget(
                text: 'search_customer',
                fontSize: 10.sp,
                textColor: AppColors.grey300,
              ),
            ),
          ),
        ),
        Positioned(
          top: 15,
          left: 15,
          child: AppIcons.search(color: AppColors.grey300),
        ),
      ],
    );
  }

  _buildCustomerCard(MilkSupplierModel supplier) {
    return InkWell(
      onTap: () => _adjustCollectionController.selectSupplierFromList(supplier),
      child: CommonContainer(
        containerColor: AppColors.whiteColor,

        margin: EdgeInsets.only(top: 4.h, left: 0.w, right: 0.w),
        height: 45.h,
        borderRaduis: 7.r,

        shadowOpacity: 0.3,

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
                    children: [
                      SizedBox(
                        width: 180.w,
                        child: TextWidget(
                          text: supplier.supplierName.capitalize ?? '',
                          textColor: AppColors.grey800,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap.verticalGap(2.h),
                      Row(
                        children: [
                          TextWidget(
                            text: '+91-${supplier.supplierMobile}',
                            fontSize: 9.sp,
                            textColor: AppColors.grey400,
                            fontWeight: FontWeight.w600,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            width: 1,
                            height: 10.h,
                            color: AppColors.grey400,
                          ),
                          TextWidget(
                            text: 'code_count'.trParams({
                              'count': supplier.milkSupplierCode,
                            }),

                            fontSize: 9.sp,
                            textColor: AppColors.grey400,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
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
}

import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_regex.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/food/data/models/supplier_buyer_model.dart';
import 'package:dairysathi/features/food/presentation/controllers/add_food_sale_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/common_container.dart';
import '../../../../common/common_widget/message_box.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../core/utils/app_navigation.dart' show AppNavigation;
import '../../data/models/stock_model.dart';
import '../food_comon_widgets/searched_supplier_buyer_info.dart';

class AddFoodSalePage extends GetView<AddFoodSaleController> with CommonMixin {
  AddFoodSalePage({super.key});

  final AddFoodSaleController _addFoodSaleController =
      Get.find<AddFoodSaleController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.whiteColor,
        body: Obx(
          () => Visibility(
            visible: !_addFoodSaleController.isLoading.value,
            replacement: DairySathiLoader(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.verticalGap(10),

                  DairySathiAppBar(
                    title: AppState.isFoodSaleEdit
                        ? 'update_food_sale'
                        : 'add_food_sale',
                    dairyName: AppState.dairyName.capitalize!,
                  ),
                  Gap.verticalGap(6),

                  Divider(thickness: 0.2),
                  Gap.verticalGap(6),
                  _buildFoodAddFoodSaleForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildFoodAddFoodSaleForm(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              Obx(
                () => MessageBox(
                  message: _addFoodSaleController.validationErrorMessage,
                  isVisible: _addFoodSaleController.hasFieldError.value,
                  isError: true,
                ),
              ),
              InkWell(
                onTap: () => _addFoodSaleController.pickDateForFilter(context),
                child: Container(
                  width: 1.sw,
                  height: 38.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.whiteColor,
                    border: Border.all(width: 0.5, color: AppColors.themeColor),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => TextWidget(
                            text:
                                _addFoodSaleController
                                    .selectedDateString
                                    .value
                                    .isEmpty
                                ? 'select_date'
                                : _addFoodSaleController
                                      .selectedDateString
                                      .value,
                            fontSize: 13.sp,
                            textColor: AppColors.grey500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        AppIcons.calendar(size: 15, color: AppColors.grey500),
                      ],
                    ),
                  ),
                ),
              ),

              Gap.verticalGap(10),
              _buildSupplierOrBuyerSearch(context),
              Gap.verticalGap(10),

              _buildTextFormFeild(
                _addFoodSaleController.foodName,
                'enter_food_name',
                1,
                TextInputType.text,
                true,
                context,
              ),
              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addFoodSaleController.foodQuantity,
                'enter_food_qty',
                2,
                TextInputType.number,
                false,
                context,
              ),

              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addFoodSaleController.foodSellingRate,
                'enter_rate',
                3,
                TextInputType.number,
                false,
                context,
              ),
              // Gap.verticalGap(10),
              // _buildTextFormFeild(
              //   _addFoodSaleController.receiptNumber,
              //   'enter_receipt_no',
              //   4,
              //   TextInputType.number,
              //   false,
              //   context,
              // ),
              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addFoodSaleController.saleAmount,
                'amount',
                5,
                TextInputType.number,
                true,
                context,
              ),

              Gap.verticalGap(25),
              InkWell(
                onTap: () {
                  if (AppState.isFoodSaleEdit) {
                    _addFoodSaleController.updateFoodSale();
                  } else {
                    _addFoodSaleController.addNewFoodSale();
                  }
                },
                child: AppButton(
                  title: AppState.isFoodSaleEdit ? 'update' : 'add',
                  buttonFontWeight: FontWeight.w600,
                  isLoading: _addFoodSaleController.proccessing,
                  shadowOpacity: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTextFormFeild(
    TextEditingController controller,
    String hint,
    int id,
    TextInputType inputType,
    bool? readOnly,
    BuildContext context,
  ) {
    return TextFormField(
      onTap: () => id == 1 && !AppState.isFoodSaleEdit
          ? showMyBottomSheet(context, _buildFoodStockList('select_food_item'))
          : null,
      keyboardType: inputType,
      controller: controller,
      cursorColor: AppColors.grey500,
      cursorHeight: 20,
      onChanged: (v) => id == 3 || id == 2
          ? _addFoodSaleController.calculateSaleAmount()
          : null,
      readOnly: readOnly ?? false,
      inputFormatters: [
        FilteringTextInputFormatter.allow(AppRegex.onlyNumber),

        LengthLimitingTextInputFormatter(35),
      ],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.5.h, horizontal: 7.w),
        focusedBorder: OutlineInputBorder(
          gapPadding: 5.w,
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 0.8, color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          gapPadding: 5.w,
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 0.8, color: AppColors.lightBorder),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 0.8, color: AppColors.lightBorder),
        ),
        suffixIcon: id == 1 && !AppState.isFoodSaleEdit
            ? InkWell(
                splashColor: AppColors.transparentColor,

                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                  height: 20.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: AppColors.grey500.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 3.h,
                      ),
                      child: TextWidget(
                        text: 'select_food',
                        textColor: AppColors.grey700,

                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),

        hint: TextWidget(
          text: hint,
          fontSize: 12.sp,
          textColor: AppColors.textLight,
        ),
      ),
    );
  }

  _buildSupplierOrBuyerSearch(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          splashColor: AppColors.transparentColor,
          onTap: () => showMyBottomSheet(
            context,
            _buildSupplierBuyersList('select_supplier_or_buyer'),
          ),
          child: Container(
            width: 1.sw,
            height: 38.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.whiteColor,
              border: Border.all(width: 0.5, color: AppColors.themeColor),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 160.w,

                    child: TextFormField(
                      onTap: () => showMyBottomSheet(
                        context,
                        _buildSupplierBuyersList('select_supplier_or_buyer'),
                      ),
                      keyboardType: TextInputType.number,
                      controller: _addFoodSaleController.supllierOrBuyerCode,
                      cursorColor: AppColors.grey500,
                      cursorHeight: 20,
                      readOnly: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(AppRegex.onlyNumber),
                      ],
                      // onChanged: (value) => _addFoodSaleController
                      //     .searchDealerToAddFoodStockOf(value),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hint: TextWidget(
                          text: 'search_supplier_or_buyer',
                          fontSize: 12.sp,
                          textColor: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 20.h,
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
                          text: 'search',
                          textColor: AppColors.themeColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Gap.verticalGap(2),
        Obx(
          () => Visibility(
            visible: _addFoodSaleController.isSupplierBuyerInActive.value,
            child: TextWidget(
              text:
                  '${_addFoodSaleController.searchedSupplierBuyer.name} is inactive.',
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              textColor: AppColors.redColor.withOpacity(0.8),
            ),
          ),
        ),
        Gap.verticalGap(2),
        GetBuilder<AddFoodSaleController>(
          builder: (controller) => Visibility(
            visible: controller.isSupplierBuyerFoundByCode.value,
            child: SearchedSupplierBuyerInfo(
              sb: controller.searchedSupplierBuyer,
            ),
          ),
        ),
      ],
    );
  }

  _buildSupplierBuyersList(String title) {
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
            _buildTextFormFieldForSearch('search_supplier_or_buyer', 1),

            Gap.verticalGap(7.h),

            Expanded(
              child: GetBuilder<AddFoodSaleController>(
                builder: (controller) => ListView.builder(
                  itemCount: controller.supplierAndBuyersForBottomList.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => _buildSupplierBuyerCard(
                    controller.supplierAndBuyersForBottomList[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildFoodStockList(String title) {
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
            _buildTextFormFieldForSearch('search_food_item', 2),

            Gap.verticalGap(7.h),

            Expanded(
              child: GetBuilder<AddFoodSaleController>(
                builder: (controller) => ListView.builder(
                  itemCount: controller.filteredvendorFoodStock.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => _buildFoodStockCard(
                    controller.filteredvendorFoodStock[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTextFormFieldForSearch(String hint, int id) {
    return Stack(
      children: [
        Container(
          width: 1.sw,
          margin: EdgeInsets.symmetric(horizontal: 0.w),
          height: 35.h,
          child: TextFormField(
            keyboardType: TextInputType.text,

            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            onChanged: (value) {
              if (id == 1) {
                _addFoodSaleController.searchSupplierBuyerInList(value);
              } else {
                _addFoodSaleController.searchFoodItemInList(value);
              }
            },
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
                text: hint,
                fontSize: 12.sp,
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

  _buildSupplierBuyerCard(SupplierBuyerModel supplierBuyer) {
    return InkWell(
      onTap: () {
        if (!supplierBuyer.status) return;
        _addFoodSaleController.selectSupplierBuyerBySearchingInList(
          supplierBuyer,
        );
      },
      child: CommonContainer(
        containerColor: supplierBuyer.status
            ? AppColors.whiteColor
            : AppColors.grey200.withOpacity(0.5),

        margin: EdgeInsets.only(top: 4.h, left: 0.w, right: 0.w),
        height: 45.h,
        borderRaduis: 7.r,

        shadowOpacity: supplierBuyer.status ? 0.3 : 0.1,

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
                          text: supplierBuyer.name.capitalize!,
                          textColor: supplierBuyer.status
                              ? AppColors.grey800
                              : AppColors.grey400,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap.verticalGap(2.h),
                      Row(
                        children: [
                          TextWidget(
                            text: '+91-${supplierBuyer.mobile}',
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
                            text: 'code:'.trParams({
                              'code': supplierBuyer.code,
                            }),

                            fontSize: 9.sp,
                            textColor: AppColors.grey400,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 22.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: supplierBuyer.type == 'ms'
                          ? AppColors.themeColor.withOpacity(0.1)
                          : AppColors.redColor.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: supplierBuyer.status
                            ? TextWidget(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                text: supplierBuyer.type == 'ms'
                                    ? 'supplier'
                                    : 'buyer',
                                textColor: supplierBuyer.type == 'ms'
                                    ? AppColors.themeColor
                                    : AppColors.redColor,
                              )
                            : TextWidget(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                text: 'inactive',
                                textColor: AppColors.redColor.withOpacity(0.4),
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

  _buildFoodStockCard(StockModel stock) {
    bool isOutOfStock = stock.stockLeft == 0;
    return InkWell(
      onTap: () {
        if (!isOutOfStock) {
          _addFoodSaleController.selectFoodItem = stock;
          _addFoodSaleController.foodName.text = stock.itemName;
          AppNavigation.goBack();
        }
      },
      child: CommonContainer(
        containerColor: !isOutOfStock
            ? AppColors.whiteColor
            : AppColors.grey200.withOpacity(0.5),

        margin: EdgeInsets.only(top: 4.h, left: 0.w, right: 0.w),
        height: 45.h,
        borderRaduis: 7.r,

        shadowOpacity: isOutOfStock ? 0.3 : 0.1,

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
                          text: stock.itemName,

                          textColor: !isOutOfStock
                              ? AppColors.grey800
                              : AppColors.grey400,
                          fontSize: 12.7.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap.verticalGap(2.h),
                      TextWidget(
                        text: 'Quantity Remaining: ${stock.stockLeft}',
                        textColor: AppColors.grey400,
                        fontSize: 9.4.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Container(
                    height: 22.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: !isOutOfStock
                          ? AppColors.themeColor.withOpacity(0.1)
                          : AppColors.redColor.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: TextWidget(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          text: isOutOfStock ? 'Out of Stock' : 'In Stock',
                          textColor: isOutOfStock
                              ? AppColors.redColor.withOpacity(0.4)
                              : AppColors.themeColor,
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
}

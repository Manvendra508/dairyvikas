import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/app_regex.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/milk_sale/presentation/controllers/add_milksale_controller.dart';
import 'package:DairyVikas/features/milk_sale/presentation/pages/milk_sale_common_widget/searched_buyer_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../core/utils/textformfield_formater.dart';
import '../../data/models/milk_buyer_model.dart';

class AddMilksalePage extends GetView<AddMilksaleController> with CommonMixin {
  AddMilksalePage({super.key});

  final AddMilksaleController _addMilksaleController =
      Get.find<AddMilksaleController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        //  backgroundColor: AppColors.whiteColor,
        body: Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(vertical: 0.h),
            child: Visibility(
              visible: !_addMilksaleController.isLoading.value,
              replacement: DairyVikasLoader(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.verticalGap(10),

                  DairyVikasAppBar(
                    title: AppState.isMilkSaleEdit ? 'update_sale' : 'add_sale',
                    dairyName: AppState.dairyName.capitalize!,
                  ),
                  Gap.verticalGap(6),

                  Divider(thickness: 0.2),
                  Gap.verticalGap(6),
                  _buildAddMilkSaleForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildAddMilkSaleForm(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () =>
                        _addMilksaleController.pickDateForFilter(context),
                    child: Container(
                      width: 1.sw / 2.3,
                      height: 38.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColors.whiteColor,
                        border: Border.all(
                          width: 0.5,
                          color: AppColors.themeColor,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => TextWidget(
                                text:
                                    _addMilksaleController
                                        .selectedDateString
                                        .value
                                        .isEmpty
                                    ? 'select_date'
                                    : _addMilksaleController
                                          .selectedDateString
                                          .value,
                                fontSize: 13.sp,
                                textColor: AppColors.grey500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            AppIcons.calendar(
                              size: 15,
                              color: AppColors.grey500,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  _buildDropdownField(
                    hint: 'select_chart_shift',
                    items: AppState.shifts,
                    selectedValue: _addMilksaleController.selectedShift,
                  ),
                ],
              ),
              Gap.verticalGap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Container(
                      width: 1.sw,
                      height: 38.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColors.whiteColor,
                        border: Border.all(
                          width: 0.5,
                          color: _addMilksaleController.isBuyerInActive.value
                              ? AppColors.redColor.withOpacity(0.8)
                              : AppColors.themeColor,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150.w,
                              child: _buildTextFormFeild(
                                _addMilksaleController.buyerCode,
                                'enter_buyer_code',
                                1,
                                TextInputType.number,
                              ),
                            ),

                            InkWell(
                              splashColor: AppColors.transparentColor,
                              onTap: () => showMyBottomSheet(
                                context,
                                _buildBuyersList('select_buyers'),
                              ),
                              child: Container(
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gap.verticalGap(3),
                  GetBuilder<AddMilksaleController>(
                    builder: (controller) => Visibility(
                      visible:
                          _addMilksaleController.isBuyerFoundByCode.value &&
                          !_addMilksaleController.isBuyerInActive.value,
                      child: SearchedBuyerInfo(
                        buyer: _addMilksaleController.searchedBuyer,
                      ),
                    ),
                  ),
                  Gap.verticalGap(3),
                  Obx(
                    () => Visibility(
                      visible: _addMilksaleController.isBuyerInActive.value,
                      child: TextWidget(
                        text:
                            '${_addMilksaleController.searchedBuyer.buyerName} is inactive.',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.redColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),

              Gap.verticalGap(12),
              Obx(
                () => Visibility(
                  visible:
                      _addMilksaleController.isBuyerFoundByCode.value &&
                      !_addMilksaleController.isBuyerInActive.value,
                  child: Row(
                    children: List.generate(
                      _addMilksaleController.milkTypes.length,
                      (index) => _buildChartMilkTypeFilter(
                        _addMilksaleController.milkTypes[index]['value'],
                        index,
                      ),
                    ),
                  ),
                ),
              ),

              Gap.verticalGap(12),
              _addMilksaleController.selectedMilkType['id'] == null
                  ? SizedBox.shrink()
                  : Obx(
                      () => Visibility(
                        visible:
                            _addMilksaleController.showOnlyFixedRateField.value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildFixedRateAndLiterTextFormFiled(
                              _addMilksaleController
                                  .setReadyOnlyToFixedRateFiled,
                              'liter',
                              _addMilksaleController.selectedMilkType['id'] ==
                                      '1'
                                  ? _addMilksaleController
                                        .fixedCowRateLiterController
                                  : _addMilksaleController
                                        .fixedBuffaloRateLiterController,
                              1,
                            ),
                            _buildFixedRateAndLiterTextFormFiled(
                              _addMilksaleController
                                  .setReadyOnlyToFixedRateFiled,
                              _addMilksaleController.selectedMilkType['id'] ==
                                      '1'
                                  ? 'fixed_cow_rate'
                                  : 'fixed_buffalo_rate',
                              _addMilksaleController.selectedMilkType['id'] ==
                                      '1'
                                  ? _addMilksaleController
                                        .fixedCowRateController
                                  : _addMilksaleController
                                        .fixedBuffaloRateController,
                              2,
                            ),
                          ],
                        ),
                      ),
                    ),
              Obx(
                () => Visibility(
                  visible: _addMilksaleController.showRateChartForm.value,
                  child: Column(
                    children: [
                      GetBuilder<AddMilksaleController>(
                        builder: (controller) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildUnitsContainer(
                              'enter_liter',
                              context,
                              1,
                              _addMilksaleController.literController,
                              readOnly: _addMilksaleController.can.steps.isEmpty
                                  ? false
                                  : true,
                            ),
                            _buildUnitsContainer(
                              'enter_fat',
                              context,
                              2,
                              _addMilksaleController.fatController,
                            ),
                          ],
                        ),
                      ),
                      Gap.verticalGap(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildUnitsContainer(
                            'enter_snf',
                            context,
                            3,
                            _addMilksaleController.snfController,
                          ),
                          _buildUnitsContainer(
                            'rate',
                            context,
                            4,
                            _addMilksaleController.rateController,
                            readOnly: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Gap.verticalGap(15),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     _buildUnitsContainer(
              //       'amount',
              //       context,
              //       _addMilksaleController.amountController,
              //       readOnly: true,
              //       width: 1.sw / 3.4,
              //     ),
              //     _buildUnitsContainer(
              //       'paid',
              //       context,
              //       _addMilksaleController.paidController,
              //       width: 1.sw / 3.4,
              //     ),
              //     _buildUnitsContainer(
              //       'balance',
              //       context,
              //       _addMilksaleController.balanceController,
              //       readOnly: true,
              //       width: 1.sw / 3.4,
              //     ),
              //   ],
              // ),
              // Gap.verticalGap(20),
              InkWell(
                onTap: () =>
                    _addMilksaleController.addOrUpdateMilkSale(context, false),
                child: AppButton(
                  title: AppState.isMilkSaleEdit ? 'update' : 'add',
                  isLoading: _addMilksaleController.proccessing,
                  shadowOpacity: 0.3,
                  buttonFontSize: 15.sp,
                  buttonFontWeight: FontWeight.w600,
                ),
              ),
              Gap.verticalGap(6),
            ],
          ),
        ),
      ),
    );
  }

  _buildChartMilkTypeFilter(String title, int index) {
    RxBool isActive =
        (_addMilksaleController.milkTypes[index]['id'] ==
                _addMilksaleController.selectedMilkType['id'])
            .obs;
    return Obx(
      () => InkWell(
        splashColor: AppColors.transparentColor,
        onTap: () {
          _addMilksaleController.selectMilkType(
            _addMilksaleController.milkTypes[index]['id'],
          );

          _addMilksaleController.findRateChartOfFoundBuyer();
        },
        child: Container(
          height: 25.h,
          margin: EdgeInsetsGeometry.only(
            left: index == 0 ? 0.w : 15.w,

            bottom: 10.h,
          ),
          decoration: BoxDecoration(
            color: isActive.value
                ? AppColors.themeColor.withOpacity(0.7)
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
                  _addMilksaleController.milkTypes[index]['icon'],
                  Gap.horizentalGap(7.w),
                  TextWidget(
                    text: title,
                    fontSize: 11.sp,
                    textColor: isActive.value
                        ? AppColors.whiteColor
                        : AppColors.grey800,
                    fontWeight: isActive.value
                        ? FontWeight.w700
                        : FontWeight.w600,
                  ),
                ],
              ),
            ),
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
  ) {
    return TextFormField(
      keyboardType: inputType,
      controller: controller,
      cursorColor: AppColors.grey500,
      cursorHeight: 20,

      inputFormatters: [FilteringTextInputFormatter.allow(AppRegex.onlyNumber)],
      onChanged: (value) =>
          _addMilksaleController.searchBuyerToAddMilkSaleFor(value),
      decoration: InputDecoration(
        border: InputBorder.none,
        hint: TextWidget(
          text: hint,
          fontSize: 12.sp,
          textColor: AppColors.textLight,
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
      () => Container(
        width: 1.sw / 2.3,
        height: 40.h,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 7.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(width: 0.8, color: AppColors.lightBorder),
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
            },
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.themeColor),
          ),
        ),
      ),
    );
  }

  _buildFixedRateAndLiterTextFormFiled(
    bool? readOnly,
    String hint,
    TextEditingController controller,
    int id,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: hint,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          textColor: AppColors.grey700,
        ),
        Gap.verticalGap(5),
        Container(
          width: 1.sw / 2.2,
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.whiteColor,
            border: Border.all(width: 0.5, color: AppColors.themeColor),
          ),
          child: TextFormField(
            readOnly: readOnly ?? false,
            keyboardType: TextInputType.number,
            controller: controller,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,

            inputFormatters: [
              FilteringTextInputFormatter.allow(AppRegex.onlyNumber),
              LengthLimitingTextInputFormatter(id == 1 ? 3 : 4),
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10.w),
              border: InputBorder.none,
              hint: TextWidget(
                text: hint,
                fontSize: 11.sp,
                textColor: AppColors.textLight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildUnitsContainer(
    String hint,
    BuildContext context,
    int id,
    TextEditingController textController, {
    bool? readOnly,
    double? width,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: hint,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          textColor: AppColors.grey700,
        ),
        Gap.verticalGap(5),
        Container(
          width: width ?? 1.sw / 2.2,
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.whiteColor,
            border: Border.all(width: 0.5, color: AppColors.themeColor),
          ),
          child: TextFormField(
            readOnly: readOnly ?? false,
            keyboardType: TextInputType.number,
            controller: textController,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            onChanged: (value) {
              if (value.length == 3 && id != 1) {
                FocusScope.of(context).nextFocus();
              }

              _addMilksaleController.checkPriceForFatAnsSnfValue();
            },
            inputFormatters: id == 1
                ? [
                    FilteringTextInputFormatter.allow(AppRegex.onlyNumber),
                    LengthLimitingTextInputFormatter(4),
                  ]
                : [
                    FilteringTextInputFormatter.allow(AppRegex.onlyNumber),
                    OneDecimalInputFormatter(),
                  ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10.w),
              border: InputBorder.none,
              hint: TextWidget(
                text: hint,
                fontSize: 12.sp,
                textColor: AppColors.textLight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildBuyersList(String title) {
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
            _buildTextFormFieldForSearchMilkBuyer(),

            Gap.verticalGap(7.h),

            Expanded(
              child: GetBuilder<AddMilksaleController>(
                builder: (controller) => ListView.builder(
                  itemCount:
                      _addMilksaleController.milkBuyersForBottomList.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => _buildMilkBuyerCard(
                    _addMilksaleController.milkBuyersForBottomList[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTextFormFieldForSearchMilkBuyer() {
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
            onChanged: (value) =>
                _addMilksaleController.searchBuyerInList(value),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.whiteColor,
              contentPadding: EdgeInsets.symmetric(
                vertical: 18.5.h,
                horizontal: 25.w,
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
                text: 'search_buyer',
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

  _buildMilkBuyerCard(MilkBuyerModel buyer) {
    return InkWell(
      onTap: () => _addMilksaleController.selectSupplierBySearching(buyer),
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
                          text: buyer.buyerName.capitalize!,
                          textColor: AppColors.grey800,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap.verticalGap(2.h),
                      Row(
                        children: [
                          TextWidget(
                            text: '+91-${buyer.buyerMobile}',
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
                              'code': buyer.milkBuyerCode,
                            }),
                            // text: 'code: ${buyer.milkBuyerCode}',
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

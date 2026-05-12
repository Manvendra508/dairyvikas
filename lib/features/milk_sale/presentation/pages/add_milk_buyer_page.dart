import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_regex.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/message_box.dart';
import '../../../../core/utils/app_icons.dart';
import '../controllers/add_milk_buyer_controller.dart';

class AddMilkBuyerPage extends GetView<AddMilkBuyerController>
    with CommonMixin {
  AddMilkBuyerPage({super.key});

  final AddMilkBuyerController _addMilkBuyerController =
      Get.find<AddMilkBuyerController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap.verticalGap(10),

              DairyVikasAppBar(
                title: AppState.isMilkBuyerEdit ? 'update_buyer' : 'add_buyer',
                dairyName: AppState.dairyName.capitalize!,
              ),
              Gap.verticalGap(6),

              Divider(thickness: 0.2),
              Gap.verticalGap(6),
              _buildAddMilkBuyerForm(context),
            ],
          ),
        ),
      ),
    );
  }

  _buildAddMilkBuyerForm(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              Obx(
                () => MessageBox(
                  message: _addMilkBuyerController.validationErrorMessage,
                  isVisible: _addMilkBuyerController.hasFieldError.value,
                  isError: true,
                ),
              ),
              _buildTextFormFeild(
                _addMilkBuyerController.buyerCode,
                'enter_buyer_code',
                1,
                TextInputType.number,
                AppState.isMilkBuyerEdit ? true : false,
              ),
              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addMilkBuyerController.buyerFullName,
                'enter_buyer_name',
                2,
                TextInputType.text,
                false,
              ),

              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addMilkBuyerController.buyerMobileNumber,
                'enter_mobile_number',
                4,
                TextInputType.number,
                AppState.isMilkBuyerEdit ? true : false,
              ),

              Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(12),
                    TextWidget(
                      text: 'select_milk_type',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Gap.verticalGap(10),
                    Obx(
                      () => Row(
                        children: List.generate(
                          _addMilkBuyerController.milkTypes.length,
                          (index) => _buildChartMilkTypeFilter(
                            _addMilkBuyerController.milkTypes[index]['value'],
                            index,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap.verticalGap(10),

              GetBuilder<AddMilkBuyerController>(
                builder: (controller) => Column(
                  children: [
                    Visibility(
                      visible: _addMilkBuyerController.milktypIds.contains(1),
                      child: _buildRateTypeSection(
                        'Cow Milk Rate Type (🐄)',
                        1,
                        _addMilkBuyerController.selectedCowRateType,
                        _addMilkBuyerController.fixedCowRateController,
                        _addMilkBuyerController.showCowFixedRateFormField,
                      ),
                    ),
                    Gap.verticalGap(10),
                    Visibility(
                      visible: _addMilkBuyerController.milktypIds.contains(2),
                      child: _buildRateTypeSection(
                        'Buffalo Milk Rate Type (🐃)',
                        2,
                        _addMilkBuyerController.selectedBuffaloRateType,
                        _addMilkBuyerController.fixedBuffaloRateController,
                        _addMilkBuyerController.showBufflaoFixedRateFormField,
                      ),
                    ),
                  ],
                ),
              ),
              Gap.verticalGap(25),

              InkWell(
                onTap: () {
                  if (AppState.isMilkBuyerEdit) {
                    _addMilkBuyerController.updateMilkBuyer();
                  } else {
                    _addMilkBuyerController.addNewMilkBuyer();
                  }
                },

                child: AppButton(
                  title: AppState.isMilkBuyerEdit ? 'update' : 'add',
                  buttonFontWeight: FontWeight.w600,
                  isLoading: _addMilkBuyerController.proccessing,
                  shadowOpacity: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildRateTypeSection(
    String title,
    int id,
    RxMap<String, dynamic> selectedRateType,
    TextEditingController rateController,
    RxBool showRateField,
  ) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        color: AppColors.grey100.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(width: 0.8, color: AppColors.lightBorder),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 7.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget(
            text: title,
            textColor: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
          Gap.verticalGap(7),
          _buildDropdownField(
            hint: 'select_rate_type',
            items: _addMilkBuyerController.rateTypes,
            selectedValue: selectedRateType,
            id: id,
          ),
          Obx(
            () => showRateField.value ? Gap.verticalGap(10) : SizedBox.shrink(),
          ),
          _buildTextFormFeildforFixedRate(rateController, showRateField),
        ],
      ),
    );
  }

  _buildTextFormFeildforFixedRate(
    TextEditingController rateController,
    RxBool show,
  ) {
    return Obx(
      () => Visibility(
        visible: show.value,
        child: Container(
          width: 1.sw,
          height: 36.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.whiteColor,
            border: Border.all(width: 1, color: AppColors.lightBorder),
          ),
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: rateController,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            onChanged: (value) {},
            inputFormatters: [
              FilteringTextInputFormatter.allow(AppRegex.onlyNumber),
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10.w, bottom: 6.h),
              border: InputBorder.none,
              hint: TextWidget(
                text: 'fixed_milk_sale_rate',
                fontSize: 12.sp,
                textColor: AppColors.textLight,
              ),
            ),
          ),
        ),
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
        padding: EdgeInsets.symmetric(horizontal: 7.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
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
                  text: e['value'],
                  textColor: AppColors.blackColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              selectedValue.value = value;
              _addMilkBuyerController.selectRatetype(id);
            },
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
          ),
        ),
      ),
    );
  }

  _buildChartMilkTypeFilter(String title, int index) {
    return Obx(
      () => InkWell(
        splashColor: AppColors.transparentColor,
        onTap: () {
          // _addMilkBuyerController.milkTypes[index]['isSelected'].value =
          //     !_addMilkBuyerController.milkTypes[index]['isSelected'].value;
          // _addMilkBuyerController.selectedMilkType.value =
          //     _addMilkBuyerController.milkTypes[index];
          _addMilkBuyerController.currentMilkTypeId =
              _addMilkBuyerController.milkTypes[index]['id'];
          _addMilkBuyerController.selectMilkTypes();
        },
        child: Container(
          height: 25.h,
          margin: EdgeInsetsGeometry.only(
            left: index == 0 ? 0.w : 15.w,

            bottom: 10.h,
          ),
          decoration: BoxDecoration(
            color:
                _addMilkBuyerController.milktypIds.contains(
                  _addMilkBuyerController.milkTypes[index]['id'],
                )
                ? AppColors.themeColor.withValues(alpha: 0.7)
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
                  _addMilkBuyerController.milkTypes[index]['icon'],
                  Gap.horizentalGap(7.w),
                  TextWidget(
                    text: title,
                    fontSize: 11.sp,
                    textColor:
                        _addMilkBuyerController.milktypIds.contains(
                          _addMilkBuyerController.milkTypes[index]['id'],
                        )
                        ? AppColors.whiteColor
                        : AppColors.grey800,
                    fontWeight:
                        _addMilkBuyerController
                            .milkTypes[index]['isSelected']
                            .value
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
    bool? readyOnly,
  ) {
    return TextFormField(
      keyboardType: inputType,
      controller: controller,
      cursorColor: AppColors.grey500,
      cursorHeight: 20,
      readOnly: readyOnly ?? false,
      inputFormatters: [
        if (id == 1 || id == 4)
          FilteringTextInputFormatter.allow(AppRegex.onlyNumber),

        LengthLimitingTextInputFormatter(id == 4 ? 10 : 50),
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
        suffix: id == 4 && !AppState.isMilkBuyerEdit
            ? InkWell(
                onTap: () => _addMilkBuyerController.getContactNameORNumber(),
                child: AppIcons.phoneBook(
                  size: 16,
                  color: AppColors.themeColor,
                ),
              )
            : null,
        hint: TextWidget(
          text: hint,
          fontSize: 12.sp,
          textColor: AppColors.textLight,
        ),
      ),
    );
  }
}

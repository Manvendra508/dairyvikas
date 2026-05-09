import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_regex.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/milk_suppliers/presentation/controllers/add_supplier_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/message_box.dart';

class AddNewMilkSupplier extends GetView<AddMilkSupplierController>
    with CommonMixin {
  AddNewMilkSupplier({super.key});

  final AddMilkSupplierController _addMilkSupplierController =
      Get.find<AddMilkSupplierController>();

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
                title: AppState.isSupplierEdit
                    ? 'update_supplier'
                    : 'add_supplier',
                dairyName: AppState.dairyName.capitalize!,
              ),
              Gap.verticalGap(6),

              Divider(thickness: 0.2),
              Gap.verticalGap(6),
              _buildAddSupplierForm(context),
            ],
          ),
        ),
      ),
    );
  }

  _buildAddSupplierForm(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              Obx(
                () => MessageBox(
                  message: _addMilkSupplierController.validationErrorMessage,
                  isVisible: _addMilkSupplierController.hasFieldError.value,
                  isError: true,
                ),
              ),
              _buildTextFormFeild(
                _addMilkSupplierController.supplierCode,
                'enter_supplier_code',
                1,
                TextInputType.number,
                AppState.isSupplierEdit ? true : false,
              ),
              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addMilkSupplierController.supplierFullName,
                'enter_supplier_name',
                2,
                TextInputType.text,
                false,
              ),

              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addMilkSupplierController.supplierMobileNumber,
                'enter_mobile_number',
                4,
                TextInputType.number,
                AppState.isSupplierEdit ? true : false,
              ),
              Gap.verticalGap(10),

              _buildDropdownField(
                hint: 'select_milk_type',
                items: _addMilkSupplierController.milkTypes,
                selectedValue: _addMilkSupplierController.selectedMilkType,
              ),
              Visibility(
                visible: AppState.isSupplierEdit,
                child: Column(
                  children: [
                    Gap.verticalGap(10),
                    _buildDropdownField(
                      hint: 'select_status',
                      items: _addMilkSupplierController.status,
                      selectedValue: _addMilkSupplierController.selectedStatus,
                    ),
                  ],
                ),
              ),
              Gap.verticalGap(25),
              InkWell(
                onTap: () {
                  if (AppState.isSupplierEdit) {
                    _addMilkSupplierController.updateMilkSupplier();
                  } else {
                    _addMilkSupplierController.addNewMilkSupplier();
                  }
                },
                child: AppButton(
                  title: AppState.isSupplierEdit ? 'update' : 'add',
                  buttonFontWeight: FontWeight.w600,
                  isLoading: _addMilkSupplierController.proccessing,
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
    bool readyOnly,
  ) {
    return TextFormField(
      keyboardType: inputType,
      controller: controller,
      cursorColor: AppColors.grey500,
      cursorHeight: 20,
      readOnly: readyOnly,
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

        suffix: id == 4 && !AppState.isSupplierEdit
            ? InkWell(
                onTap: () =>
                    _addMilkSupplierController.getContactNameORNumber(),
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

  _buildDropdownField({
    required String hint,
    required List<Map<String, dynamic>> items,
    required RxMap<String, dynamic> selectedValue,
  }) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 7.w),
        decoration: BoxDecoration(
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
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              selectedValue.value = value;
            },
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
          ),
        ),
      ),
    );
  }
}

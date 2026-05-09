import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/message_box.dart'
    show MessageBox;
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/model/dairy_setting_data_model.dart';
import '../controllers/dairy_center_settings_controller.dart';

class DairyCenterSettingsPage extends GetView<DairyCenterSettingsController> {
  DairyCenterSettingsPage({super.key});

  final DairyCenterSettingsController _dairyCenterSettingsController =
      Get.find<DairyCenterSettingsController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.whiteColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Gap.verticalGap(12.h),
              DairyVikasAppBar(title: 'dairy_center_settings'),
              Gap.verticalGap(15),
              _buildDropDowns(),
            ],
          ),
        ),
      ),
    );
  }

  _buildDropDowns() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        spacing: 10.h,
        children: [
          Obx(
            () => MessageBox(
              message: _dairyCenterSettingsController.validationErrorMessage,
              isVisible: _dairyCenterSettingsController.hasFieldError.value,
              isError: true,
            ),
          ),
          _buildDropdownField(
            hint: 'select_collection_type',
            items: _dairyCenterSettingsController.collectionTypes,

            id: 1,
          ),
          _buildDropdownField(
            hint: 'select_milk_type',
            items: _dairyCenterSettingsController.milkTypes,

            id: 2,
          ),
          _buildDropdownField(
            hint: 'select_collection_shift',
            items: _dairyCenterSettingsController.collectionShifts,

            id: 3,
          ),
          _buildDropdownField(
            hint: 'select_payment_period',
            items: _dairyCenterSettingsController.paymentPeriods,

            id: 4,
          ),

          Gap.verticalGap(15),
          InkWell(
            onTap: () => _dairyCenterSettingsController.addDairyDetails(),
            child: AppButton(
              title: 'next',
              buttonFontWeight: FontWeight.w600,
              isLoading: _dairyCenterSettingsController.isProccessing,
              shadowOpacity: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  _buildDropdownField({
    required String hint,
    required List<DairySettingDataModel> items,

    required int id,
  }) {
    return GetBuilder<DairyCenterSettingsController>(
      builder: (controller) {
        // Pick selected value based on ID
        DairySettingDataModel selectedValue;

        if (id == 1) {
          selectedValue = controller.selectedCollectionTypeId;
        } else if (id == 2) {
          selectedValue = controller.selectedMilkTypeId;
        } else if (id == 3) {
          selectedValue = controller.selectedCollectionShiftId;
        } else {
          selectedValue = controller.selectedPaymentPeriodId;
        }
        return Container(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 7.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(width: 0.8, color: AppColors.lightBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DairySettingDataModel>(
              value: selectedValue.id == '0' ? null : selectedValue,
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
                    text: e.name,
                    textColor: AppColors.grey700,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                _dairyCenterSettingsController.selectValues(id, value);
              },
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
            ),
          ),
        );
      },
    );
  }
}

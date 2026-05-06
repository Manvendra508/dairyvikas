import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/app_loader.dart';
import 'package:dairysathi/common/common_widget/retry_widget.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../auth/registration_flow/data/model/dairy_setting_data_model.dart';
import '../controllers/app_settings_controller.dart';

class AppSettingPage extends GetView<AppSettingController> with CommonMixin {
  AppSettingPage({super.key});

  final AppSettingController _appSettingController =
      Get.find<AppSettingController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.grey100,
          bottomNavigationBar:
              _appSettingController.isLoading.value ||
                  _appSettingController.hasError.value
              ? SizedBox.shrink()
              : InkWell(
                  onTap: () => _appSettingController.updateDairySettingsData(),
                  child: AppButton(
                    title: 'UPDATE',
                    isLoading: false.obs,
                    buttonBorderRaduids: 0.r,
                    buttonFontSize: 15.sp,
                    buttonFontWeight: FontWeight.w600,
                  ),
                ),
          body: Visibility(
            visible: !_appSettingController.isLoading.value,
            replacement: DairySathiLoader(),
            child: Visibility(
              visible: !_appSettingController.hasError.value,
              replacement: RetryWidget(
                onRetry: () => _appSettingController.firstMethod(),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.verticalGap(10),

                  DairySathiAppBar(title: 'Dairy Settings'),
                  Gap.verticalGap(12),
                  Divider(thickness: 0.2),
                  _buildDairySettingsAction(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildMiddleHeading(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(
          text: title,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          textColor: AppColors.blackColor,
        ),
      ],
    );
  }

  _buildDairySettingsAction() {
    return Expanded(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // _buildMiddleHeading('Dairy Settings'),
              // Gap.verticalGap(15),
              TextWidget(
                text: 'Basic Details',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.blackColor,
              ),
              Gap.verticalGap(10),
              _buildDairyDetailsForm(),
              Gap.verticalGap(15),
              TextWidget(
                text: 'Dairy Operation',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.blackColor,
              ),
              Gap.verticalGap(10),
              _buildDropDowns(),
              Gap.verticalGap(15),
            ],
          ),
        ),
      ),
    );
  }

  _buildDropDowns() {
    return Column(
      spacing: 5.h,
      children: [
        _buildDropdownField2(
          hint: 'select_collection_type',
          items: _appSettingController.collectionTypes,

          id: 1,
        ),
        _buildDropdownField2(
          hint: 'select_milk_type',
          items: _appSettingController.milkTypes,

          id: 2,
        ),
        _buildDropdownField2(
          hint: 'select_collection_shift',
          items: _appSettingController.collectionShifts,

          id: 3,
        ),
        _buildDropdownField2(
          hint: 'select_payment_period',
          items: _appSettingController.paymentPeriods,

          id: 4,
        ),
      ],
    );
  }

  _buildDropdownField2({
    required String hint,
    required List<DairySettingDataModel> items,

    required int id,
  }) {
    return GetBuilder<AppSettingController>(
      builder: (controller) {
        // Pick selected value based on ID
        DairySettingDataModel selectedValue;

        if (id == 1) {
          selectedValue = controller.selectedCollectionType;
        } else if (id == 2) {
          selectedValue = controller.selectedMilkType;
        } else if (id == 3) {
          selectedValue = controller.selectedCollectionShift;
        } else {
          selectedValue = controller.selectedPaymentPeriod;
        }
        return Container(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 7.w),
          height: 40.h,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(width: 0.8, color: AppColors.grey200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DairySettingDataModel>(
              value: items.contains(selectedValue) ? selectedValue : null,
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
                    textColor: AppColors.grey900,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                _appSettingController.selectValues(id, value);
              },
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
            ),
          ),
        );
      },
    );
  }

  _buildDairyDetailsForm() {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          controller: _appSettingController.dairyNameController,
          cursorColor: AppColors.grey500,
          cursorHeight: 20,
          style: TextStyle(fontSize: 12.sp),
          decoration: InputDecoration(
            fillColor: AppColors.whiteColor,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 7.w),
            focusedBorder: OutlineInputBorder(
              gapPadding: 5.w,
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(width: 0.8, color: AppColors.lightBorder),
            ),
            enabledBorder: OutlineInputBorder(
              gapPadding: 5.w,
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(width: 0.8, color: AppColors.lightBorder),
            ),
            hint: TextWidget(
              text: 'enter_dairyname',
              fontSize: 12.sp,
              textColor: AppColors.textLight,
            ),
          ),
        ),
        Gap.verticalGap(5),
        TextFormField(
          keyboardType: TextInputType.text,
          controller: _appSettingController.villageNameController,
          cursorColor: AppColors.grey500,
          cursorHeight: 20,

          style: TextStyle(fontSize: 12.sp),
          decoration: InputDecoration(
            fillColor: AppColors.whiteColor,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 7.w),
            focusedBorder: OutlineInputBorder(
              gapPadding: 5.w,
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(width: 0.8, color: AppColors.lightBorder),
            ),
            enabledBorder: OutlineInputBorder(
              gapPadding: 5.w,
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(width: 0.8, color: AppColors.lightBorder),
            ),
            hint: TextWidget(
              text: 'enter_village_name',
              fontSize: 12.sp,
              textColor: AppColors.textLight,
            ),
          ),
        ),
        Gap.verticalGap(5),

        TextFormField(
          keyboardType: TextInputType.text,
          controller: _appSettingController.talukaNameController,
          cursorColor: AppColors.grey500,
          cursorHeight: 20,

          style: TextStyle(fontSize: 12.sp),
          decoration: InputDecoration(
            fillColor: AppColors.whiteColor,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: 10.5.h,
              horizontal: 7.w,
            ),
            focusedBorder: OutlineInputBorder(
              gapPadding: 5.w,
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(width: 0.8, color: AppColors.lightBorder),
            ),
            enabledBorder: OutlineInputBorder(
              gapPadding: 5.w,
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(width: 0.8, color: AppColors.lightBorder),
            ),
            hint: TextWidget(
              text: 'enter_taluka_name',
              fontSize: 12.sp,
              textColor: AppColors.textLight,
            ),
          ),
        ),
        Gap.verticalGap(5),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _appSettingController.pincodeController,
              cursorColor: AppColors.grey500,
              cursorHeight: 20,
              inputFormatters: [LengthLimitingTextInputFormatter(6)],
              onChanged: (value) {
                _appSettingController.picodeNumberCount.value = value.length;
                if (value.length == 6) {
                  _appSettingController.verifyPincode();
                } else {
                  _appSettingController.isVerifiedPincode.value = false;
                }
              },
              style: TextStyle(fontSize: 12.sp),
              decoration: InputDecoration(
                fillColor: AppColors.whiteColor,
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.5.h,
                  horizontal: 7.w,
                ),
                focusedBorder: OutlineInputBorder(
                  gapPadding: 5.w,
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    width: 0.8,
                    color: AppColors.lightBorder,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 5.w,
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    width: 0.8,
                    color: AppColors.lightBorder,
                  ),
                ),
                hint: TextWidget(
                  text: 'enter_pincode_number',
                  fontSize: 12.sp,
                  textColor: AppColors.textLight,
                ),
                suffix: Obx(
                  () => TextWidget(
                    text: '${_appSettingController.picodeNumberCount.value}/6',
                    fontSize: 12.sp,
                    textColor: AppColors.textExtraLight,
                  ),
                ),
              ),
            ),

            Obx(
              () => Visibility(
                visible: _appSettingController.isVerifiedPincode.value,
                child: Padding(
                  padding: EdgeInsets.only(top: 2.h, right: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppIcons.check(size: 9, color: AppColors.greenColor),
                      Gap.horizentalGap(3),
                      TextWidget(
                        text: 'verified',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.greenColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Gap.verticalGap(5),
        _buildDropdownField(
          hint: 'select_state',
          items: AppState.indianStates,
          selectedValue: _appSettingController.selectedState,
          type: 'state',
        ),

        Obx(
          () => Visibility(
            visible: _appSettingController.selectedState.isNotEmpty,
            child: Column(
              children: [
                Gap.verticalGap(5),
                _buildDropdownField(
                  hint: 'select_district',
                  items:
                      _appSettingController.selectedState['districs'] ??
                      <Map<String, dynamic>>[],
                  selectedValue: _appSettingController.selectedDisctrict,
                  type: 'district',
                ),
                Gap.verticalGap(5),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildDropdownField({
    required String hint,
    required List<Map<String, dynamic>> items,
    required RxMap<String, dynamic> selectedValue,
    required String type,
  }) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 7.w),
        height: 40.h,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(width: 0.8, color: AppColors.grey200),
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
                  text:
                      _appSettingController.languageCode == 'en' ||
                          _appSettingController.languageCode == ''
                      ? e['name_en']
                      : e['name_hi'],
                  textColor: AppColors.blackColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              selectedValue.value = value;

              if (type == 'state') {
                _appSettingController.selectedDisctrict.value =
                    <String, dynamic>{};
              }
            },
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
          ),
        ),
      ),
    );
  }
}

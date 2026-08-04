import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/app_version_text.dart';
import 'package:DairyVikas/common/common_widget/message_box.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/model/dairy_setting_data_model.dart';
import '../controllers/dairy_center_details_controller.dart';

class DairyCenterDetailsPage extends GetView<DairyCenterDetailsController> {
  final bool isFromDashboard;
  DairyCenterDetailsPage({super.key, required this.isFromDashboard});

  final DairyCenterDetailsController _dairyCenterDetailsController =
      Get.find<DairyCenterDetailsController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (isFromDashboard) {
            return true;
          } else {
            return false;
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.whiteColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Gap.verticalGap(12.h),
                DairyVikasAppBar(
                  title: 'dairy_center_detail',
                  showLeading: false,
                  // trailingWidget: isFromDashboard
                  //     ? null
                  //     : _buildSkipTextButton(),
                ),
                Gap.verticalGap(12.h),

                _buildDairyDetailsForm(),
                Gap.verticalGap(0.31.sh),
                AppVersionText(),
                Gap.verticalGap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildSkipTextButton() {
    return InkWell(
      onTap: () => _dairyCenterDetailsController.skipAddDairyStep(),
      child: TextWidget(
        text: 'skip',
        fontWeight: FontWeight.w500,
        textColor: AppColors.grey400,
      ),
    );
  }

  _buildDairyDetailsForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          Obx(
            () => MessageBox(
              message: _dairyCenterDetailsController.validationErrorMessage,
              isVisible: _dairyCenterDetailsController.hasFieldError.value,
              isError: true,
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _dairyCenterDetailsController.dairyNameController,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,

            decoration: InputDecoration(
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
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              hint: TextWidget(
                text: 'enter_dairyname',
                fontSize: 12.sp,
                textColor: AppColors.textLight,
              ),
            ),
          ),
          Gap.verticalGap(10.h),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _dairyCenterDetailsController.villageNameController,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,

            decoration: InputDecoration(
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
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              hint: TextWidget(
                text: 'enter_village_name',
                fontSize: 12.sp,
                textColor: AppColors.textLight,
              ),
            ),
          ),
          Gap.verticalGap(10.h),

          TextFormField(
            keyboardType: TextInputType.text,
            controller: _dairyCenterDetailsController.talukaNameController,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,

            decoration: InputDecoration(
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
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              hint: TextWidget(
                text: 'enter_taluka_name',
                fontSize: 12.sp,
                textColor: AppColors.textLight,
              ),
            ),
          ),
          Gap.verticalGap(10.h),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _dairyCenterDetailsController.pincodeController,
                cursorColor: AppColors.grey500,
                cursorHeight: 20,
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                onChanged: (value) {
                  _dairyCenterDetailsController.picodeNumberCount.value =
                      value.length;
                  if (value.length == 6) {
                    _dairyCenterDetailsController.verifyPincode();
                  } else {
                    _dairyCenterDetailsController.isVerifiedPincode.value =
                        false;
                  }
                },
                decoration: InputDecoration(
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
                    borderSide: BorderSide(
                      width: 0.8,
                      color: AppColors.lightBorder,
                    ),
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
                      text:
                          '${_dairyCenterDetailsController.picodeNumberCount.value}/6',
                      fontSize: 12.sp,
                      textColor: AppColors.textExtraLight,
                    ),
                  ),
                ),
              ),

              Obx(
                () => Visibility(
                  visible:
                      _dairyCenterDetailsController.isVerifiedPincode.value,
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
          Gap.verticalGap(10),
          _buildDropdownField(
            hint: 'select_state',
            items: AppState.indianStates,
            selectedValue: _dairyCenterDetailsController.selectedState,
            type: 'state',
          ),

          Obx(
            () => Visibility(
              visible: _dairyCenterDetailsController.selectedState.isNotEmpty,
              child: Column(
                children: [
                  Gap.verticalGap(10),
                  _buildDropdownField(
                    hint: 'select_district',
                    items:
                        _dairyCenterDetailsController
                            .selectedState['districs'] ??
                        <Map<String, dynamic>>[],
                    selectedValue:
                        _dairyCenterDetailsController.selectedDisctrict,
                    type: 'district',
                  ),
                ],
              ),
            ),
          ),
          Gap.verticalGap(10),
          _buildDropdownFieldForDairySetting(
            hint: 'select_collection_type',
            items: _dairyCenterDetailsController.collectionTypes,

            id: 1,
          ),
          Gap.verticalGap(10),
          _buildDropdownFieldForDairySetting(
            hint: 'select_payment_period',
            items: _dairyCenterDetailsController.paymentPeriods,

            id: 4,
          ),

          Gap.verticalGap(25),
          InkWell(
            onTap: () => _dairyCenterDetailsController.addDairyDetails(),
            child: AppButton(
              title: 'next',
              buttonFontWeight: FontWeight.w600,
              isLoading: false.obs,
              shadowOpacity: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  _buildDropdownFieldForDairySetting({
    required String hint,
    required List<DairySettingDataModel> items,

    required int id,
  }) {
    return GetBuilder<DairyCenterDetailsController>(
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

                _dairyCenterDetailsController.selectValues(id, value);
              },
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
            ),
          ),
        );
      },
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
                  text:
                      _dairyCenterDetailsController.languageCode == 'en' ||
                          _dairyCenterDetailsController.languageCode == ''
                      ? e['name_en']
                      : e['name_hi'],
                  textColor: AppColors.blackColor,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              selectedValue.value = value;

              if (type == 'state') {
                _dairyCenterDetailsController.selectedDisctrict.value =
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

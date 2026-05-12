import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/common_container.dart';
import '../../../../common/common_widget/message_box.dart';
import '../../../../common/common_widget/text_widget.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../core/utils/app_regex.dart';
import '../controllers/add_khata_customer_controller.dart';

class AddKhataCustomer extends GetView<AddKhataCustomerController>
    with CommonMixin {
  AddKhataCustomer({super.key});

  final AddKhataCustomerController _addKhataCustomerController =
      Get.find<AddKhataCustomerController>();

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
                title: AppState.iskhataCustomerEdit
                    ? 'update_khata_customer'
                    : 'add_khata_customer',
                dairyName: AppState.dairyName.capitalize!,
              ),
              Gap.verticalGap(6),
              Divider(thickness: 0.2),

              _buildAddKhataCustomerForm(context),
            ],
          ),
        ),
      ),
    );
  }

  _buildAddKhataCustomerForm(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              Obx(
                () => MessageBox(
                  message: _addKhataCustomerController.validationErrorMessage,
                  isVisible: _addKhataCustomerController.hasFieldError.value,
                  isError: true,
                ),
              ),

              Gap.verticalGap(7),
              _buildTextFormFeild(
                _addKhataCustomerController.khataCustomerName,
                'enter_customer_name',
                1,
                TextInputType.text,
                false,
              ),

              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addKhataCustomerController.khataCustomerPhone,
                'enter_mobile_number',
                2,
                TextInputType.number,
                false,
              ),

              Gap.verticalGap(15),
              InkWell(
                onTap: () =>
                    _addKhataCustomerController.getContactNameORNumber(),
                child: Container(
                  height: 30.h,
                  width: 1.sw,
                  color: AppColors.whiteColor,
                  child: Row(
                    children: [
                      AppIcons.userAdd(color: AppColors.themeColor, size: 18),
                      Gap.horizentalGap(6),
                      TextWidget(
                        text: 'select_from_contacts',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,

                        textColor: AppColors.themeColor,
                      ),
                    ],
                  ),
                ),
              ),
              Gap.verticalGap(25),
              InkWell(
                onTap: () {
                  if (AppState.iskhataCustomerEdit) {
                    _addKhataCustomerController.updateKhataCustomer();
                  } else {
                    _addKhataCustomerController.addKhataCustomer();
                  }
                },

                child: AppButton(
                  title: AppState.iskhataCustomerEdit ? 'Update' : 'add',
                  buttonFontWeight: FontWeight.w600,
                  isLoading: _addKhataCustomerController.proccessing,
                  shadowOpacity: 0.3,
                ),
              ),
              Gap.verticalGap(25),
              _buildInstructionBox(),
              Gap.verticalGap(15),

              Gap.verticalGap(20),

              Visibility(
                visible: AppState.iskhataCustomerEdit,
                child: InkWell(
                  onTap: () => _addKhataCustomerController.showDeleteCustomerOption(
                    context,
                    'delete_customer_msg'.trParams({
                      'name':
                          '${AppState.currentKhataBookCustomerForUpdate.name}?',
                    }),
                  ),

                  child: AppButton(
                    title: 'remove',
                    buttonColor: AppColors.whiteColor.withValues(alpha: 0.8),
                    buttonBorderColor: AppColors.redColor.withValues(
                      alpha: 0.8,
                    ),
                    buttonFontWeight: FontWeight.w600,
                    buttonTextColor: AppColors.redColor.withValues(alpha: 0.8),
                    isLoading: _addKhataCustomerController.isDeleting,
                    shadowOpacity: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildInstructionBox() {
    return CommonContainer(
      width: 1.sw,

      shadowOpacity: 0.1,
      containerColor: AppColors.themeColor.withValues(alpha: 0.1),
      bordercolor: AppColors.themeColor.withValues(alpha: 0.8),
      borderWidth: 0.2,
      child: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: AppColors.themeColor.withValues(alpha: 0.17),
              ),
              child: Center(
                child: AppIcons.khata(
                  size: 23,
                  color: AppColors.themeColor.withValues(alpha: 0.8),
                ),
              ),
            ),
            Gap.horizentalGap(10),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    text: 'dairy_sathi_khata',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    textColor: AppColors.themeColor,
                  ),
                  Gap.verticalGap(3),
                  TextWidget(
                    text: 'transaction_record_msg',
                    fontWeight: FontWeight.w500,
                    fontSize: 11.sp,
                    textColor: AppColors.themeColor,
                  ),
                  Gap.verticalGap(10),
                ],
              ),
            ),
          ],
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
        if (id == 2) FilteringTextInputFormatter.allow(AppRegex.onlyNumber),

        LengthLimitingTextInputFormatter(id == 2 ? 10 : 25),
      ],
      decoration: InputDecoration(
        fillColor: AppColors.grey100,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10.5.h, horizontal: 7.w),
        focusedBorder: OutlineInputBorder(
          gapPadding: 5.w,
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 0.8, color: AppColors.grey100),
        ),
        enabledBorder: OutlineInputBorder(
          gapPadding: 5.w,
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 0.8, color: AppColors.grey100),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 0.8, color: AppColors.grey100),
        ),

        hint: TextWidget(
          text: hint,
          fontSize: 12.sp,
          textColor: AppColors.textLight,
        ),
      ),
    );
  }
}

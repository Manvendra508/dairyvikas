import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/app_regex.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/food/presentation/controllers/add_food_dealer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/message_box.dart';

class AddFoodDealerPage extends GetView<AddFoodDealerController>
    with CommonMixin {
  AddFoodDealerPage({super.key});

  final AddFoodDealerController _addFoodDealerController =
      Get.find<AddFoodDealerController>();

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

              DairySathiAppBar(
                title: AppState.isDealerEdit ? 'update_dealer' : 'add_dealer',
                dairyName: AppState.dairyName.capitalize!,
              ),
              Gap.verticalGap(6),

              Divider(thickness: 0.2),
              Gap.verticalGap(6),
              _buildFoodAddDealerForm(context),
            ],
          ),
        ),
      ),
    );
  }

  _buildFoodAddDealerForm(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              Obx(
                () => MessageBox(
                  message: _addFoodDealerController.validationErrorMessage,
                  isVisible: _addFoodDealerController.hasFieldError.value,
                  isError: true,
                ),
              ),
              _buildTextFormFeild(
                _addFoodDealerController.dealerCode,
                'enter_dealer_code',
                1,
                TextInputType.number,
                AppState.isDealerEdit ? true : false,
              ),
              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addFoodDealerController.dealerFullName,
                'enter_dealer_name',
                2,
                TextInputType.text,
                false,
              ),

              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addFoodDealerController.dealerMobileNumber,
                'enter_mobile_number',
                3,
                TextInputType.number,
                false,
              ),
              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addFoodDealerController.dealerAddress,
                'enter_dealer_address',
                4,
                TextInputType.text,
                false,
              ),
              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addFoodDealerController.dealerRemark,
                'enter_dealer_remark',
                5,
                TextInputType.text,
                false,
              ),

              Gap.verticalGap(25),
              InkWell(
                onTap: () {
                  if (AppState.isDealerEdit) {
                    _addFoodDealerController.updateDealer();
                  } else {
                    _addFoodDealerController.addNewDealer();
                  }
                },
                child: AppButton(
                  title: AppState.isDealerEdit ? 'update' : 'add',
                  buttonFontWeight: FontWeight.w600,
                  isLoading: _addFoodDealerController.proccessing,
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
  ) {
    return TextFormField(
      keyboardType: inputType,
      controller: controller,
      cursorColor: AppColors.grey500,
      cursorHeight: 20,

      readOnly: readOnly ?? false,
      inputFormatters: [
        if (id == 1 || id == 3)
          FilteringTextInputFormatter.allow(AppRegex.onlyNumber),

        LengthLimitingTextInputFormatter(id == 3 ? 10 : 50),
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

        suffix: id == 3 && !AppState.isDealerEdit
            ? InkWell(
                onTap: () => _addFoodDealerController.getContactNameORNumber(),
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

  // _buildDropdownField({
  //   required String hint,
  //   required List<Map<String, dynamic>> items,
  //   required RxMap<String, dynamic> selectedValue,
  // }) {
  //   return Obx(
  //     () => Container(
  //       padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 7.w),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(12.r),
  //         border: Border.all(width: 0.8, color: AppColors.lightBorder),
  //       ),
  //       child: DropdownButtonHideUnderline(
  //         child: DropdownButton<Map<String, dynamic>>(
  //           value: selectedValue.value.isEmpty ? null : selectedValue.value,
  //           isExpanded: true,
  //           hint: TextWidget(
  //             text: hint,
  //             fontSize: 12.sp,
  //             textColor: AppColors.textLight,
  //           ),
  //           items: items.map((e) {
  //             return DropdownMenuItem(
  //               value: e,
  //               child: TextWidget(
  //                 text: e['value'],
  //                 textColor: AppColors.blackColor,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             );
  //           }).toList(),
  //           onChanged: (value) {
  //             if (value == null) return;
  //             selectedValue.value = value;
  //           },
  //           icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

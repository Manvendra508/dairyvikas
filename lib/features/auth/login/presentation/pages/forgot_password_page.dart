import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/message_box.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/auth/login/presentation/controllers/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends GetView<ForgotPasswordController> {
  ForgotPasswordPage({super.key});

  final ForgotPasswordController _forgotPasswordController =
      Get.find<ForgotPasswordController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        body: SingleChildScrollView(
          child: Container(
            width: 1.sw,
            height: 1.sh,
            decoration: BoxDecoration(color: AppColors.whiteColor),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Gap.verticalGap(12),
                  DairySathiAppBar(title: 'forgot_password'),
                  Gap.verticalGap(15),
                  _buildForgotPasswordForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildForgotPasswordForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        spacing: 7.h,
        children: [
          Obx(
            () => MessageBox(
              message: _forgotPasswordController.validationErrorMessage,
              isVisible: _forgotPasswordController.hasFieldError.value,
              isError: true,
            ),
          ),

          TextFormField(
            keyboardType: TextInputType.number,
            controller: _forgotPasswordController.phoneController,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              _forgotPasswordController.numberCount.value = value.length;
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
                text: 'enter_registred_mobile_number',
                fontSize: 12.sp,
                textColor: AppColors.textLight,
              ),
              suffix: Obx(
                () => TextWidget(
                  text: '${_forgotPasswordController.numberCount.value}/10',
                  fontSize: 12.sp,
                  textColor: AppColors.textExtraLight,
                ),
              ),
            ),
          ),

          Obx(
            () => Visibility(
              visible: _forgotPasswordController.showOtpFeildField.value,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _forgotPasswordController.otpController,
                cursorColor: AppColors.grey500,
                cursorHeight: 20,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.digitsOnly,
                ],

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
                    text: 'enter_otp_number',
                    fontSize: 12.sp,
                    textColor: AppColors.textLight,
                  ),
                ),
              ),
            ),
          ),

          Obx(
            () => Visibility(
              visible: _forgotPasswordController.showPasswordField.value,
              child: TextFormField(
                obscureText: !_forgotPasswordController.showPassword.value,
                keyboardType: TextInputType.text,
                controller: _forgotPasswordController.newPasswordController,
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
                    text: 'enter_new_password',
                    fontSize: 12.sp,
                    textColor: AppColors.textLight,
                  ),
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 40,
                    maxHeight: 40,
                    minHeight: 25,
                  ),
                  suffixIcon: _forgotPasswordController.showPassword.value
                      ? InkWell(
                          onTap: () =>
                              _forgotPasswordController.showHidePassword(),
                          child: AppIcons.visible(color: AppColors.grey500),
                        )
                      : InkWell(
                          onTap: () =>
                              _forgotPasswordController.showHidePassword(),
                          child: AppIcons.visiblityHide(
                            color: AppColors.grey500,
                          ),
                        ),
                ),
              ),
            ),
          ),

          Gap.verticalGap(5),
          Obx(
            () => InkWell(
              onTap: () => _forgotPasswordController.handleButtonCalls(),
              child: AppButton(
                title: _forgotPasswordController.buttonText.value,
                buttonFontWeight: FontWeight.w600,
                isLoading: _forgotPasswordController.proccessing,
                shadowOpacity: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

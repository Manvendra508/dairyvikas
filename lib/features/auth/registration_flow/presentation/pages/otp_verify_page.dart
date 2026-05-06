import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/app_version_text.dart';
import 'package:dairysathi/common/common_widget/message_box.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/auth/registration_flow/presentation/controllers/otp_verify_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpVerifyPage extends GetView<OtpVerifyController> {
  final String phoneNumber;
  final String message;
  OtpVerifyPage({super.key, required this.phoneNumber, required this.message});

  final OtpVerifyController _otpVerifyController =
      Get.find<OtpVerifyController>();

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
              DairySathiAppBar(title: 'verify_otp'),
              Gap.verticalGap(12.h),
              _buildOtpForm(phoneNumber),
              Gap.verticalGap(0.36.sh),
              AppVersionText(),
              Gap.verticalGap(20),
            ],
          ),
        ),
      ),
    );
  }

  _buildOtpForm(String phoneNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        //  crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Obx(
                () => Visibility(
                  visible: _otpVerifyController.isMessageBoxVisible.value,
                  child: MessageBox(
                    message: message,
                    isVisible: true,
                    isError: false,
                  ),
                ),
              ),

              Gap.verticalGap(5),
            ],
          ),
          Gap.verticalGap(10.h),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextWidget(
                    text: '+91-$phoneNumber - ',
                    fontSize: 14.sp,
                    textColor: AppColors.blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                  InkWell(
                    onTap: () => AppNavigation.goBack(),
                    child: TextWidget(
                      text: 'edit',
                      fontSize: 15.sp,
                      textColor: AppColors.themeColor,
                      fontWeight: FontWeight.w500,
                      textDecoration: TextDecoration.underline,
                      decorationColor: AppColors.themeColor,
                    ),
                  ),
                ],
              ),
              Gap.verticalGap(7),
              _buildOtpField(),
            ],
          ),

          Gap.verticalGap(50),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _otpVerifyController.startTimerForOtpResend(phoneNumber);
                  },
                  child: TextWidget(
                    text: 'resend_otp',
                    fontSize: 14.sp,
                    textColor: _otpVerifyController.isTimeron.value
                        ? AppColors.textSecondary
                        : AppColors.themeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Visibility(
                  visible: _otpVerifyController.isTimeron.value,
                  child: TextWidget(
                    text: ': 00:${_otpVerifyController.secondsRemaining} sec',
                    fontSize: 15.sp,
                    textColor: AppColors.blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Gap.verticalGap(20),
          InkWell(
            onTap: () => _otpVerifyController.verifyOtp(phoneNumber),
            child: Obx(
              () => AppButton(
                title: 'verify',
                buttonFontWeight: FontWeight.w600,
                isLoading: _otpVerifyController.isVerifying,
                shadowOpacity: 0.3,
                buttonBorderColor: _otpVerifyController.isButtonDisable.value
                    ? AppColors.grey300
                    : AppColors.themeColor,
                buttonColor: _otpVerifyController.isButtonDisable.value
                    ? AppColors.grey300
                    : AppColors.themeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildOtpField() {
    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 45.h,

      textStyle: TextStyle(
        fontSize: 20,
        color: AppColors.blackColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.darkBorder),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.grey300.withOpacity(0.1),
      ),
    );

    return Pinput(
      length: 6,
      controller: _otpVerifyController.otpController,
      focusNode: _otpVerifyController.pinFocusNode,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      onChanged: (value) {
        if (value.length == 6) {
          _otpVerifyController.isButtonDisable.value = false;
        } else {
          _otpVerifyController.isButtonDisable.value = true;
        }
      },

      showCursor: true,
      onCompleted: (pin) {},
    );
  }
}

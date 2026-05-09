import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/app_version_text.dart'
    show AppVersionText;
import 'package:DairyVikas/common/common_widget/language_selector.dart';
import 'package:DairyVikas/common/common_widget/message_box.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/app_regex.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({super.key});

  final LoginController _loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.themeColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 15.w, top: 20.h),
                  child: InkWell(
                    onTap: () => _loginController.showLanguageSheet(
                      context,
                      LanguagePage(),
                    ),
                    child: Container(
                      width: 80.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.7,
                          color: AppColors.whiteColor,
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: 'English',
                            textColor: AppColors.whiteColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          Gap.horizentalGap(4),
                          AppIcons.arrowDown(color: AppColors.whiteColor),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Gap.verticalGap(73),

              Container(
                width: 1.sw,
                height: 0.80.sh,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Gap.verticalGap(15),
                      TextWidget(
                        text: 'login',
                        fontWeight: FontWeight.w600,
                        fontSize: 23.sp,
                      ),
                      Gap.verticalGap(25),
                      _buildLoginInForm(),
                      Gap.verticalGap(0.14.sh),
                      AppVersionText(),
                      Gap.verticalGap(20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildLoginInForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        //  crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => MessageBox(
              message: _loginController.validationErrorMessage,
              isVisible: _loginController.hasFieldError.value,
              isError: true,
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: _loginController.phoneController,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.allow(AppRegex.onlyNumber),
            ],
            onChanged: (value) {
              _loginController.numberCount.value = value.length;
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
                text: 'enter_mobile_number',
                fontSize: 12.sp,
                textColor: AppColors.textLight,
              ),
              suffix: Obx(
                () => TextWidget(
                  text: '${_loginController.numberCount.value}/10',
                  fontSize: 12.sp,
                  textColor: AppColors.textExtraLight,
                ),
              ),
            ),
          ),

          Gap.verticalGap(10.h),

          Obx(
            () => Column(
              children: [
                TextFormField(
                  obscureText: !_loginController.showPassword.value,
                  keyboardType: TextInputType.text,
                  controller: _loginController.passwordController,
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
                      text: 'enter_password',
                      fontSize: 12.sp,
                      textColor: AppColors.textLight,
                    ),
                    suffixIconConstraints: BoxConstraints(
                      minWidth: 40,
                      maxHeight: 40,
                      minHeight: 25,
                    ),
                    suffixIcon: _loginController.showPassword.value
                        ? InkWell(
                            onTap: () => _loginController.showHidePassword(),
                            child: AppIcons.visible(color: AppColors.grey500),
                          )
                        : InkWell(
                            onTap: () => _loginController.showHidePassword(),
                            child: AppIcons.visiblityHide(
                              color: AppColors.grey500,
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h, right: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => AppNavigation.goToForgotPasswordPage(),
                        child: TextWidget(
                          text: 'forgot_password',
                          textDecoration: TextDecoration.underline,
                          decorationColor: AppColors.themeColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.themeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Gap.verticalGap(35),
          InkWell(
            onTap: () => _loginController.loginVendor(),
            child: AppButton(
              title: 'login',
              buttonFontWeight: FontWeight.w600,
              isLoading: _loginController.isLogging,
              shadowOpacity: 0.3,
            ),
          ),
          Gap.verticalGap(30),
          TextWidget(
            text: 'not_registered_yet',
            fontWeight: FontWeight.w600,
            textColor: AppColors.grey600,
            fontSize: 11.sp,
          ),
          Gap.verticalGap(17),
          InkWell(
            onTap: () => AppNavigation.goToPersonalDetailsPage(),
            child: AppButton(
              title: 'register_now',
              shadowOpacity: 0.6,
              buttonColor: AppColors.whiteColor,
              buttonFontWeight: FontWeight.w700,
              buttonTextColor: AppColors.themeColor,
              isLoading: false.obs,
            ),
          ),
        ],
      ),
    );
  }
}

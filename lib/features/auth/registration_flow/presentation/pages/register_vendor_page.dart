import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/app_version_text.dart';
import 'package:DairyVikas/common/common_widget/message_box.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/register_vendor_controller.dart';

class RegisterVendorPage extends GetView<RegisterVendorController> {
  RegisterVendorPage({super.key});

  final RegisterVendorController _personalDetailsController =
      Get.find<RegisterVendorController>();

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
              DairyVikasAppBar(title: 'personal_detail'),
              Gap.verticalGap(12.h),

              _buildPeronalDetailsForm(),
              Gap.verticalGap(0.34.sh),
              AppVersionText(),
              Gap.verticalGap(20),
            ],
          ),
        ),
      ),
    );
  }

  _buildPeronalDetailsForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        //  crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => MessageBox(
              message: _personalDetailsController.validationErrorMessage,
              isVisible: _personalDetailsController.hasFieldError.value,
              isError: true,
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _personalDetailsController.nameController,
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
                text: 'enter_fullname',
                fontSize: 12.sp,
                textColor: AppColors.textLight,
              ),
            ),
          ),
          Gap.verticalGap(10.h),

          TextFormField(
            keyboardType: TextInputType.number,
            controller: _personalDetailsController.phoneController,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            inputFormatters: [LengthLimitingTextInputFormatter(10)],
            onChanged: (value) {
              _personalDetailsController.numberCount.value = value.length;
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
                  text: '${_personalDetailsController.numberCount.value}/10',
                  fontSize: 12.sp,
                  textColor: AppColors.textExtraLight,
                ),
              ),
            ),
          ),

          Gap.verticalGap(10.h),

          Obx(
            () => TextFormField(
              obscureText: !_personalDetailsController.showPassword.value,
              keyboardType: TextInputType.text,
              controller: _personalDetailsController.passwordController,
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
                suffixIcon: _personalDetailsController.showPassword.value
                    ? InkWell(
                        onTap: () =>
                            _personalDetailsController.showHidePassword(),
                        child: AppIcons.visible(color: AppColors.grey500),
                      )
                    : InkWell(
                        onTap: () =>
                            _personalDetailsController.showHidePassword(),
                        child: AppIcons.visiblityHide(color: AppColors.grey500),
                      ),
              ),
            ),
          ),

          Gap.verticalGap(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Obx(
                  () => Checkbox(
                    activeColor: AppColors.themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),

                    value: _personalDetailsController.isTermsAccepted.value,
                    onChanged: (value) {
                      if (value == null ||
                          _personalDetailsController.isRegistring.value) {
                        return;
                      }

                      _personalDetailsController.isTermsAccepted.value = value;
                    },
                  ),
                ),
              ),
              Gap.horizentalGap(2),

              Flexible(
                child: InkWell(
                  onTap: () => launchUrl(
                    Uri.parse('https://krishidhyan.com/terms-conditions.html'),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey500,
                      ),
                      children: [
                        TextSpan(
                          text: 'i_have_agree'.tr,
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: 'terms_and_conditions'.tr,
                          style: GoogleFonts.montserrat(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.themeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Gap.verticalGap(25),
          InkWell(
            onTap: () => _personalDetailsController.registerNewVendor(),
            child: AppButton(
              title: 'next',
              buttonFontWeight: FontWeight.w600,
              isLoading: _personalDetailsController.isRegistring,
              shadowOpacity: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

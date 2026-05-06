import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/core/local_datasources/local_storage_service.dart';
import 'package:dairysathi/core/utils/app_anum.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/rate_cart/presentation/pages/rate_chart_common_widgets/bonus_penality_radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'text_widget.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  changeLanguage(BuildContext context, LanguageType type) async {
    final router = GoRouter.of(context);
    if (type == LanguageType.english) {
      Get.updateLocale(const Locale('en', 'US'));
      await SharedPrefsService.instance.saveLanguage('en', 'US');
    } else if (type == LanguageType.hindi) {
      Get.updateLocale(const Locale('hi', 'IN'));
      await SharedPrefsService.instance.saveLanguage('hi', 'IN');
    }
    for (var lang in languages) {
      lang['isSelected'].value = false;
    }

    languages.firstWhere((lang) => lang['type'] == type)['isSelected'].value =
        true;
    router.pop();
  }

  RxList languages = [
    {
      "language": "English",
      "isSelected": false.obs,
      "type": LanguageType.english,
    },
    {
      "language": "Hindi (हिन्दी)",
      "isSelected": false.obs,
      "type": LanguageType.hindi,
    },
  ].obs;

  checkSelectedLanguage() {
    String languageCode = 'en';
    Locale? locale = SharedPrefsService.instance.getSavedLocale();
    if (locale != null) {
      languageCode = locale.languageCode;
    }
    if (languageCode == 'en') {
      languages[0]['isSelected'].value = true;
    } else if (languageCode == 'hi') {
      languages[1]['isSelected'].value = true;
    }
  }

  @override
  void initState() {
    checkSelectedLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 9.h),
      child: Column(
        children: [
          Gap.verticalGap(6),
          TextWidget(
            text: 'choose_lang',
            fontSize: 18.5.sp,
            textColor: AppColors.blackColor,
            fontWeight: FontWeight.w600,
          ),
          Gap.verticalGap(6),
          TextWidget(
            text: 'choose_lang_msg',
            fontSize: 11.sp,
            textColor: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          Gap.verticalGap(7),
          Divider(color: AppColors.border, thickness: 0.4),
          Gap.verticalGap(7),
          Column(
            children: List.generate(
              languages.length,
              (index) => _buildLanguageOption(
                size,
                languages[index]['isSelected'],
                languages[index]['language']
                    .toString()
                    .substring(0, 1)
                    .toUpperCase(),
                languages[index]['language'],
                context,
                languages[index]['type'],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildLanguageOption(
    Size size,
    RxBool isSelected,
    String iconLetter,
    String language,
    BuildContext context,
    LanguageType langageType,
  ) {
    return Obx(
      () => InkWell(
        onTap: () => changeLanguage(context, langageType),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
          width: 1.sw,
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 0.6,
              color: isSelected.value
                  ? AppColors.themeColor
                  : AppColors.darkBorder,
            ),
            color: isSelected.value
                ? AppColors.themeColor.withOpacity(0.1)
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 25.w,
                      height: 25.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.grey100,
                      ),
                      child: Center(
                        child: TextWidget(
                          text: iconLetter,
                          textColor: AppColors.textLight,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Gap.horizentalGap(10),
                    TextWidget(
                      text: language,
                      textColor: AppColors.textSecondary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),

                BonusPenalityRadioButton(isActive: isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

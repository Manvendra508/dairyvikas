import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/assets_paths.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/profile_and_settings/presentation/controllers/refer_and_earn_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ReferAndEarnPage extends GetView<ReferAndEarnController>
    with CommonMixin {
  ReferAndEarnPage({super.key});

  final ReferAndEarnController _referAndEarnController =
      Get.find<ReferAndEarnController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.grey100,

        body: Column(
          children: [
            Gap.verticalGap(10),

            DairyVikasAppBar(title: 'refer_and_earn'),
            Gap.verticalGap(6),
            Divider(thickness: 0.2),

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Lottie.asset(AssetsPaths.referAndEarn, height: 110.h),
                    Gap.verticalGap(20),
                    TextWidget(
                      text: 'friends_bring_rewards',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    Gap.verticalGap(6),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: TextWidget(
                        text: 'refer_description'.trParams({
                          "credits": '200',
                          "credits2": '100',
                        }), // this have to dynamic when got from api
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.grey400,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Gap.verticalGap(10),
                    Container(
                      width: 130.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: AppColors.blackColor,
                      ),
                      child: Center(
                        child: TextWidget(
                          text: 'credits'.trParams({
                            'credits': '200',
                          }), // this have to dynamic when got from api
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    Gap.verticalGap(20),
                    _buildReferCodeContainer(),
                    Gap.verticalGap(17),

                    // _buildWhatsAppShareButton(),
                    // Gap.verticalGap(10),
                    // _buildWhatsShareButton(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWhatsAppShareButton(),
                        _buildShareLinkButton(),
                      ],
                    ),
                    Gap.verticalGap(20),
                    Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextWidget(
                              text: 'how_it_works',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              textColor: AppColors.grey900,
                            ),
                          ),
                          Gap.verticalGap(10),
                          CommonContainer(
                            shadowOpacity: 0.5,
                            margin: EdgeInsets.only(right: 14.w, bottom: 10.h),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 12.h,
                              ),
                              child: Column(
                                spacing: 6.h,
                                children: [
                                  _buildHowItWorksItem(
                                    'invite_friends',
                                    'invite_friends_desc',
                                    1,
                                  ),
                                  Divider(
                                    thickness: 0.2,
                                    color: AppColors.grey300,
                                  ),
                                  _buildHowItWorksItem(
                                    'they_register',
                                    'they_register_desc',
                                    2,
                                  ),
                                  Divider(
                                    thickness: 0.2,
                                    color: AppColors.grey300,
                                  ),
                                  _buildHowItWorksItem(
                                    'you_get_credits'.trParams(
                                      {'credits': '200'},
                                    ), // this have to dynamic when got from api
                                    'you_get_credits_desc'.trParams({
                                      'credits':
                                          '200', // this have to dynamic when got from api
                                    }),
                                    3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildHowItWorksItem(String title, String description, int index) {
    return Row(
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.themeColor,
          ),
          child: Center(
            child: TextWidget(
              text: index.toString(),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              textColor: AppColors.whiteColor,
            ),
          ),
        ),
        Gap.horizentalGap(13),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: title,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              textColor: AppColors.blackColor,
            ),
            Gap.verticalGap(3),
            SizedBox(
              width: 265.w,
              child: TextWidget(
                text: description,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                textColor: AppColors.grey600,
                maxline: 3,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildReferCodeContainer() {
    return CommonContainer(
      margin: EdgeInsets.symmetric(horizontal: 13.w),
      width: 1.sw,
      height: 90.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget(
            text: 'your_referral_code',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            textColor: AppColors.grey500,
          ),
          Gap.verticalGap(15),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25.w),
            height: 34.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: AppColors.grey200,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextWidget(
                  text: 'DAIRY1234',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.themeColor,
                ),
                InkWell(
                  onTap: () => copyText('DAIRY1234'),
                  child: Row(
                    children: [
                      AppIcons.copy(color: AppColors.themeColor),
                      Gap.horizentalGap(7),
                      TextWidget(
                        text: 'copy',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.themeColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildWhatsAppShareButton() {
    return InkWell(
      onTap: () => openWhatsApp(
        phone: '7339738459', // this have to dynamic when got from api
        message:
            'Join DairyVikas using my referral code DAIRY1234 and get rewards!', // this have to dynamic when got from api
      ),
      child: CommonContainer(
        shadowOpacity: 0.5,
        containerColor: AppColors.darkgreenColor,
        width: 1.sw / 2,
        height: 40.h,
        margin: EdgeInsets.only(left: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.whatsapp(color: AppColors.whiteColor),
            Gap.horizentalGap(7),
            TextWidget(
              text: 'whatsapp_share',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              textColor: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }

  _buildShareLinkButton() {
    return InkWell(
      onTap: () => shareLink(_referAndEarnController.isSharing),
      child: CommonContainer(
        shadowOpacity: 0.5,
        containerColor: AppColors.grey300,
        width: 1.sw / 2.5,
        height: 40.h,
        margin: EdgeInsets.only(right: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.share(color: AppColors.grey800, size: 13.h),
            Gap.horizentalGap(7),
            TextWidget(
              text: 'share_link',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              textColor: AppColors.grey800,
            ),
          ],
        ),
      ),
    );
  }
}

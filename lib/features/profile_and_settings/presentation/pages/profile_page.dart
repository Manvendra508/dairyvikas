import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/app_loader.dart';
import 'package:dairysathi/common/common_widget/app_version_text.dart';
import 'package:dairysathi/common/common_widget/retry_widget.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> with CommonMixin {
  ProfilePage({super.key});

  final ProfileController _profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.whiteColor,

        body: Obx(
          () => Visibility(
            visible: !_profileController.isLoading.value,
            replacement: DairySathiLoader(),
            child: Visibility(
              visible: !_profileController.hasError.value,
              replacement: RetryWidget(
                onRetry: () => _profileController.firstMethod(),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.verticalGap(10),

                  DairySathiAppBar(title: 'profile'),
                  Gap.verticalGap(6),
                  Divider(thickness: 0.2),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _buildProfilePhotoSection(context),
                          Gap.verticalGap(20),
                          _buildCurrentPlanWidget(),
                          Column(
                            children: List.generate(
                              _profileController.profileData.length,
                              (index) {
                                final item =
                                    _profileController.profileData[index];
                                return Visibility(
                                  visible: item['show'],
                                  child: InkWell(
                                    onTap: () => _profileController.doTask(
                                      item['id'],
                                      context,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 0.5,
                                            color: AppColors.grey200,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 20.w,
                                          top: 10.h,
                                          bottom: 10.h,
                                          right: 20.w,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      item['icon'],
                                                      width: 20.w,
                                                      height: 20.h,
                                                      color: item['color'],
                                                    ),
                                                    Gap.horizentalGap(15),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TextWidget(
                                                          text: item['title'],
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          textColor:
                                                              item['color'],
                                                        ),
                                                        Gap.verticalGap(2),
                                                        TextWidget(
                                                          text: item['dec'],
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          textColor:
                                                              AppColors.grey500,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                                item['showArrow']
                                                    ? AppIcons.arrowForward(
                                                        size: 10.sp,
                                                        color:
                                                            AppColors.grey600,
                                                      )
                                                    : TextWidget(
                                                        text: '₹200',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16.sp,
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          Gap.verticalGap(12),
                          _buildAccountDeleteButton(context),

                          Gap.verticalGap(7),
                          AppVersionText(),
                          Gap.verticalGap(6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildAccountDeleteButton(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (_profileController.isDeleteProcessed.value) return;
            _profileController.showLogoutSheet(
              context,
              'delete_account_warning',
              false,
              true,
            );
          },
          child: Obx(
            () => AppButton(
              buttonWidth: 0.9.sw,
              buttonHeight: 33.h,
              margin: EdgeInsets.symmetric(horizontal: 7),
              title: _profileController.isDeleteProcessed.value
                  ? "request_sent"
                  : 'delete_account',
              buttonTextColor: _profileController.isDeleteProcessed.value
                  ? AppColors.whiteColor
                  : AppColors.grey800,
              buttonFontWeight: FontWeight.w600,
              isLoading: _profileController.isDeleting,
              shadowOpacity: 0.4,
              buttonColor: _profileController.isDeleteProcessed.value
                  ? AppColors.grey400
                  : AppColors.whiteColor.withOpacity(0.8),
              buttonBorderColor: _profileController.isDeleteProcessed.value
                  ? AppColors.grey400
                  : AppColors.grey800.withOpacity(0.8),
            ),
          ),
        ),
        Gap.verticalGap(3),
        Obx(
          () => _profileController.isDeleteProcessed.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'account_delete_msg',
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.grey600,
                      fontSize: 9.sp,
                    ),
                    InkWell(
                      onTap: () => _profileController.showLogoutSheet(
                        context,
                        'account_withdraw_msg',
                        false,
                        false,
                      ),
                      child: TextWidget(
                        text: 'withdraw',
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.blue,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ),
      ],
    );
  }

  _buildProfilePhotoSection(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            InkWell(
              // onTap: () => _profileController.showBottomStoryOrPhotoBottomsheet(
              //   context,
              //   _buildChooseStoryPhotowidget(context),
              // ),
              child: Obx(
                () => CircularPercentIndicator(
                  animation: false,
                  radius: 47.5,
                  lineWidth: 3.2,
                  percent: _profileController.progress.value.clamp(0.0, 1.0),
                  center: Container(
                    width: 80.w,
                    height: 72.h,
                    decoration: BoxDecoration(shape: BoxShape.circle),

                    child: Center(
                      child: AppIcons.profilePlaceHolder(size: 77.sp),
                    ),
                  ),
                  progressColor: AppColors.themeColor,
                ),
              ),
            ),

            // Positioned(
            //   right: 0.w,
            //   bottom: 5.h,
            //   child: InkWell(
            //     onTap: () => _profileController
            //         .showBottomStoryOrPhotoBottomsheet(
            //           context,
            //           _buildChooseStoryPhotowidget(context),
            //         ),
            //     child: CommonContainer(
            //       shadowOpacity: 0.5,
            //       width: 25.w,
            //       height: 21.h,
            //       borderRaduis: 30.r,
            //       child: Center(
            //         child: Icon(Icons.add, color: AppColors.themeColor),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),

        Gap.verticalGap(8),
        Column(
          children: [
            Obx(
              () => TextWidget(
                text: AppState.vendorName.value.capitalize.toString(),
                fontSize: AppState.dairyName.capitalize.toString().length > 21
                    ? 15.sp
                    : 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppIcons.location(size: 11),
                Gap.horizentalGap(3),
                TextWidget(
                  text: '${AppState.vendorDistrict}, ${AppState.vendorState}',
                  fontSize: AppState.vendorDistrict.length > 10 ? 11.sp : 12.sp,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.grey700,
                ),
              ],
            ),
            Gap.verticalGap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => _profileController.openChangeNameSheet(
                    context,
                    _buildChangeNameWidget(context),
                  ),
                  child: Container(
                    height: 23.h,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.7, color: AppColors.grey200),
                      borderRadius: BorderRadius.circular(5.r),
                      color: AppColors.grey100,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: 'Edit Name',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            textColor: AppColors.grey700,
                          ),
                          Gap.horizentalGap(10),
                          AppIcons.edit(size: 12.sp, color: AppColors.grey700),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  _buildChangeNameWidget(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      width: 1.sw,
      height: 166.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          children: [
            Gap.verticalGap(5),
            Row(
              children: [
                TextWidget(
                  text: 'Change Name',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            Divider(thickness: 0.2),
            Gap.verticalGap(10),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _profileController.nameController,
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

            Gap.verticalGap(15),
            InkWell(
              onTap: () => _profileController.updateDairyName(),
              child: AppButton(
                title: 'UPDATE',
                isLoading: _profileController.isUpdatingName,
                buttonFontWeight: FontWeight.w600,
                buttonFontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCurrentPlanWidget() {
    return InkWell(
      onTap: () => AppNavigation.goToSubscriptionPlanPage(),
      child: Obx(
        () => Visibility(
          visible: _profileController.showplanBox.value,
          child: Container(
            margin: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 10.h),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: AppColors.grey200),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                top: 10.h,
                bottom: 10.h,
                right: 20.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text:
                                    'Current Plan (${formatDate(_profileController.currentPlan.startDate)} - ${formatDate(_profileController.currentPlan.endDate)})',
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.grey600,
                              ),
                              Gap.verticalGap(2),
                              TextWidget(
                                text:
                                    '${_profileController.currentPlan.meta['months']} Months',
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.grey800,
                              ),
                            ],
                          ),
                        ],
                      ),

                      TextWidget(
                        text: _profileController.currentPlan.status
                            .toUpperCase(),
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                        textColor: AppColors.themeColor,
                      ),
                    ],
                  ),
                  Gap.verticalGap(10),
                  subscriptionProgress(
                    remainingDays: _profileController.currentPlan.remainingDays,
                    totalDays: _profileController.currentPlan.validityDays,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget subscriptionProgress({
    required int totalDays,
    required int remainingDays,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: 'Subscription Remaining',
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        Gap.verticalGap(5),

        Obx(
          () => LinearPercentIndicator(
            padding: EdgeInsets.zero,
            width: 0.82.sw,
            barRadius: Radius.circular(10.r),
            lineHeight: 8.0,
            percent: _profileController.subscriptionProgressLine.value,

            backgroundColor: AppColors.grey200,
            progressColor: _profileController.getProgressColor(
              _profileController.subscriptionProgressLine.value,
            ),
          ),
        ),

        Gap.verticalGap(3),
        TextWidget(
          text: '$remainingDays/$totalDays days left',
          fontWeight: FontWeight.w500,
          fontSize: 10.sp,
          textColor: AppColors.grey600,
        ),
      ],
    );
  }
}

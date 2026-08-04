import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_drawer.dart';
import 'package:DairyVikas/common/common_widget/caurosal_slider.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/network_image.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/network/api_endpoints.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/dashboard/data/model/dashboard_feature_model.dart'
    show DashboardFeatureModel;
import 'package:DairyVikas/features/dashboard/presentation/controllers/dashboard_controller.dart'
    show DashboardController;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/common_widget/app_button.dart';
import '../../../../common/common_widget/retry_widget.dart';
import '../../../../core/utils/app_navigation.dart';

class DashboardPage extends GetView<DashboardController> with CommonMixin {
  DashboardPage({super.key});

  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    DateTime? lastBackPressed;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          _dashboardController.pressAgainToExit(lastBackPressed);
          return true;
        },
        child: Obx(
          () => Scaffold(
            resizeToAvoidBottomInset: true,
            key: _dashboardController.scaffoldKey,
            drawer: DairyVikasAppDrawer(
              district: _dashboardController.vendorDistrict,
              state: _dashboardController.vendorState,
            ),
            drawerEnableOpenDragGesture: false,

            body: Visibility(
              visible: !_dashboardController.isLoading.value,
              replacement: _buildDashboardLoadingSkelaton(),

              child: Visibility(
                visible: !_dashboardController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () => _dashboardController.firstMethod(),
                ),
                child: _buildDashboardBody(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildDashboardLoadingSkelaton() {
    Color baseColor = AppColors.grey200.withValues(alpha: 0.8);
    Color highlightColor = AppColors.whiteColor.withValues(alpha: 0.7);
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.w),
                width: 90.w,
                height: 90.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor,
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 5.w),
                width: 200.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            width: 1.sw,
            height: 70.h,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          _buildSectionSkeloton(baseColor),
          _buildSectionSkeloton(baseColor),
          _buildSectionSkeloton(baseColor),
        ],
      ),
    );
  }

  _buildSectionSkeloton(Color baseColor) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(text: '', fontSize: 17.sp, fontWeight: FontWeight.w600),
          Gap.verticalGap(15),

          // The grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 0.86,
            ),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: baseColor,
                    ),
                  ),
                  Gap.verticalGap(8),
                  Container(
                    width: 100.sw,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  _buildDashboardBody(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.lightthemeColor.withValues(alpha: 0.01),
            AppColors.whiteColor,
          ],
          stops: [0.01, 0.17],

          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopPart(context),
            CommonContainer(
              shadowOpacity: 0.1,
              borderRaduis: 0.r,
              width: 1.sw,

              containerColor: AppColors.grey100.withValues(alpha: 0.8),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'free_trial_msg'.trParams({
                        'days': _dashboardController
                            .dashboardData
                            .value
                            .dashboardDataModel
                            .daysLeftInFreeTrial,
                      }),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    InkWell(
                      // onTap: () => AppNavigation.goToSubscriptionPlanPage(),
                      onTap: () => AppNavigation.goToScanDevicesPage(),
                      // child: CommonContainer(
                      //   width: 120.w,
                      //   height: 30.h,
                      //   borderRaduis: 30.r,
                      //   shadowOpacity: 0.6,
                      //   child: Center(
                      //     child: TextWidget(
                      //       text: 'upgrade_now',
                      //       fontSize: 12.sp,
                      //       textColor: AppColors.themeColor,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      // ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF8C6B1F),
                              Color.fromARGB(255, 152, 126, 41),
                              Color(0xFFFFE082),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.themeColor.withValues(
                                alpha: 0.2,
                              ),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            AppIcons.premium(
                              size: 12.h,
                              color: AppColors.whiteColor,
                            ),
                            SizedBox(width: 4.w),
                            TextWidget(
                              text: 'upgrade_now',
                              fontSize: 12.sp,
                              textColor: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap.verticalGap(10),
            // CommonContainer(
            //   shadowOpacity: 0.3,
            //   margin: EdgeInsets.symmetric(horizontal: 10.w),
            //   width: 1.sw,
            //   height: 125.h,
            //   child: Center(
            //     child: ClipRRect(
            //       borderRadius: BorderRadiusGeometry.circular(10.r),
            //       child: Image.asset(fit: BoxFit.fill, AssetsPaths.dsBanner),
            //     ),
            //   ),
            // ),
            WidgetBannerSlider(),
            Gap.verticalGap(17),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 18.h,
              children: List.generate(
                _dashboardController
                    .dashboardData
                    .value
                    .dashboardDataModel
                    .sections
                    .length,
                (index) => _buildSection(
                  _dashboardController
                      .dashboardData
                      .value
                      .dashboardDataModel
                      .sections[index]
                      .featureCategory,
                  _dashboardController
                      .dashboardData
                      .value
                      .dashboardDataModel
                      .sections[index]
                      .features,
                ),
              ),
            ),
            Gap.verticalGap(17),
          ],
        ),
      ),
    );
  }

  _buildChooseStoryPhotowidget(BuildContext context) {
    return Container(
      color: AppColors.themeColor.withValues(alpha: 0.1),
      width: 1.sw,

      child: Column(
        children: [
          Gap.verticalGap(7),
          TextWidget(
            text: 'select_option',
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          Divider(color: AppColors.grey200),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: _dashboardController.hasThought.value,
                  replacement: Column(
                    children: [
                      Gap.verticalGap(7),
                      _buildStoryPhotoOption("add_text_thought", 0, context),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildStoryPhotoOption(
                        _dashboardController.hasThought.value
                            ? 'view_thought'
                            : "add_photo_thought",
                        1,
                        context,
                      ),
                      Gap.verticalGap(7),
                      _buildStoryPhotoOption('remove_thought', 3, context),
                    ],
                  ),
                ),
                Gap.verticalGap(7),
                _buildStoryPhotoOption(
                  _dashboardController.hasprofilephoto
                      ? 'change_photo'
                      : "add_photo",

                  2,
                  context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildStoryPhotoOption(String title, int id, BuildContext context) {
    return InkWell(
      onTap: () => _dashboardController.addThoughtOrProfilePhoto(id, context),
      child: SizedBox(
        width: 1.sw,
        height: 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: title,
              fontWeight: FontWeight.w500,
              textColor: id == 3 ? AppColors.redColor : AppColors.blackColor,
            ),
            AppIcons.arrowForward(
              size: 12,
              color: id == 3 ? AppColors.redColor : AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }

  _buildSection(String title, List<DashboardFeatureModel> dashboardFeatures) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(text: title, fontSize: 17.sp, fontWeight: FontWeight.w600),
          Gap.verticalGap(15),

          // The grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: dashboardFeatures.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 0.86,
            ),
            itemBuilder: (context, index) {
              if (!dashboardFeatures[index].isActive) {
                return SizedBox.shrink();
              }

              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (AppState.isDairyAdded) {
                        if (_dashboardController
                                .dashboardData
                                .value
                                .dashboardDataModel
                                .daysLeftInFreeTrial ==
                            '0') {
                          _dashboardController.showDialogForExpireFreeTrial(
                            context,
                          );
                        } else {
                          _dashboardController.navigateToScreen(
                            dashboardFeatures[index].id,
                          );
                        }
                      } else {
                        _dashboardController.showDeairyDetailsAddBottomsheet(
                          context,
                          _buildDairyDetailsAddWidget(),
                        );
                        //  AppNavigation.goToDairyCenterDetailsPage(true);
                      }
                    },
                    child: Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.themeColor,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: CacheMyNetworkImage(
                          loaderSize: 13.h,
                          imgUrl:
                              "${ApiEndpoints.baseUrl}${dashboardFeatures[index].icon}",
                        ),
                      ),
                    ),
                  ),
                  Gap.verticalGap(6),
                  TextWidget(
                    textAlign: TextAlign.center,
                    text: dashboardFeatures[index].featureName,
                    fontSize: 11.sp,
                    textColor: AppColors.grey700,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  _buildDairyDetailsAddWidget() {
    return Container(
      width: 1.sw,
      height: 150.h,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'details_missing',
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
                InkWell(
                  onTap: () => AppNavigation.goBack(),
                  child: AppIcons.cross(),
                ),
              ],
            ),
            Gap.verticalGap(4.h),
            Divider(thickness: 0.7, color: AppColors.grey200),
            Gap.verticalGap(4.h),
            TextWidget(
              text: 'dairy_details_missing_msg',
              maxline: 3,
              fontWeight: FontWeight.w500,

              textColor: AppColors.grey600,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => AppNavigation.goBack(),
                  child: AppButton(
                    buttonHeight: 35.h,
                    buttonWidth: 1.sw / 2.3,
                    title: 'cancel',
                    buttonFontWeight: FontWeight.w500,
                    isLoading: false.obs,
                    buttonBorderColor: AppColors.whiteColor.withValues(
                      alpha: 0.8,
                    ),
                    buttonBorderRaduids: 4.r,
                    buttonColor: AppColors.whiteColor,
                    buttonTextColor: AppColors.grey400.withValues(alpha: 0.8),
                  ),
                ),
                InkWell(
                  onTap: () {
                    AppNavigation.goBack();
                    AppNavigation.goToDairyCenterDetailsPage(true);
                  },
                  child: AppButton(
                    buttonHeight: 35.h,
                    buttonWidth: 1.sw / 2.3,
                    title: 'add_details',
                    buttonFontWeight: FontWeight.w500,
                    isLoading: false.obs,
                    buttonBorderColor: AppColors.themeColor,
                    buttonBorderRaduids: 4.r,
                    buttonColor: AppColors.themeColor,
                    buttonTextColor: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildTopPart(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  InkWell(
                    // onTap: () =>
                    //     _dashboardController.showBottomStoryOrPhotoBottomsheet(
                    //       context,
                    //       _buildChooseStoryPhotowidget(context),
                    //     ),
                    child: Obx(
                      () => CircularPercentIndicator(
                        animation: false,
                        radius: 33.5,
                        lineWidth: 3.2,
                        percent: _dashboardController.progress.value.clamp(
                          0.0,
                          1.0,
                        ),
                        center: Container(
                          width: 57.w,
                          height: 47.h,

                          decoration: BoxDecoration(shape: BoxShape.circle),

                          // child: CacheMyNetworkImage(
                          //   fit: BoxFit.cover,

                          //   imgUrl:
                          //       'https://live.staticflickr.com/1567/25644818033_cfcd9f99f5_b.jpg',
                          //   imgRaduis: 100.r,
                          // ),
                          child: Center(
                            child: AppIcons.profilePlaceHolder(size: 57.sp),
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
                  //     onTap: () => _dashboardController
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

              Gap.horizentalGap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(
                    width: 170.w,

                    child: TextWidget(
                      maxline: 1,
                      text: AppState.dairyName.capitalize.toString(),

                      fontSize:
                          AppState.dairyName.capitalize.toString().length > 21
                          ? 13.sp
                          : 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      AppIcons.location(size: 11),
                      Gap.horizentalGap(3),
                      SizedBox(
                        width: 0.46.sw,
                        child: TextWidget(
                          text:
                              '${_dashboardController.vendorDistrict}, ${_dashboardController.vendorState}',
                          fontSize:
                              _dashboardController.vendorDistrict.length > 10
                              ? 10.sp
                              : 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Gap.verticalGap(20),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsGeometry.only(top: 10.h, right: 3.w),
            child: Row(
              children: [
                InkWell(
                  // onTap: () => _dashboardController.openDrawer(),
                  onTap: () => AppNavigation.goToSearchInAppPage(),
                  child: AppIcons.search(size: 18, color: AppColors.blackColor),
                ),
                Gap.horizentalGap(20),
                InkWell(
                  // onTap: () => _dashboardController.openDrawer(),
                  onTap: () => AppNavigation.goToProfilePage(),
                  child: AppIcons.profileIcon(
                    size: 19,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

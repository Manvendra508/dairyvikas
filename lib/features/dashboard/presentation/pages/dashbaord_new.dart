import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_widget/common_container.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/dashboard/presentation/controllers/dashboard_controller.dart'
    show DashboardController;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashboardPageNew extends GetView<DashboardController> {
  DashboardPageNew({super.key});

  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
              width: 1.sw,
              height: 1.sh,
              color: AppColors.themeColor.withOpacity(0.2),

              child: Column(
                children: [
                  Container(
                    width: 1.sw,
                    height: 140.h,
                    decoration: BoxDecoration(
                      color: AppColors.themeColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: _buildTopPart(context),
                  ),
                  Gap.verticalGap(90.h),
                  _buildNewSection('Manage Your Dairy'),
                ],
              ),
            ),
            Positioned(
              top: 100.h,
              left: 16.w,
              child: CommonContainer(
                width: 330.w,
                //    height: 120.h,
                containerColor: AppColors.whiteColor,
                shadowOpacity: 0.7,
                child: Column(
                  children: [
                    Container(
                      width: 330.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.r),
                          topRight: Radius.circular(12.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Gap.horizentalGap(10.w),
                              TextWidget(
                                text: 'free_trial_msg'.trParams({'days': '5'}),
                                fontSize: 12.sp,
                                textColor: AppColors.grey500,
                                fontWeight: FontWeight.w500,
                              ),
                              Gap.horizentalGap(25.w),
                              CommonContainer(
                                width: 120.w,
                                height: 30.h,
                                borderRaduis: 30.r,
                                shadowOpacity: 0.6,
                                child: Center(
                                  child: TextWidget(
                                    text: 'upgrade_now',
                                    fontSize: 12.sp,
                                    textColor: AppColors.themeColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: 330.w,
                      height: 94.h,
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.only(
                          bottomLeft: Radius.circular(12.r),
                          bottomRight: Radius.circular(12.r),
                        ),
                        child: Image.network(
                          fit: BoxFit.fill,
                          scale: 0.1,
                          'https://images.unsplash.com/photo-1500595046743-cd271d694d30?q=80&w=3548&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        ),
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

  _buildNewSection(String title) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: TextWidget(
                text: title,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            Gap.verticalGap(10),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2.3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                physics: BouncingScrollPhysics(),
                children: List.generate(6, (index) => _buildNewActionCard()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildNewActionCard() {
    return CommonContainer(
      margin: EdgeInsets.only(right: 3.w),
      width: 120.w,

      borderRaduis: 8.r,
      borderWidth: 0.2,
      bordercolor: AppColors.themeColor,
      shadowOpacity: 0.5,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  'https://cdn-icons-png.flaticon.com/512/5217/5217724.png',
                  height: 28.h,
                ),
                AppIcons.arrowForward(size: 12, color: AppColors.themeColor),
              ],
            ),
            Gap.verticalGap(5.h),
            TextWidget(
              textAlign: TextAlign.center,
              text: 'Collection',
              fontSize: 12.sp,
              textColor: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  _buildTopPart(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        radius: 42.0,
                        lineWidth: 3.6,
                        percent: _dashboardController.progress.value.clamp(
                          0.0,
                          1.0,
                        ),
                        center: Container(
                          width: 70.w,
                          height: 70.h,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,

                            image: DecorationImage(
                              repeat: ImageRepeat.noRepeat,
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                'https://live.staticflickr.com/1567/25644818033_cfcd9f99f5_b.jpg',
                              ),
                            ),
                          ),
                        ),
                        progressColor: AppColors.redColor,
                      ),
                    ),
                  ),

                  Positioned(
                    right: 0.w,
                    bottom: 10.h,
                    child: InkWell(
                      // onTap: () => _dashboardController
                      //     .showBottomStoryOrPhotoBottomsheet(
                      //       context,
                      //       _buildChooseStoryPhotowidget(context),
                      //     ),
                      child: CommonContainer(
                        shadowOpacity: 0.5,
                        width: 25.w,
                        height: 21.h,
                        borderRaduis: 30.r,
                        child: Center(
                          child: Icon(Icons.add, color: AppColors.themeColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Gap.horizentalGap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  TextWidget(
                    text: 'Rathore Dairy',
                    fontSize: 18.sp,
                    textColor: AppColors.whiteColor,
                    fontWeight: FontWeight.w700,
                  ),
                  Row(
                    children: [
                      AppIcons.location(color: AppColors.grey200, size: 11),
                      Gap.horizentalGap(3),
                      TextWidget(
                        text: 'Jaipur, Rajasthan',
                        fontSize: 12.sp,
                        textColor: AppColors.grey200,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Gap.verticalGap(20),
                ],
              ),
            ],
          ),

          Padding(
            padding: EdgeInsetsGeometry.only(top: 3.h, right: 3.w),
            child: AppIcons.settings(color: AppColors.whiteColor, size: 20),
          ),
        ],
      ),
    );
  }
}

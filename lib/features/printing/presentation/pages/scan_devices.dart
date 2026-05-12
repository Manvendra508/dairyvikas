import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/assets_paths.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/scan_devices_controller.dart';

class ScanDevices extends GetView<ScanDevicesController> with CommonMixin {
  ScanDevices({super.key});

  final ScanDevicesController _scanDevicesController =
      Get.find<ScanDevicesController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.whiteColor,
        floatingActionButton: _buildScanDeviceButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap.verticalGap(10),

              DairyVikasAppBar(title: 'scan_devices'),
              Gap.verticalGap(6),
              Divider(thickness: 0.2),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Padding(
              //       padding: EdgeInsets.only(left: 15.w),
              //       child: TextWidget(
              //         text: 'Paired Devices (3)',
              //         fontWeight: FontWeight.w600,
              //         fontSize: 18.sp,
              //       ),
              //     ),
              //     Gap.verticalGap(2),
              //     Column(
              //       children: List.generate(
              //         2,
              //         (index) => _buildPairedDeviceWidget(),
              //       ),
              //     ),
              //   ],
              // ),
              Gap.verticalGap(10),

              Obx(
                () => Visibility(
                  visible: _scanDevicesController.isScanning.value,
                  child: Column(
                    children: [
                      Visibility(
                        visible: _scanDevicesController.isScanning.value,
                        child: Align(
                          alignment: Alignment.center,
                          child: Lottie.asset(
                            AssetsPaths.scanningAnimation,
                            fit: BoxFit.cover,
                            width: 130.w,
                            height: 110.h,
                            repeat: true,
                          ),
                        ),
                      ),

                      TextWidget(
                        text: 'Searching devices...',
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GetBuilder<ScanDevicesController>(
                  builder: (controller) {
                    return Visibility(
                      visible: true,
                      replacement: _buildNotFoundDataWidget(),

                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: _scanDevicesController.deivces.length,
                        itemBuilder: (context, index) {
                          return _buildScannedDeviceWidget(
                            _scanDevicesController.deivces[index],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildScannedDeviceWidget(String name) {
    return Stack(
      children: [
        CommonContainer(
          shadowOpacity: 0.3,
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          width: 1.sw,
          height: 60.h,
          borderRaduis: 14.r,
          bordercolor: AppColors.grey200,
          borderWidth: 0.4,

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  width: 40.w,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: AppColors.themeColor.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: AppIcons.scan(
                      size: 18.sp,
                      color: AppColors.themeColor.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                Gap.horizentalGap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      TextWidget(
                        maxline: 1,
                        text: name,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.grey800,
                      ),

                      TextWidget(
                        text: 'Scanned Device',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.grey500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 20,
          child: AppButton(
            buttonWidth: 90.w,
            buttonHeight: 20.h,
            buttonBorderRaduids: 5.r,
            buttonFontSize: 12.sp,
            buttonFontWeight: FontWeight.w600,
            title: 'connect',
            isLoading: false.obs,
          ),
        ),
      ],
    );
  }

  _buildPairedDeviceWidget() {
    return Stack(
      children: [
        CommonContainer(
          shadowOpacity: 0.3,
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          width: 1.sw,
          height: 60.h,
          borderRaduis: 14.r,
          bordercolor: AppColors.grey200,
          borderWidth: 0.4,

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  width: 40.w,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: AppColors.themeColor.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: AppIcons.scan(
                      size: 18.sp,
                      color: AppColors.themeColor.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                Gap.horizentalGap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      TextWidget(
                        maxline: 1,
                        text:
                            'Thernal My Printer Thernal Thernal My Printer Thernal',
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.grey800,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 12,
          right: 130,
          child: AppButton(
            buttonWidth: 90.w,
            buttonHeight: 20.h,
            buttonBorderRaduids: 5.r,
            buttonFontSize: 12.sp,
            buttonFontWeight: FontWeight.w600,
            title: 'remove',
            isLoading: false.obs,
            buttonColor: AppColors.redColor.withValues(alpha: 0.8),
            buttonBorderColor: AppColors.redColor.withValues(alpha: 0.8),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 20,
          child: AppButton(
            buttonWidth: 90.w,
            buttonHeight: 20.h,
            buttonBorderRaduids: 5.r,
            buttonFontSize: 12.sp,
            buttonFontWeight: FontWeight.w600,
            title: 'connect',
            isLoading: false.obs,
          ),
        ),
      ],
    );
  }

  _buildScanningBox() {
    return CommonContainer(
      shadowOpacity: 0.3,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      width: 1.sw,
      height: 80.h,
      borderRaduis: 14.r,
      bordercolor: AppColors.grey200,
      borderWidth: 0.4,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Searching devices...',
                  fontWeight: FontWeight.w500,
                ),
                Lottie.asset(
                  AssetsPaths.scanningAnimation,
                  fit: BoxFit.cover,
                  width: 80.w,
                  height: 70.h,
                  repeat: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildNotFoundDataWidget() {
    return Center(
      child: Column(
        children: [
          Gap.verticalGap(0.2.sh),
          TextWidget(
            text: 'no_post_yet',
            fontSize: 14.sp,
            textColor: AppColors.grey600,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          Gap.verticalGap(10),
          InkWell(
            onTap: () => AppNavigation.goToAddNoticePostPage(),
            child: AppButton(
              buttonWidth: 100.w,
              buttonHeight: 30.h,
              shadowOpacity: 0.6,
              buttonBorderRaduids: 6.r,
              title: 'add_post',
              buttonFontWeight: FontWeight.w600,
              buttonFontSize: 12.sp,
              isLoading: false.obs,
            ),
          ),
        ],
      ),
    );
  }

  _buildScanDeviceButton() {
    return Obx(
      () => InkWell(
        splashColor: AppColors.transparentColor,
        onTap: () => _scanDevicesController.startScanning(),
        child: AppButton(
          buttonBorderRaduids: 20.r,
          buttonWidth: 100.w,
          buttonHeight: 27.h,
          buttonFontSize: 13.sp,
          title: _scanDevicesController.isScanning.value
              ? 'Stop Scan'
              : 'Scan Now',
          buttonColor: _scanDevicesController.isScanning.value
              ? AppColors.redColor.withValues(alpha: 0.8)
              : AppColors.themeColor,
          shadowOpacity: 0.6,
          buttonFontWeight: FontWeight.w600,
          isLoading: false.obs,
          buttonBorderColor: _scanDevicesController.isScanning.value
              ? AppColors.redColor.withValues(alpha: 0.8)
              : AppColors.themeColor,
        ),
      ),
    );
  }
}

import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class DairySathiAppBar extends StatelessWidget {
  final double? height;
  final String title;
  final String? dairyName;

  final bool showLeading;
  final Widget? trailingWidget;
  const DairySathiAppBar({
    super.key,
    this.height,
    required this.title,

    this.showLeading = true,
    this.trailingWidget,
    this.dairyName,
  });

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: 1.sw,
    //   height: height,
    //   decoration: BoxDecoration(color: AppColors.whiteColor),
    //   child: Padding(
    //     padding: EdgeInsets.only(
    //       left: 12.w,
    //       top: 15.h,
    //       right: 16.w,
    //       bottom: 10.h,
    //     ),
    //     child: Column(
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Visibility(
    //               visible: showLeading,
    //               child: InkWell(
    //                 onTap: () => AppNavigation.goBack(),
    //                 child: Image.asset(
    //                   AssetsPaths.arrrowBack,
    //                   color: AppColors.blackColor,
    //                   height: 18.h,
    //                 ),
    //               ),
    //             ),

    //             TextWidget(
    //               text: title,
    //               fontSize: 19.sp,
    //               textColor: AppColors.blackColor,
    //               fontWeight: FontWeight.w500,
    //             ),
    //             tariling ?? SizedBox(),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Visibility(
              //   visible: showLeading,
              //   child: InkWell(
              //     onTap: () => AppNavigation.goBack(),
              //     child: AppIcons.arrowBack(
              //       size: 18,
              //       color: AppColors.blackColor,
              //     ),
              //   ),
              // ),
              Visibility(
                visible: showLeading,
                child: Container(
                  height: 35.h,
                  width: 38.w,
                  decoration: BoxDecoration(
                    color: AppColors.themeColor.withOpacity(0.001),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => AppNavigation.goBack(),
                    icon: AppIcons.arrowBack(
                      color: AppColors.grey800,
                      size: 14.h,
                    ),
                  ),
                ),
              ),
              Gap.horizentalGap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: title.tr,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  Gap.verticalGap(1),
                  Visibility(
                    visible: dairyName != null ? true : false,
                    child: TextWidget(
                      text: dairyName ?? '',
                      fontSize: 11.sp,
                      textColor: AppColors.themeColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailingWidget ?? SizedBox.shrink(),
        ],
      ),
    );
  }
}

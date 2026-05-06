import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/common_container.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/notice_board/data/models/notice_post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';
import '../controllers/notice_posts_controller.dart';

class NoticePostsPage extends GetView<NoticePostsController> with CommonMixin {
  NoticePostsPage({super.key});

  final NoticePostsController _noticePostsController =
      Get.find<NoticePostsController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        //   backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Obx(
            () => Visibility(
              visible: !_noticePostsController.isLoading.value,
              replacement: DairySathiLoader(),
              child: Visibility(
                visible: !_noticePostsController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () => _noticePostsController.getAllNoticesPosts(),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(10),

                    DairySathiAppBar(
                      title: 'notice_posts',
                      dairyName: AppState.dairyName.capitalize!,

                      trailingWidget: _buildAppBarButton(),
                    ),
                    Gap.verticalGap(6),
                    Divider(thickness: 0.2),

                    // Obx(
                    //   () => Row(
                    //     children: List.generate(
                    //       _noticePostsController.statusFilters.length,
                    //       (index) => _buildPostsStatusFilter(
                    //         _noticePostsController
                    //             .statusFilters[index]['title'],
                    //         index,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: GetBuilder<NoticePostsController>(
                        builder: (controller) {
                          return Visibility(
                            visible: _noticePostsController
                                .filterednoticePosts
                                .isNotEmpty,
                            replacement: _buildNotFoundDataWidget(),

                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _noticePostsController
                                  .filterednoticePosts
                                  .length,
                              itemBuilder: (context, index) {
                                return _buildPostWidget(
                                  _noticePostsController
                                      .filterednoticePosts[index],
                                  index,
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
          ),
        ),
      ),
    );
  }

  _buildPostWidget(NoticeModel notice, int index) {
    return InkWell(
      onTap: () {
        AppState.isNoticePostEdit = true;
        AppState.currentNoticePostForUpdate = notice;
        AppNavigation.goToAddNoticePostPage();
      },
      child: CommonContainer(
        shadowOpacity: 0.3,
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        width: 1.sw,
        height: 210.h,
        borderRaduis: 14.r,
        bordercolor: AppColors.grey200,
        borderWidth: 0.4,

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     Container(
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(5.r),
              //         color: _noticePostsController
              //             .getPostStatusColor(notice.status.toLowerCase())
              //             .withOpacity(0.1),
              //       ),
              //       child: Row(
              //         children: [
              //           Gap.horizentalGap(6),
              //           _noticePostsController.getPostStatusIcon(
              //             notice.status.toLowerCase(),
              //           ),

              //           Padding(
              //             padding: EdgeInsets.symmetric(
              //               horizontal: 6.w,
              //               vertical: 3.h,
              //             ),
              //             child: TextWidget(
              //               text: _noticePostsController.getPostStatus(
              //                 notice.status.toLowerCase(),
              //               ),
              //               textColor: _noticePostsController
              //                   .getPostStatusColor(
              //                     notice.status.toLowerCase(),
              //                   ),

              //               fontSize: 11.sp,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              Gap.verticalGap(10),
              TextWidget(
                textColor: AppColors.grey700,
                maxline: 8,
                fontSize: 12.2.sp,
                fontWeight: FontWeight.w500,
                text: notice.notice,
              ),
              Spacer(),
              Gap.verticalGap(6),
              Divider(thickness: 0.5, color: AppColors.grey200),
              Gap.verticalGap(6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AppIcons.calendar(size: 11.sp, color: AppColors.grey500),
                      Gap.horizentalGap(5),
                      TextWidget(
                        textColor: AppColors.grey500,
                        maxline: 7,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,

                        text: 'posted_on'.trParams({
                          "date": formatDate(
                            notice.createdAt!.toIso8601String(),
                          ),
                        }),
                      ),
                    ],
                  ),
                  AppIcons.arrowForward(
                    size: 11.sp,
                    color: AppColors.themeColor,
                  ),
                ],
              ),
            ],
          ),
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

  _buildAppBarButton() {
    return InkWell(
      onTap: () => AppNavigation.goToAddNoticePostPage(),
      child: AppButton(
        buttonBorderRaduids: 20.r,
        buttonWidth: 80.w,
        buttonHeight: 27.h,
        buttonFontSize: 12.sp,
        title: 'New Post',

        shadowOpacity: 0.6,
        buttonFontWeight: FontWeight.w600,
        isLoading: false.obs,
      ),
    );
  }

  _buildPostsStatusFilter(String title, int index) {
    return Obx(() {
      RxBool isSelected =
          (_noticePostsController.currentStatusFilterIndex.value == index).obs;
      return InkWell(
        splashColor: AppColors.transparentColor,
        onTap: () {
          _noticePostsController.selectStatus(index);
        },
        child: Container(
          height: 25.h,
          margin: EdgeInsetsGeometry.only(
            left: index == 0 ? 14.w : 8.w,
            top: 4.h,
            bottom: 10.h,
          ),
          decoration: BoxDecoration(
            color: isSelected.value
                ? AppColors.themeColor.withOpacity(0.2)
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(30.r),

            border: Border.all(color: AppColors.grey300, width: 0.5),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextWidget(
                text: title,
                fontSize: 10.sp,
                textColor: isSelected.value
                    ? AppColors.themeColor
                    : AppColors.grey600,
                fontWeight: isSelected.value
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }
}

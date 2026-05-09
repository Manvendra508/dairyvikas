import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/notice_board/presentation/controllers/add_notice_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddNoticePostPage extends GetView<AddNoticePostController>
    with CommonMixin {
  AddNoticePostPage({super.key});

  final AddNoticePostController _addNoticePostController =
      Get.find<AddNoticePostController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap.verticalGap(10),

                DairyVikasAppBar(
                  title: AppState.isNoticePostEdit ? 'update_post' : 'add_post',
                  dairyName: AppState.dairyName.capitalize!,
                  trailingWidget: AppState.isNoticePostEdit
                      ? _buildAppBarButton(context)
                      : null,
                ),
                Gap.verticalGap(6),
                Divider(thickness: 0.2),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  child: TextWidget(
                    text: AppState.isNoticePostEdit
                        ? 'update_your_notice'
                        : 'create_new_notice',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    textColor: AppColors.themeColor,
                  ),
                ),
                CommonContainer(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  shadowOpacity: 0.3,
                  width: 1.sw,
                  //  height: 295.h,
                  borderRaduis: 8.r,
                  bordercolor: AppColors.grey200,
                  borderWidth: 0.5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.r,
                    ),
                    child: Column(
                      children: [
                        TextField(
                          cursorColor: AppColors.grey600,
                          cursorHeight: 16.h,
                          maxLines: 7,

                          inputFormatters: [
                            LengthLimitingTextInputFormatter(300),
                          ],
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.grey600,
                          ),
                          onChanged: (value) {
                            final charCount = value.characters.length;

                            _addNoticePostController.messageLength.value =
                                charCount;

                            _addNoticePostController
                                    .isMessageLimitReached
                                    .value =
                                charCount >= 300;
                          },
                          controller: _addNoticePostController.postMesage,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hint: TextWidget(
                              text: 'write_message_to_user',
                              textColor: AppColors.grey300,
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Obx(
                              () => Row(
                                children: [
                                  Visibility(
                                    visible: _addNoticePostController
                                        .isMessageLimitReached
                                        .value,
                                    child: TextWidget(
                                      fontSize: 12.sp,
                                      text: 'limited_reached',
                                      textColor: AppColors.redColor.withOpacity(
                                        0.8,
                                      ),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Gap.horizentalGap(4),
                                  TextWidget(
                                    fontSize: 12.sp,
                                    text:
                                        '${_addNoticePostController.messageLength}/300',
                                    textColor: AppColors.grey500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap.verticalGap(15),
                        Visibility(
                          //  visible: !_addNoticePostController.hidePostNowButton,
                          child: InkWell(
                            onTap: () {
                              if (AppState.isNoticePostEdit) {
                                _addNoticePostController.updateNoticePost();
                              } else {
                                _addNoticePostController.addNewNoticePost(
                                  false,
                                );
                              }
                            },
                            child: AppButton(
                              title: AppState.isNoticePostEdit
                                  ? 'update_post'
                                  : 'post_now',
                              isLoading: _addNoticePostController.isPosting,
                              buttonFontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Gap.verticalGap(10),
                        // Visibility(
                        //   visible: !_addNoticePostController.hideSchduleButton,
                        //   child: _buildScheduledLaterButton(context),
                        // ),
                        // Gap.verticalGap(8),
                        // Visibility(
                        //   visible:
                        //       AppState.isNoticePostEdit &&
                        //       AppState
                        //           .currentNoticePostForUpdate
                        //           .flags
                        //           .isScheduled,
                        //   child: TextWidget(
                        //     text:
                        //         'This Post is currently scheduled For ${AppState.currentNoticePostForUpdate.scheduleDate!.toDateTimeString}',
                        //     fontSize: 9.sp,
                        //     textColor: AppColors.grey500,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Gap.verticalGap(100.h),
                Center(
                  child: TextWidget(
                    textAlign: TextAlign.center,
                    text: 'customers_will_see_message',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    textColor: AppColors.grey300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildAppBarButton(BuildContext context) {
    return InkWell(
      onTap: () => _addNoticePostController.showDeletePostOption(
        context,
        'post_remove_message',
      ),
      child: AppButton(
        buttonBorderRaduids: 20.r,
        buttonWidth: 110.w,
        buttonHeight: 28.h,
        title: 'remove_post',
        buttonFontSize: 13.sp,
        shadowOpacity: 0.6,
        buttonFontWeight: FontWeight.w600,
        buttonBorderColor: AppColors.redColor.withOpacity(0.8),
        buttonColor: AppColors.redColor.withOpacity(0.8),
        isLoading: _addNoticePostController.isDeleting,
      ),
    );
  }

  _buildScheduledLaterButton(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          // if (!_addNoticePostController.validateData()) return;
          // _addNoticePostController.pickDateForSchedulePost(context);
        },
        child: Container(
          width: 1.sw,
          height: 42.h,

          decoration: BoxDecoration(
            border: Border.all(
              width: 0.8,
              color: AppColors.themeColor.withOpacity(0.5),
            ),
            color: AppColors.whiteColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8.r),

            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor.withOpacity(1),
                blurRadius: 6,
                spreadRadius: 1,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Visibility(
              // visible: !_addNoticePostController.isScheduling.value,
              replacement: SizedBox(
                height: 17.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  color: AppColors.themeColor,
                  strokeWidth: 1.6,
                ),
              ),
              child:
                  // AppState.isNoticePostEdit
                  //     ? Center(
                  //         child: TextWidget(
                  //           text:
                  //               'Scheduled For ${AppState.currentNoticePostForUpdate.scheduleDate!.toDateTimeString}',
                  //           fontSize: 13.sp,
                  //           textColor: AppColors.themeColor,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       )
                  //     :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIcons.calendar(color: AppColors.themeColor),
                      Gap.horizentalGap(10),
                      TextWidget(
                        text: 'Schedule For Later',
                        fontSize: 14.sp,
                        textColor: AppColors.themeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

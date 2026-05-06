import 'dart:math';

import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/common_container.dart';
import 'package:dairysathi/common/common_widget/cross_button.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/features/khata/data/models/khata_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../common/common_widget/app_bar.dart';
import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../core/utils/app_regex.dart';
import '../../../../core/utils/gap.dart';
import '../controllers/khata_entries_controller.dart';

class KhataEntriesPage extends GetView<KhataEntriesController>
    with CommonMixin {
  KhataEntriesPage({super.key});

  final KhataEntriesController _khataEntriesController =
      Get.find<KhataEntriesController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.whiteColor.withOpacity(0.98),
        bottomNavigationBar: _bottomBarButtons(context),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Obx(
            () => Visibility(
              visible: !_khataEntriesController.isLoading.value,
              replacement: DairySathiLoader(),
              child: Visibility(
                visible: !_khataEntriesController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () =>
                      _khataEntriesController.getAllEntriesByCustomerId(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(10),

                    DairySathiAppBar(
                      title: AppState
                          .currentKhataBookCustomerForUpdate
                          .name
                          .capitalize!,
                      dairyName:
                          '+91-${AppState.currentKhataBookCustomerForUpdate.mobile}',
                      trailingWidget: _buildMenuPopUp(),
                    ),
                    Gap.verticalGap(6),
                    Divider(thickness: 0.2),
                    CommonContainer(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      width: 1.sw,
                      height: 70.h,
                      borderRaduis: 6.r,
                      borderWidth: 0.5,
                      bordercolor: AppColors.grey200,
                      shadowOpacity: 0.2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'current_balance',
                                  fontSize: 11.sp,
                                  textColor: AppColors.grey400,
                                  fontWeight: FontWeight.w600,
                                ),
                                Gap.verticalGap(3),
                                TextWidget(
                                  text:
                                      _khataEntriesController
                                          .totalAmount
                                          .isNegative
                                      ? '₹${(-1 * _khataEntriesController.totalAmount).toStringAsFixed(2)}'
                                      : '₹${_khataEntriesController.totalAmount.toStringAsFixed(2)}',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 21.sp,
                                  textColor: AppColors.grey800,
                                ),
                              ],
                            ),
                            Container(
                              height: 28.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                color:
                                    _khataEntriesController
                                        .totalAmount
                                        .isNegative
                                    ? AppColors.themeColor.withOpacity(0.1)
                                    : AppColors.redColor.withOpacity(0.1),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: TextWidget(
                                    text:
                                        _khataEntriesController
                                            .totalAmount
                                            .isNegative
                                        ? 'you_will_get'
                                        : 'you_will_give',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    textColor:
                                        _khataEntriesController
                                            .totalAmount
                                            .isNegative
                                        ? AppColors.themeColor
                                        : AppColors.redColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap.verticalGap(20),
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: TextWidget(
                        text: 'all_entries',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.grey800,
                      ),
                    ),
                    Gap.verticalGap(3),
                    _buildEntriesList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildEntriesList() {
    return Expanded(
      child: Obx(() {
        final list = _khataEntriesController.filteredCustomerKhataEntries;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.bounceInOut,
          switchOutCurve: Curves.bounceInOut,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: list.isEmpty
              ? SingleChildScrollView(
                  key: const ValueKey('empty'),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: _buildNotFounddataWidget(),
                )
              : ListView.builder(
                  key: ValueKey(list.length),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _khataEntriesController
                      .filteredCustomerKhataEntries
                      .length,
                  itemBuilder: (context, index) {
                    return _buildEntryWidget(
                      _khataEntriesController
                          .filteredCustomerKhataEntries[index],
                      context,
                    );
                  },
                ),
        );
      }),
    );
  }

  _buildEntryWidget(KhataEntryModel entry, BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            _khataEntriesController.noteController.text = entry.note;
            _khataEntriesController.entryAmountController.text = entry.amount
                .toString();
            showDragableBottomSheet(
              context,
              _buildAddEntryForm(
                entry.type == 'credit' ? true : false,
                context,
                entry.type == 'credit'
                    ? AppColors.themeColor
                    : AppColors.redColor.withOpacity(0.8),
                entry,
              ),
            );
          },

          onLongPress: () => _khataEntriesController.showDeleteEntryOption(
            context,
            'delete_entry_msg',
            entry.id.toString(),
          ),
          child: CommonContainer(
            margin: EdgeInsets.only(top: 7.h, left: 8.w, right: 8.w),
            width: 1.sw,
            height: 90.h,
            shadowOpacity: 0.9,
            borderRaduis: 4.r,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 230.w,
                            child: TextWidget(
                              text: entry.note.isEmpty
                                  ? 'note_unavailable'
                                  : entry.note.capitalizeFirst!,
                              textColor: AppColors.grey600,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Gap.verticalGap(2),
                          TextWidget(
                            text: _khataEntriesController.timeAgo(
                              entry.updatedAt.toIso8601String(),
                            ),
                            textColor: AppColors.grey500,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: '₹${entry.amount}',
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            textColor: entry.type == 'debit'
                                ? AppColors.redColor
                                : AppColors.themeColor,
                          ),

                          TextWidget(
                            text: entry.type == 'debit' ? 'gave' : 'got',
                            fontSize: 12.sp,
                            textColor: AppColors.grey400,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(thickness: 0.6, color: AppColors.grey100),
                  Gap.verticalGap(4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'balance'.trParams({
                          'amount': '₹${entry.amount}',
                        }),
                        textColor: AppColors.themeColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      AppIcons.arrowForward(
                        color: AppColors.grey500,
                        size: 11.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 7.w,
          top: 7.h,
          child: CommonContainer(
            height: 100.h,
            width: 3.w,
            containerColor: entry.type == 'debit'
                ? AppColors.redColor
                : AppColors.themeColor,
            borderRaduis: 1.r,
            shadowOpacity: 0.1,

            child: SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  _bottomBarButtons(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !_khataEntriesController.isLoading.value,
        child: CommonContainer(
          borderRaduis: 0.r,
          containerColor: AppColors.whiteColor,
          width: 1.sw,
          height: 60.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton(
                    AppColors.redColor.withOpacity(0.8),
                    false,
                    context,
                  ),
                  _buildButton(
                    AppColors.themeColor.withOpacity(0.8),
                    true,
                    context,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildButton(Color color, bool isAddButton, BuildContext context) {
    return InkWell(
      onTap: () => showDragableBottomSheet(
        context,
        _buildAddEntryForm(isAddButton, context, color, null),
      ),
      child: CommonContainer(
        width: 150.w,
        height: 38.h,
        containerColor: color.withOpacity(0.8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: isAddButton,
              replacement: AppIcons.payableArrow(color: AppColors.whiteColor),
              child: Transform.rotate(
                angle: -pi / 1,
                child: AppIcons.payableArrow(color: AppColors.whiteColor),
              ),
            ),
            Gap.horizentalGap(3),
            TextWidget(
              text: isAddButton ? 'gotr' : 'gaver',
              fontWeight: FontWeight.w500,
              fontSize: 17.sp,
              textColor: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }

  _buildAddEntryForm(
    bool isAdd,
    BuildContext context,
    Color color,
    KhataEntryModel? entry,
  ) {
    return SizedBox(
      height: 0.34.sh,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            Gap.verticalGap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: isAdd ? 'you_are_receving' : 'you_are_paying',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  textColor: color.withOpacity(0.8),
                ),
                CrossButton(),
              ],
            ),
            Gap.verticalGap(3),
            Divider(thickness: 0.5),
            Gap.verticalGap(6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap.verticalGap(7),
                _buildTextFormFeild(
                  _khataEntriesController.entryAmountController,
                  'enter_amount',
                  1,
                  TextInputType.number,
                  false,
                ),

                Gap.verticalGap(10),
                _buildTextFormFeild(
                  _khataEntriesController.noteController,
                  'enter_a_note',
                  2,
                  TextInputType.text,
                  false,
                ),
                Gap.verticalGap(10),

                // InkWell(
                //   onTap: () =>
                //       _khataEntriesController.pickDateForFilter(context),
                //   child: Container(
                //     width: 110.w,
                //     height: 32.h,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(8.r),
                //       color: color.withOpacity(0.1),
                //       border: Border.all(
                //         width: 0.5,
                //         color: color.withOpacity(0.7),
                //       ),
                //     ),
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 10.w),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Obx(
                //             () => TextWidget(
                //               text: _khataEntriesController.curentDate.value,
                //               fontSize: 12.sp,
                //               textColor: color,

                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //           AppIcons.calendar(size: 12, color: color),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Gap.verticalGap(15),
                InkWell(
                  onTap: () {
                    if (entry == null) {
                      _khataEntriesController.addKhataEntry(
                        isAdd ? 'credit' : 'debit',
                      );
                    } else {
                      _khataEntriesController.updateKhataEntry(entry);
                    }
                  },
                  child: AppButton(
                    buttonBorderColor: color,
                    title: entry == null ? 'add' : 'update',
                    isLoading: false.obs,
                    buttonColor: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildTextFormFeild(
    TextEditingController controller,
    String hint,
    int id,
    TextInputType inputType,
    bool? readyOnly,
  ) {
    return TextFormField(
      keyboardType: inputType,
      controller: controller,
      cursorColor: AppColors.grey500,
      cursorHeight: 20,
      readOnly: readyOnly ?? false,

      inputFormatters: [
        if (id == 1) FilteringTextInputFormatter.allow(AppRegex.onlyNumber),

        LengthLimitingTextInputFormatter(id == 1 ? 4 : 30),
      ],
      decoration: InputDecoration(
        fillColor: AppColors.grey100,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10.5.h, horizontal: 7.w),
        focusedBorder: OutlineInputBorder(
          gapPadding: 5.w,
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 0.8, color: AppColors.grey100),
        ),
        enabledBorder: OutlineInputBorder(
          gapPadding: 5.w,
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 0.8, color: AppColors.grey100),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 0.8, color: AppColors.grey100),
        ),

        hint: TextWidget(
          text: hint,
          fontSize: 12.sp,
          textColor: AppColors.textLight,
        ),
      ),
    );
  }

  _buildNotFounddataWidget() {
    return Center(
      child: Column(
        children: [
          TextWidget(
            text: 'no_entries_found',
            fontSize: 14.sp,
            textColor: AppColors.grey600,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _buildMenuPopUp() {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      menuPadding: EdgeInsets.zero,
      icon: Padding(
        padding: EdgeInsets.only(left: 12.w),
        child: AppIcons.more(),
      ),
      popUpAnimationStyle: AnimationStyle(
        duration: Duration(milliseconds: 450),
        curve: Curves.bounceInOut,
      ),
      color: AppColors.whiteColor,
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            // onTap: () => AppNavigation.goToAdjustCollectionPage(),
            height: 20,
            padding: EdgeInsets.only(bottom: 14.h, left: 7.h, top: 5.h),
            child: _buildPopMenuTextWidget('call'),
          ),

          // PopupMenuItem(
          //   onTap: () {
          //     AppState.iskhataCustomerEdit = true;
          //     AppNavigation.goToAddKhataCustomerPage();
          //   },
          //   height: 20,
          //   padding: EdgeInsets.only(bottom: 14.h, left: 7.h),

          //   child: _buildPopMenuTextWidget('update'),
          // ),
        ];
      },
    );
  }

  _buildPopMenuTextWidget(String title) {
    return TextWidget(
      text: title,

      textColor: AppColors.blackColor,
      fontWeight: FontWeight.w500,
    );
  }
}

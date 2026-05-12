import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/collection/presentation/controllers/all_collection_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';
import 'collection_common_widgets/collection_widget.dart';

class AllCollectionPage extends GetView<AllCollectionController>
    with CommonMixin {
  AllCollectionPage({super.key});

  final AllCollectionController _allCollectionController =
      Get.find<AllCollectionController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: _buildTotalCalculatedData(),
        body: Obx(
          () => Visibility(
            visible: !_allCollectionController.isLoading.value,
            replacement: DairyVikasLoader(),
            child: Visibility(
              visible: !_allCollectionController.hasError.value,
              replacement: RetryWidget(
                onRetry: () => _allCollectionController.getAllCollection(),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.verticalGap(20),

                  DairyVikasAppBar(
                    title: 'collections',
                    dairyName: AppState.dairyName.capitalize!,

                    trailingWidget: _buildAppBarButton(context),
                  ),
                  Gap.verticalGap(6),
                  Divider(thickness: 0.2),

                  Gap.verticalGap(5),

                  _buildTextFormFieldForSearchCollection(context),
                  Gap.verticalGap(10),
                  Container(
                    width: 1.sw,
                    height: 30.h,
                    color: AppColors.success.withValues(alpha: 0.15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppIcons.info(size: 11.sp),
                        Gap.horizentalGap(10),
                        TextWidget(
                          text: 'Evening shift starts at 4:00 PM',
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  Gap.verticalGap(10),
                  _buildTopFilters(context),
                  Gap.verticalGap(10),
                  _buildTitleHeader(),

                  Expanded(
                    child: Obx(() {
                      final list =
                          _allCollectionController.filteredCollectionsList;

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
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return CollectionWidget(
                                    collection: list[index],
                                    index: index,
                                  );
                                },
                              ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildTotalCalculatedData() {
    return Obx(
      () => AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Visibility(
          visible: _allCollectionController.filteredCollectionsList.isNotEmpty,
          child: CommonContainer(
            borderRaduis: 0.r,
            width: 1.sw,
            height: _allCollectionController.isShowFullDataOpen.value
                ? 165.h
                : 43.h,
            containerColor: AppColors.whiteColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: _allCollectionController.isShowFullDataOpen.value
                            ? 'hide_full_data'
                            : 'show_full_data',
                        fontSize: 13.5.sp,
                        textColor: AppColors.grey600,
                        fontWeight: FontWeight.w600,
                      ),
                      InkWell(
                        onTap: () =>
                            _allCollectionController.isShowFullDataOpen.value =
                                !_allCollectionController
                                    .isShowFullDataOpen
                                    .value,
                        child: Container(
                          width: 32.w,
                          height: 22.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: AppColors.themeColor.withValues(alpha: 0.8),
                          ),
                          child: Center(
                            child: AnimatedRotation(
                              turns:
                                  _allCollectionController
                                      .isShowFullDataOpen
                                      .value
                                  ? 0.5
                                  : 0,
                              duration: const Duration(milliseconds: 250),
                              child: AppIcons.arrowUp(
                                size: 17,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: _allCollectionController.isShowFullDataOpen.value,
                    child: Column(
                      children: [
                        Gap.verticalGap(5),
                        Divider(color: AppColors.grey100),
                        Gap.verticalGap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              spacing: 4.h,
                              children: [
                                TextWidget(
                                  text: 'snf',
                                  fontSize: 11.sp,
                                  textColor: AppColors.grey400,
                                  fontWeight: FontWeight.w600,
                                ),
                                TextWidget(
                                  text: _allCollectionController.avgSnf
                                      .toStringAsFixed(2),
                                  fontSize: 15.sp,
                                  textColor: AppColors.grey800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            Column(
                              spacing: 4.h,
                              children: [
                                TextWidget(
                                  text: 'fat',
                                  fontSize: 11.sp,
                                  textColor: AppColors.grey400,
                                  fontWeight: FontWeight.w600,
                                ),
                                TextWidget(
                                  text: _allCollectionController.avgFat
                                      .toStringAsFixed(2),
                                  fontSize: 15.sp,
                                  textColor: AppColors.grey800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            Column(
                              spacing: 4.h,
                              children: [
                                TextWidget(
                                  text: 'liter',
                                  fontSize: 11.sp,
                                  textColor: AppColors.grey400,
                                  fontWeight: FontWeight.w600,
                                ),
                                TextWidget(
                                  text:
                                      '${_allCollectionController.totalLitre}',
                                  fontSize: 15.sp,
                                  textColor: AppColors.grey800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            Column(
                              spacing: 4.h,
                              children: [
                                TextWidget(
                                  text: 'rate',
                                  fontSize: 11.sp,
                                  textColor: AppColors.grey400,
                                  fontWeight: FontWeight.w600,
                                ),
                                TextWidget(
                                  text: _allCollectionController.avgRate
                                      .toStringAsFixed(2),
                                  fontSize: 15.sp,
                                  textColor: AppColors.grey800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            Column(
                              spacing: 4.h,
                              children: [
                                TextWidget(
                                  text: 'amount',
                                  fontSize: 11.sp,
                                  textColor: AppColors.grey400,
                                  fontWeight: FontWeight.w600,
                                ),
                                TextWidget(
                                  text:
                                      '₹${_allCollectionController.totalAmount.toStringAsFixed(2)}',
                                  fontSize: 15.sp,
                                  textColor: AppColors.grey800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Gap.verticalGap(5),
                        Divider(color: AppColors.grey100),
                        Gap.verticalGap(5),
                        _buildCountBox(),
                      ],
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

  _buildCommonBottomSheetWidget(
    String title,
    Widget childWidget, {
    double? height,
  }) {
    return Container(
      width: 1.sw,
      height: height ?? 170.h,
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
                  text: title,
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
            childWidget,
          ],
        ),
      ),
    );
  }

  _buildSortWidget() {
    return Obx(() {
      return Column(
        children: List.generate(
          _allCollectionController.sortBy.length,
          (index) => Column(
            children: [
              index == 0 ? SizedBox.shrink() : Gap.verticalGap(22),
              InkWell(
                onTap: () {
                  _allCollectionController.selectedSortBy.value =
                      _allCollectionController.sortBy[index];
                  _allCollectionController.sortCollections();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: _allCollectionController.sortBy[index]['value'],
                      textColor:
                          _allCollectionController.selectedSortBy['id'] ==
                              _allCollectionController.sortBy[index]['id']
                          ? AppColors.grey800
                          : AppColors.grey700,
                      fontWeight:
                          _allCollectionController.selectedSortBy['id'] ==
                              _allCollectionController.sortBy[index]['id']
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                    Container(
                      width: 17.w,
                      height: 17.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          color:
                              _allCollectionController.selectedSortBy['id'] ==
                                  _allCollectionController.sortBy[index]['id']
                              ? AppColors.themeColor
                              : AppColors.darkBorder,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 11.w,
                          height: 11.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _allCollectionController.selectedSortBy['id'] ==
                                    _allCollectionController.sortBy[index]['id']
                                ? AppColors.themeColor
                                : AppColors.grey200,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _buildTopFilters(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => _allCollectionController.pickDateForFilter(context),
            child: Container(
              width: 110.w,
              height: 32.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),

                border: Border.all(width: 1, color: AppColors.grey300),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => TextWidget(
                        text: _allCollectionController.curentDate.value,
                        fontSize: 12.sp,
                        textColor: AppColors.grey700,

                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AppIcons.calendar(size: 12, color: AppColors.grey700),
                  ],
                ),
              ),
            ),
          ),

          _buildDropdownField(
            hint: '',
            items: _allCollectionController.milkTypes,
            selectedValue: _allCollectionController.selectedMilkType,
            id: 1,
          ),
          _buildDropdownField(
            hint: '',
            items: _allCollectionController.shiftFilters.take(3).toList(),
            selectedValue: _allCollectionController.selectedShift,
            id: 2,
          ),
        ],
      ),
    );
  }

  _buildDropdownField({
    required String hint,
    required List<Map<String, dynamic>> items,
    required RxMap<String, dynamic> selectedValue,
    required int id,
  }) {
    return Obx(
      () => Container(
        width: 110.w,
        height: 32.h,
        padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 7.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(width: 1, color: AppColors.grey300),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Map<String, dynamic>>(
            value: selectedValue.value.isEmpty ? null : selectedValue.value,
            isExpanded: true,
            hint: TextWidget(
              text: hint,
              fontSize: 12.sp,
              textColor: AppColors.grey700,
              fontWeight: FontWeight.w500,
            ),
            items: items.map((e) {
              return DropdownMenuItem(
                value: e,
                child: TextWidget(
                  text: id == 1 ? e['value'] : e['name'],
                  textColor: AppColors.grey700,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              selectedValue.value = value;
              _allCollectionController.filterCollections();
            },
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.grey700),
          ),
        ),
      ),
    );
  }

  _buildNotFounddataWidget() {
    return Center(
      child: Column(
        children: [
          TextWidget(
            text: 'no_collection_found',
            fontSize: 14.sp,
            textColor: AppColors.grey600,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          Gap.verticalGap(10),
          InkWell(
            onTap: () => AppNavigation.goToAddNewCollectionPage(true),
            child: AppButton(
              buttonWidth: 100.w,
              buttonHeight: 30.h,
              shadowOpacity: 0.6,
              buttonBorderRaduids: 6.r,
              title: 'add_now',
              buttonFontWeight: FontWeight.w600,
              buttonFontSize: 12.sp,
              isLoading: false.obs,
            ),
          ),
        ],
      ),
    );
  }

  _buildTextFormFieldForSearchCollection(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              width: 1.sw / 1.2,
              height: 35.h,
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _allCollectionController.searchController,
                cursorColor: AppColors.grey500,
                cursorHeight: 20,
                onChanged: (value) =>
                    _allCollectionController.searchCollection(value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.whiteColor,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 18.5.h,
                    horizontal: 25.w,
                  ),

                  focusedBorder: OutlineInputBorder(
                    gapPadding: 5.w,
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide(
                      width: 0.8,
                      color: AppColors.themeColor.withValues(alpha: 0.4),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 5.w,
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide(
                      width: 0.8,
                      color: AppColors.themeColor.withValues(alpha: 0.4),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide(
                      width: 0.8,
                      color: AppColors.themeColor.withValues(alpha: 0.4),
                    ),
                  ),

                  hint: TextWidget(
                    text: 'search_collection',
                    fontSize: 11.sp,
                    textColor: AppColors.grey300,
                  ),
                ),
              ),
            ),
            Gap.horizentalGap(2),
            InkWell(
              onTap: () => showMyBottomSheet(
                context,
                _buildCommonBottomSheetWidget('sort_by', _buildSortWidget()),
              ),
              child: AppIcons.sort(size: 20, color: AppColors.grey600),
            ),
          ],
        ),
        Positioned(
          top: 15,
          left: 20,
          child: AppIcons.search(color: AppColors.grey300),
        ),
      ],
    );
  }

  _buildCountBox() {
    return CommonContainer(
      width: 1.sw,
      height: 40.h,

      borderRaduis: 8.r,
      shadowOpacity: 0.3,
      borderWidth: 0.5,
      bordercolor: AppColors.themeColor,
      containerColor: AppColors.whiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              TextWidget(
                text: 'absent:',
                fontWeight: FontWeight.w600,
                fontSize: 11.5.sp,
                textColor: AppColors.themeColor,
              ),
              Gap.horizentalGap(5),
              TextWidget(
                text: _allCollectionController.absentSuppliersCount.toString(),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.grey800,
              ),
            ],
          ),
          Row(
            children: [
              TextWidget(
                text: 'present:',
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.redColor.withValues(alpha: 0.7),
              ),
              Gap.horizentalGap(5),
              TextWidget(
                text: _allCollectionController.presentSuppliersCount.toString(),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.grey800,
              ),
            ],
          ),
          Row(
            children: [
              TextWidget(
                text: 'active:',
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.grey800,
              ),
              Gap.horizentalGap(5),
              TextWidget(
                text: _allCollectionController.totalSuppliersCount.toString(),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.grey800,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildAppBarButton(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => AppNavigation.goToAddNewCollectionPage(true),
          child: AppButton(
            buttonBorderRaduids: 20.r,
            buttonWidth: 60.w,
            buttonHeight: 27.h,
            buttonFontSize: 12.sp,
            title: 'add',

            shadowOpacity: 0.6,
            buttonFontWeight: FontWeight.w600,
            isLoading: false.obs,
          ),
        ),

        _buildMenuPopUp(),
      ],
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
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            onTap: () => AppNavigation.goToAdjustCollectionPage(),
            height: 20,
            padding: EdgeInsets.only(bottom: 14.h, left: 7.h, top: 5.h),
            child: _buildPopMenuTextWidget('collection_adjustment'),
          ),

          PopupMenuItem(
            height: 20,
            padding: EdgeInsets.only(bottom: 14.h, left: 7.h),

            child: _buildPopMenuTextWidget('print'),
          ),
          PopupMenuItem(
            height: 20,
            padding: EdgeInsets.only(bottom: 14.h, left: 7.h),
            child: _buildPopMenuTextWidget('download_excel'),
          ),
          PopupMenuItem(
            height: 20,
            padding: EdgeInsets.only(bottom: 14.h, left: 7.h),
            child: _buildPopMenuTextWidget('sms_status'),
          ),
          PopupMenuItem(
            height: 20,
            padding: EdgeInsets.only(bottom: 14.h, left: 7.h),
            child: _buildPopMenuTextWidget('update_collection_rate'),
          ),
          PopupMenuItem(
            onTap: () => AppNavigation.goToCustomerPdfSheetPage(),
            height: 20,
            padding: EdgeInsets.only(bottom: 10.h, left: 7.h),
            child: _buildPopMenuTextWidget('collection_sheet'),
          ),
        ];
      },
    );
  }

  _buildPopMenuTextWidget(String title) {
    return TextWidget(
      text: title,
      fontSize: 12.sp,
      textColor: AppColors.grey800,
      fontWeight: FontWeight.w500,
    );
  }

  _buildTitleHeader() {
    return Container(
      width: 1.sw,
      height: 28.h,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(2.r),
        border: Border(bottom: BorderSide(color: AppColors.grey200, width: 1)),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.only(left: 14.w, right: 23.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextWidget(
                  text: 'sno',
                  fontSize: 12.sp,
                  textColor: AppColors.themeColor,
                  fontWeight: FontWeight.w500,
                ),
                Gap.horizentalGap(17),
                TextWidget(
                  text: 'names/details',
                  fontSize: 12.sp,
                  textColor: AppColors.themeColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            TextWidget(
              text: 'amount',
              fontSize: 12.sp,
              textColor: AppColors.themeColor,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/dashboard/data/model/recent_search_model.dart';
import 'package:DairyVikas/features/dashboard/presentation/controllers/search_in_app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchInAppPage extends GetView<SearchInAppController> with CommonMixin {
  SearchInAppPage({super.key});

  final SearchInAppController _searchInAppController =
      Get.find<SearchInAppController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.grey100,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       height: 35.h,
                //       width: 35.w,
                //       decoration: BoxDecoration(
                //         color: AppColors.whiteColor,
                //         borderRadius: BorderRadius.circular(8.r),
                //       ),
                //       child: IconButton(
                //         padding: EdgeInsets.zero,
                //         onPressed: () => AppNavigation.goBack(),
                //         icon: AppIcons.arrowBack(
                //           color: AppColors.grey800,
                //           size: 16.h,
                //         ),
                //       ),
                //     ),
                //     Gap.horizentalGap(10),
                //     _buildTextFormFieldForInAppSearch(),
                //   ],
                // ),
                Gap.verticalGap(10),
                DairyVikasAppBar(title: 'Search in App'),
                Gap.verticalGap(12),
                _buildTextFormFieldForInAppSearch(),
                Gap.verticalGap(4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(16),
                    Padding(
                      padding: EdgeInsets.only(left: 6.w),
                      child: TextWidget(
                        text: 'Quick Access',
                        fontSize: 12.sp,
                        textColor: AppColors.grey800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap.verticalGap(10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: List.generate(
                          _searchInAppController.quickAccess.length,
                          (index) => InkWell(
                            onTap: () {
                              final callback = _searchInAppController
                                  .quickAccess[index]['callback'];

                              if (callback != null && callback is Function) {
                                callback();
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 6.w),

                              height: 27.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                  color: AppColors.grey200,
                                ),
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _searchInAppController
                                        .quickAccess[index]['icon'],
                                    Gap.horizentalGap(5),
                                    TextWidget(
                                      text: _searchInAppController
                                          .quickAccess[index]['title'],
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _buildRecentSearchesNew(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildRecentSearches() {
    return Obx(
      () => Visibility(
        visible: _searchInAppController.recentSearches.isNotEmpty,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 17.h),
          width: 1.sw,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Recent Searches',
                    fontSize: 14.sp,
                    textColor: AppColors.grey800,
                    fontWeight: FontWeight.w600,
                  ),
                  IconButton(
                    onPressed: () {
                      SharedPrefsService.instance.remove(
                        SharedPrefsService.recentSearchKey,
                      );
                      _searchInAppController.recentSearches.clear();
                    },
                    icon: TextWidget(
                      text: 'Clear',
                      fontSize: 14.sp,
                      textColor: AppColors.redColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              Column(
                children: List.generate(
                  _searchInAppController.recentSearches.length,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 4.w,
                    ),
                    child: Column(
                      children: [
                        Divider(
                          color: AppColors.grey100,
                          thickness: 0.7,
                          height: 6.h,
                        ),
                        Gap.verticalGap(10),
                        InkWell(
                          onTap: () =>
                              _searchInAppController.navigateFromRecentSearch(
                                _searchInAppController.recentSearches[index].id,
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  AppIcons.history(color: AppColors.grey400),
                                  Gap.horizentalGap(10),
                                  TextWidget(
                                    text: _searchInAppController
                                        .recentSearches[index]
                                        .name,
                                    fontSize: 13.sp,
                                    textColor: AppColors.grey600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              Transform.rotate(
                                angle: 50 * pi / 60, // degrees → radians
                                child: AppIcons.arrowBack(
                                  color: AppColors.grey800,
                                  size: 14.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildRecentSearchesNew() {
    return Obx(
      () => Visibility(
        visible: _searchInAppController.recentSearches.isNotEmpty,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            color: AppColors.whiteColor,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'Recent Searches',
                      fontSize: 14.sp,
                      textColor: AppColors.grey800,
                      fontWeight: FontWeight.w600,
                    ),
                    IconButton(
                      onPressed: () {
                        SharedPrefsService.instance.remove(
                          SharedPrefsService.recentSearchKey,
                        );
                        _searchInAppController.recentSearches.clear();
                      },
                      icon: TextWidget(
                        text: 'Clear',
                        fontSize: 14.sp,
                        textColor: AppColors.redColor.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Divider(color: AppColors.grey100, thickness: 0.7, height: 6.h),
                Gap.verticalGap(10),
                Wrap(
                  alignment: WrapAlignment.start,
                  runSpacing: 10.h,
                  spacing: 10.w,
                  children: List.generate(
                    _searchInAppController.recentSearches.length,
                    (index) => InkWell(
                      onTap: () =>
                          _searchInAppController.navigateFromRecentSearch(
                            _searchInAppController.recentSearches[index].id,
                          ),
                      child: Container(
                        height: 25.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19.r),
                          color: AppColors.grey100,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextWidget(
                                text: _searchInAppController
                                    .recentSearches[index]
                                    .name,
                                fontSize: 12.sp,
                                textColor: AppColors.grey800,
                                fontWeight: FontWeight.w500,
                              ),
                              Gap.horizentalGap(6.w),
                              Transform.rotate(
                                angle: 50 * pi / 60, // degrees → radians
                                child: AppIcons.arrowBack(
                                  color: AppColors.grey900,
                                  size: 10.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTextFormFieldForInAppSearch() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              // width: 1.sw - 60.w,
              width: 1.sw,

              height: 35.h,
              child: TextFormField(
                keyboardType: TextInputType.text,

                cursorColor: AppColors.grey500,
                cursorHeight: 17,
                onChanged: (value) {
                  _searchInAppController.searchedTerm = value;
                  _searchInAppController.searchInApp();
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.whiteColor,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 18.5.h,
                    horizontal: 25.w,
                  ),

                  focusedBorder: OutlineInputBorder(
                    gapPadding: 5.w,
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      width: 0.8,
                      color: AppColors.grey200,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 5.w,
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      width: 0.8,
                      color: AppColors.grey200,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      width: 0.8,
                      color: AppColors.grey200,
                    ),
                  ),

                  hint: TextWidget(
                    text: 'What are you looking for?',
                    fontSize: 12.sp,
                    textColor: AppColors.grey400,
                  ),
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: _searchInAppController.searchResultList.isNotEmpty,
                child: Container(
                  width: 1.sw,

                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: AppColors.grey100.withOpacity(0.6),
                    border: Border.all(width: 0.5, color: AppColors.grey100),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: 6.w, right: 6.w, bottom: 5.h),
                    child: Column(
                      children: List.generate(
                        _searchInAppController.searchResultList.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: InkWell(
                            onTap: () async {
                              await SharedPrefsService.saveRecentSearch(
                                RecentSearch(
                                  id: _searchInAppController
                                      .searchResultList[index]['id']!,
                                  name: _searchInAppController
                                      .searchResultList[index]['name']!,
                                ),
                              );
                              final callback = _searchInAppController
                                  .searchResultList[index]['callback'];

                              if (callback != null && callback is Function) {
                                callback();
                              }
                            },
                            child: Container(
                              height: 28.h,
                              color: AppColors.grey100.withOpacity(0.6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      AppIcons.search(color: AppColors.grey400),
                                      Gap.horizentalGap(10),

                                      highlightText(
                                        _searchInAppController
                                            .searchResultList[index]['name'],
                                        _searchInAppController.searchedTerm,
                                      ),
                                    ],
                                  ),

                                  Transform.rotate(
                                    angle: 50 * pi / 60,
                                    child: AppIcons.arrowBack(
                                      color: AppColors.themeColor,
                                      size: 12.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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

  Widget highlightText(String text, String query) {
    if (query.isEmpty) {
      return TextWidget(
        text: text,
        fontSize: 13.sp,
        textColor: AppColors.grey700,
        fontWeight: FontWeight.w600,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return TextWidget(
        text: text,
        fontSize: 13.sp,
        textColor: AppColors.grey700,
        fontWeight: FontWeight.w600,
      );
    }

    final endIndex = startIndex + query.length;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, startIndex),
            style: TextStyle(
              color: AppColors.grey700,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: TextStyle(
              color: AppColors.redColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: text.substring(endIndex),
            style: TextStyle(
              color: AppColors.grey700,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

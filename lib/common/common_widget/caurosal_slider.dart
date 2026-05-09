// ignore_for_file: must_be_immutable

import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/banner_widget.dart';
import 'package:DairyVikas/core/utils/assets_paths.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WidgetBannerSlider extends StatelessWidget {
  WidgetBannerSlider({super.key});

  RxInt currentPage = 0.obs;
  final PageController pageController = PageController();

  List<Widget> widgets = [
    //ExpireFreePlanInfoCard(shadowOpacity: 0.4),
    BannerWidget(imagePath: AssetsPaths.referBanner),
    BannerWidget(imagePath: AssetsPaths.dsBanner),
    BannerWidget(imagePath: AssetsPaths.subscriptionBanner),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 120.h,
            viewportFraction: 0.99,
            enlargeCenterPage: true,
            autoPlay: true,

            autoPlayAnimationDuration: Duration(milliseconds: 600),
            autoPlayInterval: Duration(seconds: 5),
            onPageChanged: (index, reason) => currentPage.value = index,
          ),

          items: widgets.map((item) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
              child: item,
            );
          }).toList(),
        ),
        Gap.verticalGap(10),

        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widgets.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: currentPage.value == index ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentPage.value == index
                      ? AppColors.themeColor
                      : AppColors.textExtraLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

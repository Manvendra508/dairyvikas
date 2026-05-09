import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/features/food/data/models/dealer_model.dart';
import 'package:DairyVikas/features/food/presentation/controllers/add_food_stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../common/common_widget/common_container.dart';
import '../../../../common/common_widget/text_widget.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../core/utils/gap.dart';

class DealerListBottomSheet extends StatelessWidget {
  final String title;
  final dynamic Function(String) searchDealerInList;
  final dynamic Function(DealerModel) selectDealerBySearching;
  const DealerListBottomSheet({
    super.key,
    required this.title,
    required this.searchDealerInList,
    required this.selectDealerBySearching,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 0.85.sh,
      decoration: BoxDecoration(
        color: AppColors.themeColor.withOpacity(0.07),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
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
            _buildTextFormFieldForSearchDealer(),

            Gap.verticalGap(7.h),

            Expanded(
              child: GetBuilder<AddFoodStockController>(
                builder: (controller) => ListView.builder(
                  itemCount: controller.dealersForBottomList.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      _buildDealerCard(controller.dealersForBottomList[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTextFormFieldForSearchDealer() {
    return Stack(
      children: [
        Container(
          width: 1.sw,
          margin: EdgeInsets.symmetric(horizontal: 0.w),
          height: 35.h,
          child: TextFormField(
            keyboardType: TextInputType.text,

            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            onChanged: (value) => searchDealerInList(value),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.whiteColor,
              contentPadding: EdgeInsets.symmetric(
                vertical: 18.5.h,
                horizontal: 35.w,
              ),

              focusedBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
              ),

              hint: TextWidget(
                text: 'search_dealer',
                fontSize: 12.sp,
                textColor: AppColors.grey300,
              ),
            ),
          ),
        ),
        Positioned(
          top: 15,
          left: 15,
          child: AppIcons.search(color: AppColors.grey300),
        ),
      ],
    );
  }

  _buildDealerCard(DealerModel dealer) {
    return InkWell(
      onTap: () => selectDealerBySearching(dealer),
      child: CommonContainer(
        containerColor: AppColors.whiteColor,

        margin: EdgeInsets.only(top: 4.h, left: 0.w, right: 0.w),
        height: 45.h,
        borderRaduis: 7.r,

        shadowOpacity: 0.3,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180.w,
                        child: TextWidget(
                          text: dealer.dealerName.capitalize!,
                          textColor: AppColors.grey800,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap.verticalGap(2.h),
                      Row(
                        children: [
                          TextWidget(
                            text: '+91-${dealer.mobile}',
                            fontSize: 9.sp,
                            textColor: AppColors.grey400,
                            fontWeight: FontWeight.w600,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            width: 1,
                            height: 10.h,
                            color: AppColors.grey400,
                          ),
                          TextWidget(
                            text: 'code:'.trParams({'code': dealer.dealerCode}),

                            fontSize: 9.sp,
                            textColor: AppColors.grey400,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

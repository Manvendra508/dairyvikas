import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/features/collection/data/model/collection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../common/common_widget/text_widget.dart';
import '../../../../../core/utils/app_icons.dart';
import '../../../../../core/utils/app_navigation.dart';
import '../../../../../core/utils/gap.dart';

class CollectionWidget extends StatelessWidget {
  final CollectionModel collection;
  final int index;
  const CollectionWidget({
    super.key,
    required this.collection,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppState.isCollectionEdit = true;
        AppState.currentCollectionforUpdate = collection;
        AppNavigation.goToAddNewCollectionPage(true);
      },
      child: Container(
        width: 1.sw,

        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(2.r),
          border: Border(
            bottom: BorderSide(color: AppColors.grey200, width: 0.7),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(
                left: 14.w,
                right: 25.w,
                bottom: 12.h,
                top: 12.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0.w),
                        child: TextWidget(
                          text: '${index + 1}.',

                          textColor: AppColors.grey700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap.horizentalGap(0.08.sw),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 180.w,
                            child: TextWidget(
                              text: collection.collectionSupplier.supplierName,
                              textColor: AppColors.grey800,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Gap.verticalGap(4.h),
                          Row(
                            children: [
                              TextWidget(
                                text: 'fat: ',
                                fontSize: 11.sp,
                                textColor: AppColors.grey400,
                                fontWeight: FontWeight.w600,
                              ),
                              TextWidget(
                                text: '${collection.fat}',
                                fontSize: 11.sp,
                                textColor: AppColors.grey600,
                                fontWeight: FontWeight.w600,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 7.w),
                                width: 1,
                                height: 10.h,
                                color: AppColors.grey500,
                              ),
                              TextWidget(
                                text: 'snf: ',
                                fontSize: 11.sp,
                                textColor: AppColors.grey400,
                                fontWeight: FontWeight.w600,
                              ),
                              TextWidget(
                                text: '${collection.snf}',
                                fontSize: 11.sp,
                                textColor: AppColors.grey600,
                                fontWeight: FontWeight.w600,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 7.w),
                                width: 1,
                                height: 10.h,
                                color: AppColors.grey500,
                              ),
                              collection.milkTypeId == 1
                                  ? AppIcons.cow()
                                  : AppIcons.buffalo(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextWidget(
                        text: '₹${collection.totalAmount}',
                        textColor: AppColors.themeColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      TextWidget(
                        text:
                            '₹${collection.ratePerLitre} × ${collection.litre}L',
                        fontSize: 11.sp,
                        textColor: AppColors.grey400,
                        fontWeight: FontWeight.w600,
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

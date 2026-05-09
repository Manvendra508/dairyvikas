import 'package:DairyVikas/app/extensions/string_ext.dart';
import 'package:DairyVikas/features/milk_suppliers/data/model/milk_supplier_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../common/common_widget/common_container.dart';
import '../../../../../common/common_widget/text_widget.dart';
import '../../../../../core/utils/gap.dart';

class SearchedSupplierInfo extends StatelessWidget {
  final MilkSupplierModel supplier;
  const SearchedSupplierInfo({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      //margin: EdgeInsets.symmetric(horizontal: 10.w),
      width: 1.sw,

      containerColor: AppColors.transparentColor,
      bordercolor: AppColors.grey100,
      shadowOpacity: 0.2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap.verticalGap(1),
            TextWidget(
              text: supplier.supplierName.capitalize,

              textColor: AppColors.themeColor,

              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
            Gap.verticalGap(3),
            TextWidget(
              text: '+91-${supplier.supplierMobile}',

              textColor: AppColors.grey500,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w500,
            ),
            //  Divider(thickness: 0.5, color: AppColors.grey300, height: 7.h),
          ],
        ),
      ),
    );
  }
}

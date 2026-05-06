import 'package:dairysathi/app/extensions/string_ext.dart';
import 'package:dairysathi/features/food/data/models/dealer_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../common/common_widget/common_container.dart';
import '../../../../../common/common_widget/text_widget.dart';
import '../../../../../core/utils/gap.dart';

class SearchDealerInfo extends StatelessWidget {
  final DealerModel dealer;
  const SearchDealerInfo({super.key, required this.dealer});

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
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
              text: dealer.dealerName.capitalize,

              textColor: AppColors.themeColor,

              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),

            // Gap.verticalGap(3),
            // TextWidget(
            //   text: '+91-${dealer.mobile}',

            //   textColor: AppColors.grey500,
            //   fontSize: 11.5.sp,
            //   fontWeight: FontWeight.w500,
            // ),
          ],
        ),
      ),
    );
  }
}

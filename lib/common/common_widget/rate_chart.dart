import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/utils/assets_paths.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RateChart extends StatelessWidget {
  final bool isSingleType;
  final List<List<double>> matrix;
  final List<double> snfValues;
  final List<double> fatValues;
  final String headText;
  const RateChart({
    super.key,
    required this.matrix,
    required this.snfValues,
    required this.fatValues,
    required this.isSingleType,
    required this.headText,
  });

  @override
  Widget build(BuildContext context) {
    // return matrix.isNotEmpty
    //     ? SingleChildScrollView(
    //         scrollDirection: Axis.horizontal,
    //         child: Table(
    //           border: TableBorder.all(color: Colors.grey),
    //           defaultColumnWidth: FixedColumnWidth(60),
    //           children: [
    //             // Header row
    //             TableRow(
    //               children: [
    //                 TableCell(
    //                   child: Container(
    //                     padding: EdgeInsets.all(8),
    //                     color: Colors.grey[300],
    //                     child: Text(
    //                       "FAT/SNF",
    //                       style: TextStyle(fontWeight: FontWeight.bold),
    //                       textAlign: TextAlign.center,
    //                     ),
    //                   ),
    //                 ),
    //                 ...snfValues.map(
    //                   (snf) => TableCell(
    //                     child: Container(
    //                       padding: EdgeInsets.all(8),
    //                       color: Colors.grey[300],
    //                       child: Text(
    //                         snf.toStringAsFixed(1),
    //                         textAlign: TextAlign.center,
    //                         style: TextStyle(fontWeight: FontWeight.bold),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             // Data rows
    //             ...List.generate(fatValues.length, (i) {
    //               return TableRow(
    //                 children: [
    //                   TableCell(
    //                     child: Container(
    //                       padding: EdgeInsets.all(8),
    //                       color: Colors.grey[200],
    //                       child: Text(
    //                         fatValues[i].toStringAsFixed(1),
    //                         style: TextStyle(fontWeight: FontWeight.bold),
    //                         textAlign: TextAlign.center,
    //                       ),
    //                     ),
    //                   ),
    //                   ...List.generate(
    //                     snfValues.length,
    //                     (j) => TableCell(
    //                       child: Container(
    //                         padding: EdgeInsets.all(8),
    //                         color: Colors.white,
    //                         child: Text(
    //                           matrix[i][j].toStringAsFixed(2),
    //                           textAlign: TextAlign.center,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               );
    //             }),
    //           ],
    //         ),
    //       )
    //     : Center(
    //         child: Column(
    //           children: [
    //             Gap.verticalGap(.13.sh),
    //             Image.asset(
    //               AssetsPaths.notFound,
    //               height: 40.h,
    //               color: AppColors.grey700,
    //             ),
    //             Gap.verticalGap(15),
    //             TextWidget(text: 'No Chart Available'),
    //           ],
    //         ),
    //       );

    return _buildNewTable(isSingleType);
  }

  _buildNewTable(bool isSingleType) {
    if (matrix.isNotEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Table(
            border: TableBorder.symmetric(
              inside: BorderSide(color: AppColors.grey300),
            ),
            defaultColumnWidth: FixedColumnWidth(isSingleType ? 170.w : 45.w),
            children: [
              /// HEADER ROW
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.shade300),
                children: [
                  _headerCell(headText, 9),
                  ...snfValues.map(
                    (s) => _headerCell(s.toStringAsFixed(1), 12),
                  ),
                ],
              ),

              /// DATA ROWS
              ...List.generate(fatValues.length, (i) {
                return TableRow(
                  decoration: BoxDecoration(
                    color: i.isEven ? Colors.grey.shade50 : Colors.white,
                  ),
                  children: [
                    _fatCell(fatValues[i]),
                    ...List.generate(
                      snfValues.length,
                      (j) =>
                          _priceCell(matrix[i][j], fatValues[i], snfValues[j]),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Column(
          children: [
            Gap.verticalGap(.13.sh),
            Image.asset(
              AssetsPaths.notFound,
              height: 40.h,
              color: AppColors.grey700,
            ),
            Gap.verticalGap(15),
            TextWidget(text: 'no_chart_available'),
          ],
        ),
      );
    }
  }

  Widget _headerCell(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Center(
        child: TextWidget(
          text: text,
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w600,
          textColor: AppColors.grey800,
        ),
      ),
    );
  }

  Widget _fatCell(double value) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Center(
        child: TextWidget(
          text: value.toStringAsFixed(1),
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          textColor: AppColors.voilate,
        ),
      ),
    );
  }

  Widget _priceCell(double price, double fat, double snf) {
    return Tooltip(
      richMessage: TextSpan(
        text: 'Price: $price\nFat: $fat  Snf: $snf',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      // message: "Rate: ₹${price.toStringAsFixed(2)}",
      triggerMode: TooltipTriggerMode.tap,
      showDuration: Duration(milliseconds: 2500),

      preferBelow: false,
      decoration: BoxDecoration(
        color: AppColors.grey900,
        borderRadius: BorderRadius.circular(4.r),
      ),
      textStyle: const TextStyle(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Center(
          child: TextWidget(
            text: price.toStringAsFixed(2),
            fontSize: 11.sp,
            textColor: AppColors.grey900,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

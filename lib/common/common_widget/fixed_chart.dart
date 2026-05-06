import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/assets_paths.dart';
import '../../core/utils/gap.dart';

enum CellType { normal, topRow, firstColumn, corner }

class FreezeMatrix extends StatefulWidget {
  final bool isSingleType;
  final List<double> fatValues;
  final List<double> snfValues;
  final List<List<double>> matrix;
  final String headText;

  const FreezeMatrix({
    super.key,
    required this.fatValues,
    required this.snfValues,
    required this.matrix,
    required this.isSingleType,
    required this.headText,
  });

  @override
  State<FreezeMatrix> createState() => _FreezeMatrixState();
}

class _FreezeMatrixState extends State<FreezeMatrix> {
  final ScrollController hBody = ScrollController();
  final ScrollController vBody = ScrollController();

  final ScrollController hHeader = ScrollController();
  final ScrollController vHeader = ScrollController();

  static const double cellW = 40;
  static const double cellH = 25;

  static double fullcellW = 0.47.sw;
  static const double fullcellH = 30;

  @override
  void initState() {
    super.initState();

    // Sync horizontal body → top header
    hBody.addListener(() {
      if (hHeader.hasClients && hHeader.offset != hBody.offset) {
        hHeader.jumpTo(hBody.offset);
      }
    });

    // Sync vertical body → left header
    vBody.addListener(() {
      if (vHeader.hasClients && vHeader.offset != vBody.offset) {
        vHeader.jumpTo(vBody.offset);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.matrix.isEmpty
        ? Center(
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
          )
        : Column(
            children: [
              /// ---------- TOP ROW ----------
              Row(
                children: [
                  widget.matrix.isEmpty
                      ? SizedBox.shrink()
                      : _cell(widget.headText, type: CellType.corner),

                  /// Top header (horizontal only)
                  Expanded(
                    child: SingleChildScrollView(
                      controller: hHeader,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Row(
                        children: widget.snfValues
                            .map(
                              (e) => _cell(e.toString(), type: CellType.topRow),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),

              /// ---------- BODY ----------
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      /// Left column (vertical only)
                      SingleChildScrollView(
                        controller: vHeader,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: widget.fatValues
                              .map(
                                (e) => _cell(
                                  e.toString(),
                                  type: CellType.firstColumn,
                                ),
                              )
                              .toList(),
                        ),
                      ),

                      /// Main body (both directions)
                      Expanded(
                        child: SingleChildScrollView(
                          controller: hBody,
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            controller: vBody,
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: List.generate(
                                widget.matrix.length,
                                (i) => Row(
                                  children: List.generate(
                                    widget.matrix[i].length,
                                    (j) => _cell(
                                      widget.matrix[i][j].toStringAsFixed(1),
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
                ),
              ),
            ],
          );
  }

  // Widget _cell(String text, {bool header = false}) {
  //   return Container(
  //     width: cellW,
  //     height: cellH,
  //     alignment: Alignment.center,
  //     decoration: BoxDecoration(
  //       color: header ? Colors.grey.shade300 : Colors.white,
  //       border: Border.all(color: Colors.grey.shade400),
  //     ),

  //     child: TextWidget(
  //       fontSize: header ? 8.sp : 11.sp,
  //       fontWeight: header ? FontWeight.w700 : FontWeight.w500,
  //       text: text,
  //     ),
  //   );
  // }

  Widget _cell(String text, {CellType type = CellType.normal}) {
    Color bgColor;

    switch (type) {
      case CellType.corner:
        bgColor = AppColors.grey200;
        break;
      case CellType.topRow:
        bgColor = AppColors.grey200;
        break;
      case CellType.firstColumn:
        bgColor = AppColors.grey200;
        break;
      default:
        bgColor = Colors.white;
    }

    return Container(
      width: widget.isSingleType ? fullcellW : cellW,
      height: widget.isSingleType ? fullcellH : cellH,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: AppColors.grey400, width: 0.3),
      ),

      child: TextWidget(
        fontSize: type == CellType.normal ? 10.sp : 7.sp,
        fontWeight: type == CellType.normal ? FontWeight.w500 : FontWeight.w700,
        text: text,
      ),
    );
  }

  @override
  void dispose() {
    hBody.dispose();
    vBody.dispose();
    hHeader.dispose();
    vHeader.dispose();
    super.dispose();
  }
}

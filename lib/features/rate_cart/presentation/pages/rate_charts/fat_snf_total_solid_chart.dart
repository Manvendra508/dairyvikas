import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/common_widget/fixed_chart.dart';
import '../../../../../core/local_datasources/app_state.dart';
import '../../../domain/entities/total_solid_step_entity.dart';
import '../../controllers/add_rate_chart_controller.dart';
import '../../controllers/rate_chart_common_function.dart';
import '../rate_chart_common_widgets/rate_textform_feild.dart';

/// ---------------- SCREEN ----------------
class TotalSolidChartFatSnfPage extends StatefulWidget {
  final bool isFatOnly;

  final List<TotalSolidStep> totalSolidSteps;
  List<double> fatValues;
  List<double> snfValues;
  List<List<double>> matrix;
  TotalSolidChartFatSnfPage({
    super.key,
    required this.isFatOnly,
    required this.totalSolidSteps,
    required this.fatValues,
    required this.matrix,
    required this.snfValues,
  });

  @override
  State<TotalSolidChartFatSnfPage> createState() =>
      TotalSolidChartFatSnfPageState();
}

class TotalSolidChartFatSnfPageState extends State<TotalSolidChartFatSnfPage>
    with CommonMixin {
  RxBool isCreating = false.obs;
  // Controllers
  final fatFromCtrl = TextEditingController();
  final fatToCtrl = TextEditingController();
  final snfFromCtrl = TextEditingController();
  final snfToCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final rateChartCommonFunctionController =
      Get.find<RateChartCommonFunctionController>();

  List<TotalSolidStep> steps = [];
  List<double> fatValues = [];
  List<double> snfValues = [];
  List<List<double>> matrix = [];

  /// ---------------- RANGE ----------------
  List<double> _range(double start, double end) {
    final list = <double>[];
    double v = start;
    while (v <= end + 0.0001) {
      list.add(double.parse(v.toStringAsFixed(1)));
      v += 0.1;
    }
    return list;
  }

  void onSaveMatrix() {
    final addRateChartController = Get.find<AddRateChartController>();

    addRateChartController.getRateChart(
      matrix,
      fatValues,
      snfValues,
      null,
      null,
      null,
      [steps],
    );
  }

  void genrateChart() async {
    if (steps.isEmpty) {
      matrix.clear();
      fatValues.clear();
      snfValues.clear;
      setState(() {});
      return;
    }

    /// 1️⃣ GLOBAL RANGE
    double fatMin = steps.first.fatFrom;
    double fatMax = steps.first.fatTo;
    double snfMin = steps.first.snfOrclrFrom;
    double snfMax = steps.first.snfOrclrTo;

    for (final s in steps) {
      fatMin = fatMin < s.fatFrom ? fatMin : s.fatFrom;
      fatMax = fatMax > s.fatTo ? fatMax : s.fatTo;
      snfMin = snfMin < s.snfOrclrFrom ? snfMin : s.snfOrclrFrom;
      snfMax = snfMax > s.snfOrclrTo ? snfMax : s.snfOrclrTo;
    }

    fatValues = _range(fatMin, fatMax);
    snfValues = _range(snfMin, snfMax);

    /// 2️⃣ PRESERVE OLD VALUES
    final List<List<double>> newTable = List.generate(
      fatValues.length,
      (i) => List.generate(snfValues.length, (j) {
        if (i < matrix.length && j < matrix[i].length) {
          return matrix[i][j];
        }
        return 0.0;
      }),
    );

    /// 3️⃣ APPLY STEPS (LAST STEP WINS)
    for (final step in steps) {
      for (int i = 0; i < fatValues.length; i++) {
        final fat = fatValues[i];
        if (fat < step.fatFrom || fat > step.fatTo) continue;

        for (int j = 0; j < snfValues.length; j++) {
          final snf = snfValues[j];
          if (snf < step.snfOrclrFrom || snf > step.snfOrclrTo) continue;

          final value = (fat * step.rate / 100) + (snf * step.rate / 100);

          newTable[i][j] = double.parse(value.toStringAsFixed(2));
        }
      }
    }

    matrix = newTable;

    setState(() {});
  }

  _resetControllers() {
    fatFromCtrl.clear();
    fatToCtrl.clear();
    snfFromCtrl.clear();
    snfToCtrl.clear();
    rateCtrl.clear();
  }

  void _addStep() {
    bool isValidate = rateChartCommonFunctionController.validateTotalSolid(
      fatFromCtrl.text,
      fatToCtrl.text,
      snfFromCtrl.text,
      snfToCtrl.text,
      rateCtrl.text,
      widget.isFatOnly,
    );
    if (!isValidate) return;
    final fatFrom = double.tryParse(fatFromCtrl.text);
    final fatTo = double.tryParse(fatToCtrl.text);
    final snfFrom = double.tryParse(
      snfFromCtrl.text.isEmpty ? '0.0' : snfFromCtrl.text,
    ); // here chekcing for in case widget.isRateOnly = true
    final snfTo = double.tryParse(
      snfToCtrl.text.isEmpty ? '0.0' : snfToCtrl.text,
    ); // here chekcing for in case widget.isRateOnly = true
    final rate = double.tryParse(rateCtrl.text);

    if ([fatFrom, fatTo, snfFrom, snfTo, rate].contains(null)) return;

    steps.add(
      TotalSolidStep(
        fatFrom: fatFrom!,
        fatTo: fatTo!,
        snfOrclrFrom: snfFrom!,
        snfOrclrTo: snfTo!,
        rate: rate!,
      ),
    );

    genrateChart();
    AppNavigation.goBack();
  }

  void _removeLastStep() {
    if (steps.isNotEmpty) {
      steps.removeLast();
      genrateChart();
    }
  }

  setDataForEditChart() {
    if (!AppState.isRateChartEdit) return;
    fatValues = widget.fatValues;
    snfValues = widget.snfValues;
    fatValues = widget.fatValues;

    steps = widget.totalSolidSteps;

    matrix = widget.matrix;
    setState(() {});
  }

  @override
  void initState() {
    setDataForEditChart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1.sw,

          decoration: BoxDecoration(
            color: AppColors.themeColor.withOpacity(0.8),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.r),
              topRight: Radius.circular(4.r),
            ),
          ),
          child: Visibility(
            visible: !widget.isFatOnly,
            replacement: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTextforHeader('fat_from'),
                _buildverticalDivider(),
                _buildTextforHeader('fat_to'),

                _buildverticalDivider(),
                _buildTextforHeader('rate'),

                _buildverticalDivider(),
                _buildAddButton(),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTextforHeader('fat_from'),
                _buildverticalDivider(),
                _buildTextforHeader('fat_to'),
                _buildverticalDivider(),
                _buildTextforHeader('snf_from'),
                _buildverticalDivider(),
                _buildTextforHeader('snf_to'),
                _buildverticalDivider(),
                _buildTextforHeader('rate'),

                _buildverticalDivider(),
                _buildAddButton(),
              ],
            ),
          ),
        ),
        Container(
          width: 1.sw,

          decoration: BoxDecoration(
            color: AppColors.grey200.withOpacity(0.6),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4.r),
              bottomRight: Radius.circular(4.r),
            ),
          ),
          child: Column(
            children: List.generate(
              steps.length,
              (index) => Column(
                children: [
                  index == 0
                      ? SizedBox.shrink()
                      : Divider(color: AppColors.grey300),
                  Visibility(
                    visible: !widget.isFatOnly,
                    replacement: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTextforValues(steps[index].fatFrom.toString()),
                        _buildverticalDivider(color: AppColors.grey400),
                        _buildTextforValues(steps[index].fatTo.toString()),

                        _buildverticalDivider(color: AppColors.grey400),
                        _buildTextforValues('₹${steps[index].rate}'),
                        _buildverticalDivider(color: AppColors.grey400),
                        _buildRemoveButton(index),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTextforValues(steps[index].fatFrom.toString()),
                        _buildverticalDivider(color: AppColors.grey400),
                        _buildTextforValues(steps[index].fatTo.toString()),
                        _buildverticalDivider(color: AppColors.grey400),
                        _buildTextforValues(
                          steps[index].snfOrclrFrom.toString(),
                        ),
                        _buildverticalDivider(color: AppColors.grey400),
                        _buildTextforValues(steps[index].snfOrclrTo.toString()),
                        _buildverticalDivider(color: AppColors.grey400),
                        _buildTextforValues('₹${steps[index].rate}'),
                        _buildverticalDivider(color: AppColors.grey400),
                        _buildRemoveButton(index),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Gap.verticalGap(20),
        Visibility(
          visible: steps.isNotEmpty,
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: TextWidget(
                  text: 'Rate Chart',
                  textColor: AppColors.grey800,
                  fontSize: 17.sp,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gap.verticalGap(5),
            ],
          ),
        ),

        // RateChart(
        //   matrix: matrix,
        //   snfValues: snfValues,
        //   fatValues: fatValues,
        //   isSingleType: widget.isFatOnly,
        //   headText: widget.isFatOnly ? 'fat' : 'fat_snf',
        // ),
        SizedBox(
          width: 1.sw,
          height: 285.h,
          child: FreezeMatrix(
            fatValues: fatValues,
            snfValues: snfValues,
            isSingleType: widget.isFatOnly,
            matrix: matrix,
            headText: widget.isFatOnly ? 'fat' : 'fat_snf',
          ),
        ),
      ],
    );
  }

  _buildRemoveButton(int index) {
    return Visibility(
      visible: (steps.length - 1) == index,
      replacement: AppIcons.remove(
        size: 13,
        color: AppColors.grey200.withOpacity(0.1),
      ),
      child: InkWell(
        onTap: () => _removeLastStep(),
        child: AppIcons.remove(size: 13),
      ),
    );
  }

  _buildAddButton() {
    return InkWell(
      onTap: () {
        _resetControllers();
        showDragableBottomSheet(
          context,
          _buildAddSolidFatSnfStepForm('add_total_solid_step'),
        );
      },
      child: CommonContainer(
        shadowOpacity: 0.1,
        width: 19.w,
        height: 16.h,
        borderRaduis: 30.r,

        child: Center(
          child: Icon(Icons.add, color: AppColors.blackColor, size: 17),
        ),
      ),
    );
  }

  _buildverticalDivider({Color? color}) {
    return Container(
      width: 0.6.w,
      height: 37.h,
      color: color ?? AppColors.grey100,
    );
  }

  _buildTextforHeader(String title, {Color? textColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: SizedBox(
        width: 40,
        child: TextWidget(
          text: title,
          textColor: textColor ?? AppColors.whiteColor,
          fontSize: 11.sp,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _buildTextforValues(String title, {Color? textColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: SizedBox(
        width: 36,
        child: TextWidget(
          text: title,
          textColor: textColor ?? AppColors.grey800,
          fontSize: 11.sp,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _buildAddSolidFatSnfStepForm(String heading) {
    return SizedBox(
      width: 1.sw,
      height: widget.isFatOnly ? 243.h : 300.h,
      child: Column(
        children: [
          Gap.verticalGap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget(
                text: heading,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          Gap.verticalGap(3),
          Divider(thickness: 0.5),
          Gap.verticalGap(6),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DecimalTextformFeild(
                          controller: fatFromCtrl,
                          lable: 'fat_from2',
                          hint: '0.0',
                          fieldWidth: 1.sw / 2.3,
                        ),

                        DecimalTextformFeild(
                          controller: fatToCtrl,
                          lable: 'fat_to2',
                          hint: '0.0',
                          fieldWidth: 1.sw / 2.3,
                        ),
                      ],
                    ),
                    Gap.verticalGap(6.h),
                    Visibility(
                      visible: !widget.isFatOnly,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DecimalTextformFeild(
                            controller: snfFromCtrl,
                            lable: 'snf_from2',
                            hint: '0.0',
                            fieldWidth: 1.sw / 2.3,
                          ),

                          DecimalTextformFeild(
                            controller: snfToCtrl,
                            lable: 'snf_to2',
                            hint: '0.0',
                            fieldWidth: 1.sw / 2.3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap.verticalGap(8),
                DecimalTextformFeild(
                  controller: rateCtrl,
                  lable: 'rate',
                  hint: '0.0',
                  fieldWidth: 1.sw,
                ),

                InkWell(
                  onTap: () => _addStep(),
                  child: AppButton(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    buttonHeight: 45.h,

                    buttonFontWeight: FontWeight.w600,
                    title: 'add',

                    isLoading: isCreating,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

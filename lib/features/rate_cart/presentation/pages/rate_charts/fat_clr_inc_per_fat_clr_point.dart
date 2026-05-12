import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/app_regex.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/rate_cart/domain/entities/increase_step_entity.dart';
import 'package:DairyVikas/features/rate_cart/presentation/controllers/rate_chart_common_function.dart';
import 'package:DairyVikas/features/rate_cart/presentation/pages/rate_chart_common_widgets/rate_textform_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/common_widget/fixed_chart.dart';
import '../../controllers/add_rate_chart_controller.dart';
import '../rate_chart_common_widgets/step_header.dart';

List<double> generateAutoPoints(double start, double end, double step) {
  final values = <double>[];
  double current = start;
  while (current <= end + 0.0001) {
    values.add(double.parse(current.toStringAsFixed(1)));
    current += step;
  }
  return values;
}

List<double> generateRangeValues({
  required double from,
  required double to,
  required double step,
}) {
  final values = <double>[];

  double current = from;

  while (current <= to + 0.0001) {
    values.add(double.parse(current.toStringAsFixed(1)));
    current += step;
  }

  return values;
}

double calculateIncreasePrice({
  required double basePrice,
  required double fat,
  required double clr,
  required double baseFat,
  required double baseClr,
  required double fatIncrease,
  required double clrIncrease,
}) {
  final fatSteps = ((fat - baseFat) / 0.1).round();
  final clrSteps = ((clr - baseClr) / 0.1).round();

  return double.parse(
    (basePrice + (fatSteps * fatIncrease) + (clrSteps * clrIncrease))
        .toStringAsFixed(2),
  );
}

class IncreaseFatClrPerFatClrChartScreen extends StatefulWidget {
  final bool isCrlOnly;
  final List<IncreaseStep> fatSteps;
  final List<IncreaseStep> clrSteps;

  /// GENERATED
  final List<double> fatValues;
  final List<double> clrValues;
  final List<List<double>> matrix;
  const IncreaseFatClrPerFatClrChartScreen({
    super.key,
    required this.isCrlOnly,
    required this.fatSteps,
    required this.clrSteps,
    required this.fatValues,
    required this.clrValues,
    required this.matrix,
  });

  @override
  State<IncreaseFatClrPerFatClrChartScreen> createState() =>
      IncreaseFatClrChartScreenState();
}

class IncreaseFatClrChartScreenState
    extends State<IncreaseFatClrPerFatClrChartScreen>
    with CommonMixin {
  final rateChartCommonFunctionController =
      Get.find<RateChartCommonFunctionController>();

  /// BASE CONFIG
  final basePriceController = TextEditingController(text: "30");

  /// STEP INPUT
  final fatStepController = TextEditingController();
  final fatAmountController = TextEditingController();

  final clrStepController = TextEditingController();
  final clrAmountController = TextEditingController();

  /// CLR STEP OPTION
  double clrIncreaseStep = 1.0;
  double baseClr = 20.0;

  /// STEPS
  List<IncreaseStep> fatSteps = [];
  List<IncreaseStep> clrSteps = [];

  /// GENERATED
  List<double> fatValues = [];
  List<double> clrValues = [];
  List<List<double>> matrix = [];

  resetControllers() {
    fatStepController.clear();
    fatAmountController.clear();
    clrStepController.clear();
    clrAmountController.clear();
  }

  void onSaveMatrix() {
    final addRateChartController = Get.find<AddRateChartController>();

    addRateChartController.getRateChart(
      matrix,
      fatValues,
      null,
      clrValues,
      null,
      null,
      widget.isCrlOnly ? [clrSteps] : [fatSteps, clrSteps],
    );
  }

  void addFatStep() {
    final step = double.tryParse(fatStepController.text);
    final amount = double.tryParse(fatAmountController.text);
    if (step != null && amount != null) {
      setState(() => fatSteps.add(IncreaseStep(point: step, amount: amount)));
    }
  }

  void addClrStep() {
    final step = double.tryParse(clrStepController.text);
    final amount = double.tryParse(clrAmountController.text);
    if (step != null && amount != null) {
      setState(() => clrSteps.add(IncreaseStep(point: step, amount: amount)));
    }
  }

  void removeLastFat() {
    setState(() {
      if (fatSteps.isNotEmpty) fatSteps.removeLast();
      if (fatSteps.isEmpty || clrSteps.isEmpty) clearChart();
    });
  }

  void removeLastClr() {
    setState(() {
      if (clrSteps.isNotEmpty) clrSteps.removeLast();
      if (fatSteps.isEmpty || clrSteps.isEmpty) clearChart();
    });
  }

  void clearChart() {
    fatValues.clear();
    clrValues.clear();
    matrix.clear();
  }

  /// --------------------
  /// CHART GENERATION
  /// --------------------
  void generateChart() async {
    if (widget.isCrlOnly) {
      if (clrSteps.isEmpty) {
        fatValues.clear();
        clrValues.clear();
        matrix.clear();
        return;
      }
    } else {
      if (fatSteps.isEmpty || clrSteps.isEmpty) {
        fatValues.clear();
        clrValues.clear();
        matrix.clear();
        return;
      }
    }

    final basePrice = double.parse(basePriceController.text);

    // FAT points from steps
    // fatValues = widget.isCrlOnly
    //     ? [0.0]
    //     : fatSteps.map((e) => e.point).toList();

    // // CLR points from steps using selected step increment
    // final clrMax = clrSteps.last.point;
    // clrValues = generateAutoPoints(baseClr, clrMax, clrIncreaseStep);

    fatValues = generateRangeValues(
      from: fatSteps.first.point, // 2.0
      to: fatSteps.last.point, // 3.0
      step: 0.1, // or 0.5
    );

    clrValues = widget.isCrlOnly
        ? [0.0]
        : generateRangeValues(
            from: clrSteps.first.point,
            to: clrSteps.last.point,
            step: clrIncreaseStep,
          );

    // Matrix initialize
    matrix = [];

    final double fatIncrement = fatSteps.first.amount;
    final double snfIncrement = widget.isCrlOnly ? 0.0 : clrSteps.first.amount;

    for (int i = 0; i < fatValues.length; i++) {
      final row = <double>[];

      for (int j = 0; j < clrValues.length; j++) {
        double price;

        if (i == 0 && j == 0) {
          // Base cell
          price = basePrice;
        } else if (i == 0) {
          // SNF increase
          price = row[j - 1] + snfIncrement;
        } else if (j == 0) {
          // FAT increase
          price = matrix[i - 1][j] + fatIncrement;
        } else {
          // FAT increase from top
          price = matrix[i - 1][j] + fatIncrement;
        }

        row.add(double.parse(price.toStringAsFixed(2)));
      }

      matrix.add(row);
    }

    // for (int i = 0; i < fatValues.length; i++) {
    //   final row = <double>[];

    //   for (int j = 0; j < clrValues.length; j++) {
    //     double price;

    //     if (i == 0 && j == 0) {
    //       price = basePrice;
    //     } else if (i == 0) {
    //       // First row → CLR increase only
    //       price = row[j - 1] + clrSteps.last.amount;
    //     } else if (j == 0) {
    //       // First column → FAT increase only
    //       price = matrix[i - 1][j] + fatSteps[i - 1].amount;
    //     } else {
    //       // Inner cells → FAT increase from top cell
    //       price = matrix[i - 1][j] + fatSteps[i - 1].amount;
    //     }

    //     row.add(price);
    //   }

    //   matrix.add(row);
    // }

    setState(() {});
  }

  removeStep(bool isFatStep) {
    if (isFatStep) {
      removeLastFat();
    } else {
      removeLastClr();
    }
    generateChart();
  }

  addstep(bool isFatStep) {
    bool isValidate = rateChartCommonFunctionController.fatClrRangeValidate(
      fatStepController.text,
      clrStepController.text,
      isFatStep,
      isFatStep ? fatAmountController.text : clrAmountController.text,
    );
    if (isValidate) {
      bool isDuplicateFound = rateChartCommonFunctionController
          .checkifStepIsDuplicateOrLess(
            isFatStep,
            fatSteps,
            clrSteps,
            fatStepController.text,
            clrStepController.text,
            true,
          );
      if (isDuplicateFound) return;
      if (isFatStep) {
        addFatStep();
      } else {
        addClrStep();
      }
      generateChart();
      AppNavigation.goBack();
    }
  }

  headerCallback(bool isFatStep, String heading) {
    resetControllers();

    showDragableBottomSheet(
      context,
      _buildAddFatClrStepForm(isFatStep, heading),
    );
  }

  setDataForEditChart() {
    if (!AppState.isRateChartEdit) return;
    fatValues = widget.fatValues;
    clrValues = widget.clrValues;

    fatSteps = widget.fatSteps;
    clrSteps = widget.clrSteps;
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSteps(),

        Gap.verticalGap(30.h),

        // RateChart(
        //   matrix: matrix,
        //   snfValues: clrValues,
        //   fatValues: fatValues,
        //   isSingleType: false,
        //   headText: widget.isCrlOnly ? 'clr' : 'fat_clr',
        // ),
        SizedBox(
          width: 1.sw,
          height: 285.h,
          child: FreezeMatrix(
            fatValues: fatValues,
            isSingleType: false,
            snfValues: clrValues,
            matrix: matrix,
            headText: widget.isCrlOnly ? 'clr' : 'fat_clr',
          ),
        ),
      ],
    );
  }

  _buildSteps() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// FAT COLUMN
        Visibility(
          visible: !widget.isCrlOnly,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFatClrStepsContainer(
                'add_fat_step',
                fatSteps,

                true,
                'add_fat_step',
              ),
            ],
          ),
        ),

        /// Clr COLUMN
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFatClrStepsContainer(
              'add_clr_step',
              clrSteps,

              false,
              'add_clr_step',
            ),
          ],
        ),
      ],
    );
  }

  _buildFatClrStepsContainer(
    String title,
    List<IncreaseStep> steps,

    bool isFatStep,
    String heading,
  ) {
    return Column(
      children: [
        // _buildHeader(title, AppColors.themeColor, 5.r, isFatStep, heading),
        StepHeader(
          isOnly: widget.isCrlOnly,
          bgColor: AppColors.themeColor,
          title: title,
          radius: 5.r,
          callback: () => headerCallback(isFatStep, heading),
        ),
        Container(
          width: widget.isCrlOnly ? 1.sw / 1.06 : 1.sw / 2.2,

          decoration: BoxDecoration(color: AppColors.grey200),
          child: Column(
            children: List.generate(steps.length, (index) {
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 7.h : 0.h),
                child: Column(
                  children: [
                    Gap.verticalGap(2),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              TextWidget(
                                text: steps[index].point.toString(),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                textColor: AppColors.grey900,
                              ),
                              Gap.horizentalGap(8),
                              AppIcons.arrowForwardRange(
                                size: 18,
                                color: AppColors.themeColor,
                              ),
                              Gap.horizentalGap(8),
                              TextWidget(
                                text: '₹${steps[index].amount}',
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                textColor: AppColors.grey900,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: (steps.length - 1) == index,
                                child: InkWell(
                                  onTap: () => removeStep(isFatStep),
                                  child: AppIcons.remove(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !((steps.length - 1) == index),
                      replacement: Gap.verticalGap(8),
                      child: Divider(thickness: 0.4),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  _buildHeader(
    String title,
    Color bgColor,
    double? radius,

    bool isFatStep,
    String heading,
  ) {
    return Container(
      width: widget.isCrlOnly ? 1.sw / 1.06 : 1.sw / 2.2,
      height: 35,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius ?? 0.r),
          topRight: Radius.circular(radius ?? 0.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: title,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              textColor: AppColors.whiteColor,
            ),
            InkWell(
              onTap: () {
                resetControllers();

                showDragableBottomSheet(
                  context,
                  _buildAddFatClrStepForm(isFatStep, heading),
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
            ),
          ],
        ),
      ),
    );
  }

  _buildAddFatClrStepForm(bool isFatStep, String heading) {
    return SizedBox(
      width: 1.sw,
      height: isFatStep ? 260.h : 290.h,
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
                Visibility(
                  visible: !isFatStep,
                  child: _buildDropdownField(hint: ''),
                ),
                Gap.verticalGap(8),
                _buildTextFormFiedForBaseAmount(
                  basePriceController,
                  '0.0',
                  'base_amount',
                  1.sw,
                ),

                Gap.verticalGap(15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DecimalTextformFeild(
                      controller: isFatStep
                          ? fatStepController
                          : clrStepController,
                      lable: 'step',
                      hint: '0.0',
                      fieldWidth: 1.sw / 2.3,
                    ),

                    DecimalTextformFeild(
                      controller: isFatStep
                          ? fatAmountController
                          : clrAmountController,
                      lable: 'amount',
                      hint: '0.0',
                      fieldWidth: 1.sw / 2.3,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap.verticalGap(8.h),
          InkWell(
            onTap: () => addstep(isFatStep),
            child: AppButton(
              margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
              buttonHeight: 45.h,
              shadowOpacity: 0.3,
              buttonFontWeight: FontWeight.w600,
              title: 'add',
              isLoading: false.obs,
            ),
          ),
        ],
      ),
    );
  }

  _buildDropdownField({required String hint}) {
    return StatefulBuilder(
      builder: (context, setstate) {
        return Container(
          width: 1.sw,
          height: 35.h,

          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 7.w),
          decoration: BoxDecoration(
            color: AppColors.whiteColor.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(width: 0.8, color: AppColors.lightBorder),
          ),

          child: DropdownButtonHideUnderline(
            child: DropdownButton<double>(
              isExpanded: true,
              value: clrIncreaseStep,
              items: [1.0, 0.5].map((item) {
                return DropdownMenuItem(
                  value: item,

                  child: TextWidget(
                    text: item.toString(),
                    textColor: AppColors.grey800,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),

              onChanged: (value) {
                if (value == null) return;
                clrIncreaseStep = value;
                AppState.clrIncreaseStep = value;
                setstate(() {});
              },
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.grey600),
            ),
          ),
        );
      },
    );
  }

  _buildTextFormFiedForStep(
    TextEditingController controller,
    String hint,
    String lable,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(text: lable, fontWeight: FontWeight.w500),
        Gap.verticalGap(3),
        SizedBox(
          width: 1.sw / 2.3,
          height: 35.h,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: controller,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            inputFormatters: [
              FilteringTextInputFormatter.allow(AppRegex.onlyNumber),
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.5.h,
                horizontal: 7.w,
              ),
              focusedBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              hint: TextWidget(text: hint, textColor: AppColors.textLight),
            ),
          ),
        ),
      ],
    );
  }

  _buildTextFormFiedForBaseAmount(
    TextEditingController controller,
    String hint,
    String lable,
    double width,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(text: lable, fontWeight: FontWeight.w500),
        Gap.verticalGap(3),
        SizedBox(
          width: width,
          height: 35.h,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: controller,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            onChanged: (value) =>
                AppState.baseAmount = double.tryParse(value) ?? 0.0,
            inputFormatters: [
              FilteringTextInputFormatter.allow(AppRegex.onlyNumber),
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.5.h,
                horizontal: 7.w,
              ),
              focusedBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              hint: TextWidget(text: hint, textColor: AppColors.textLight),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/common_container.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart' show AppState;
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/app_regex.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/rate_cart/domain/entities/increase_step_entity.dart';
import 'package:dairysathi/features/rate_cart/presentation/controllers/add_rate_chart_controller.dart';
import 'package:dairysathi/features/rate_cart/presentation/controllers/rate_chart_common_function.dart';
import 'package:dairysathi/features/rate_cart/presentation/pages/rate_chart_common_widgets/rate_textform_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/common_widget/fixed_chart.dart';
import '../rate_chart_common_widgets/step_header.dart';

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
  required double snf,
  required double baseFat,
  required double baseSnf,
  required double fatIncrease,
  required double snfIncrease,
}) {
  final fatSteps = ((fat - baseFat) / 0.1).round();
  final snfSteps = ((snf - baseSnf) / 0.1).round();

  return double.parse(
    (basePrice + (fatSteps * fatIncrease) + (snfSteps * snfIncrease))
        .toStringAsFixed(2),
  );
}

class IncreaseFatSnfChartScreenPerFatSnfPoint extends StatefulWidget
    with CommonMixin {
  final bool isFatOnly;
  final List<IncreaseStep> fatSteps;
  final List<IncreaseStep> snfSteps;

  /// GENERATED
  final List<double> fatValues;
  final List<double> snfValues;
  final List<List<double>> matrix;

  const IncreaseFatSnfChartScreenPerFatSnfPoint({
    super.key,
    required this.isFatOnly,
    required this.fatSteps,
    required this.snfSteps,
    required this.fatValues,
    required this.snfValues,
    required this.matrix,
  });

  @override
  State<IncreaseFatSnfChartScreenPerFatSnfPoint> createState() =>
      IncreaseFatSnfChartScreenPerFatSnfPointState();
}

class IncreaseFatSnfChartScreenPerFatSnfPointState
    extends State<IncreaseFatSnfChartScreenPerFatSnfPoint>
    with CommonMixin {
  final rateChartCommonFunctionController =
      Get.find<RateChartCommonFunctionController>();

  /// BASE CONFIG
  final basePriceController = TextEditingController(text: "30");

  /// STEP INPUT
  final fatStepController = TextEditingController();
  final fatIncreaseController = TextEditingController();

  final snfStepController = TextEditingController();
  final snfIncreaseController = TextEditingController();

  /// STEPS
  List<IncreaseStep> fatSteps = [];
  List<IncreaseStep> snfSteps = [];

  /// GENERATED
  List<double> fatValues = [];
  List<double> snfValues = [];
  List<List<double>> matrix = [];

  resetControllers() {
    fatStepController.clear();
    fatIncreaseController.clear();
    snfStepController.clear();
    snfIncreaseController.clear();
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
      widget.isFatOnly ? [fatSteps] : [fatSteps, snfSteps],
    );
  }

  /// --------------------
  /// STEP MANAGEMENT
  /// --------------------
  void addFatStep() {
    final p = double.tryParse(fatStepController.text);
    final a = double.tryParse(fatIncreaseController.text);
    if (p != null && a != null) {
      setState(() => fatSteps.add(IncreaseStep(point: p, amount: a)));
    }
  }

  void addSnfStep() {
    final p = double.tryParse(snfStepController.text);
    final a = double.tryParse(snfIncreaseController.text);
    if (p != null && a != null) {
      setState(() => snfSteps.add(IncreaseStep(point: p, amount: a)));
    }
  }

  void removeLastFat() {
    setState(() {
      if (fatSteps.isNotEmpty) fatSteps.removeLast();
      if (fatSteps.isEmpty || snfSteps.isEmpty) clearChart();
    });
  }

  void removeLastSnf() {
    setState(() {
      if (snfSteps.isNotEmpty) snfSteps.removeLast();
      if (fatSteps.isEmpty || snfSteps.isEmpty) clearChart();
    });
  }

  void clearChart() {
    fatValues.clear();
    snfValues.clear();
    matrix.clear();
  }

  void generateChart() async {
    if (widget.isFatOnly) {
      if (fatSteps.isEmpty) {
        fatValues.clear();
        snfValues.clear();
        matrix.clear();
        return;
      }
    } else {
      if (fatSteps.isEmpty || snfSteps.isEmpty) {
        fatValues.clear();
        snfValues.clear();
        matrix.clear();
        return;
      }
    }

    final basePrice = double.parse(basePriceController.text);

    // FAT और SNF points
    // fatValues = fatSteps.map((e) => e.point).toList();
    // snfValues = widget.isFatOnly
    //     ? [0.0]
    //     : snfSteps.map((e) => e.point).toList();

    fatValues = generateRangeValues(
      from: fatSteps.first.point, // 2.0
      to: fatSteps.last.point, // 3.0
      step: 0.1, // or 0.5
    );

    snfValues = widget.isFatOnly
        ? [0.0]
        : generateRangeValues(
            from: snfSteps.first.point,
            to: snfSteps.last.point,
            step: 0.1,
          );

    // Matrix initialize
    matrix = [];

    final double fatIncrement = fatSteps.first.amount;
    final double snfIncrement = widget.isFatOnly ? 0.0 : snfSteps.first.amount;

    for (int i = 0; i < fatValues.length; i++) {
      final row = <double>[];

      for (int j = 0; j < snfValues.length; j++) {
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

    //   for (int j = 0; j < snfValues.length; j++) {
    //     double price;

    //     if (i == 0 && j == 0) {
    //       // Base cell
    //       price = basePrice;
    //     } else if (i == 0) {
    //       // First row → SNF increase only
    //       price = row[j - 1] + snfSteps[j - 1].amount;
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
      removeLastSnf();
    }
    generateChart();
  }

  addstep(bool isFatStep) {
    bool isValidate = rateChartCommonFunctionController.fatSnfRangeValidate(
      fatStepController.text,
      snfStepController.text,
      isFatStep,
      isFatStep ? fatIncreaseController.text : snfIncreaseController.text,
    );
    if (isValidate) {
      bool isDuplicateFound = rateChartCommonFunctionController
          .checkifStepIsDuplicateOrLess(
            isFatStep,
            fatSteps,
            snfSteps,
            fatStepController.text,
            snfStepController.text,
            false,
          );
      if (isDuplicateFound) return;
      if (isFatStep) {
        addFatStep();
      } else {
        addSnfStep();
      }
      generateChart();
      AppNavigation.goBack();
    }
  }

  headerCallback(bool isFatStep, String heading) {
    resetControllers();

    showDragableBottomSheet(
      context,
      _buildAddFatSnfStepForm(isFatStep, heading),
    );
  }

  setDataForEditChart() {
    if (!AppState.isRateChartEdit) return;
    fatValues = widget.fatValues;
    snfValues = widget.snfValues;

    fatSteps = widget.fatSteps;
    snfSteps = widget.snfSteps;
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
            matrix: matrix,
            isSingleType: widget.isFatOnly,
            headText: widget.isFatOnly ? 'fat' : 'fat_snf',
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFatSnfStepsContainer(
              'add_fat_step',
              fatSteps,

              true,
              'add_fat_step',
            ),
          ],
        ),

        /// SNF COLUMN
        Visibility(
          visible: !widget.isFatOnly,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFatSnfStepsContainer(
                'add_snf_step',
                snfSteps,

                false,
                'add_snf_step',
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildFatSnfStepsContainer(
    String title,
    List<IncreaseStep> steps,

    bool isFatStep,
    String heading,
  ) {
    return Column(
      children: [
        //   _buildHeader(title, AppColors.themeColor, 5.r, isFatStep, heading),
        StepHeader(
          isOnly: widget.isFatOnly,
          bgColor: AppColors.themeColor,
          title: title,
          radius: 5.r,
          callback: () => headerCallback(isFatStep, heading),
        ),
        Container(
          width: widget.isFatOnly ? 1.sw / 1.06 : 1.sw / 2.2,

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
      width: widget.isFatOnly ? 1.sw / 1.06 : 1.sw / 2.2,
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
                  _buildAddFatSnfStepForm(isFatStep, heading),
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

  _buildAddFatSnfStepForm(bool isFatStep, String heading) {
    return SizedBox(
      width: 1.sw,
      height: 260.h,
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
                          : snfStepController,
                      lable: 'step',
                      hint: '0.0',
                      fieldWidth: 1.sw / 2.3,
                    ),

                    DecimalTextformFeild(
                      controller: isFatStep
                          ? fatIncreaseController
                          : snfIncreaseController,
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

import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/rate_cart/domain/entities/bonus_penality_step_entity.dart';
import 'package:DairyVikas/features/rate_cart/domain/entities/rate_step_entity.dart';
import 'package:DairyVikas/features/rate_cart/presentation/controllers/rate_chart_common_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/common_widget/fixed_chart.dart';
import '../../../../../core/local_datasources/app_state.dart';
import '../../controllers/add_rate_chart_controller.dart';
import '../rate_chart_common_widgets/bonus_penality_radio_button.dart';
import '../rate_chart_common_widgets/rate_textform_feild.dart';
import '../rate_chart_common_widgets/step_header.dart';

// Helper functions
List<double> generateValues(double start, double end, double step) {
  final values = <double>[];
  double current = start;
  while (current <= end + 0.0001) {
    values.add(double.parse(current.toStringAsFixed(1)));
    current += step;
  }
  return values;
}

double calculateRate(double value, double ratePaisa) =>
    double.parse((value * ratePaisa / 100).toStringAsFixed(2));

double applyBonusPenalty(
  double value,
  double baseRate,
  List<BonusPenaltyStep> steps,
) {
  double result = baseRate;
  for (final step in steps) {
    if (value >= step.start && value <= step.end) {
      result += step.isBonus ? step.amount : -step.amount;
    }
  }
  return double.parse(result.toStringAsFixed(2));
}

List<List<double>> generateMatrix({
  required List<double> fatValues,
  required List<double> clrValues,
  required List<RateStep> fatSteps,
  required List<RateStep> clrSteps,
  required List<BonusPenaltyStep> fatBonus,
  required List<BonusPenaltyStep> clrBonus,
}) {
  List<List<double>> matrix = [];

  for (final fat in fatValues) {
    List<double> row = [];
    for (final clr in clrValues) {
      double fatRate = 0;
      for (final step in fatSteps) {
        if (fat >= step.start && fat <= step.end) fatRate = step.ratePaisa;
      }

      double clrRate = 0;
      for (final step in clrSteps) {
        if (clr >= step.start && clr <= step.end) clrRate = step.ratePaisa;
      }

      double value = calculateRate(fat, fatRate) + calculateRate(clr, clrRate);

      if (fatSteps.isNotEmpty) value = applyBonusPenalty(fat, value, fatBonus);
      if (clrSteps.isNotEmpty) value = applyBonusPenalty(clr, value, clrBonus);

      row.add(value);
    }
    matrix.add(row);
  }

  return matrix;
}

// Main Widget
class FatClrRatePerKg extends StatefulWidget {
  final bool isCrlOnly;
  final List<List<double>> matrix;
  final List<double> fatValues;
  final List<double> clrValues;
  final List<RateStep> fatSteps;
  final List<RateStep> clrSteps;
  final List<BonusPenaltyStep> fatBonus;
  final List<BonusPenaltyStep> clrBonus;
  const FatClrRatePerKg({
    super.key,
    required this.isCrlOnly,
    required this.matrix,
    required this.fatValues,
    required this.clrValues,
    required this.fatSteps,
    required this.clrSteps,
    required this.fatBonus,
    required this.clrBonus,
  });

  @override
  FatClrRatePerKgState createState() => FatClrRatePerKgState();
}

class FatClrRatePerKgState extends State<FatClrRatePerKg> with CommonMixin {
  final rateChartCommonFunctionController =
      Get.find<RateChartCommonFunctionController>();
  // Controllers
  final fatStartController = TextEditingController();
  final fatEndController = TextEditingController();
  final fatRateController = TextEditingController();

  final clrStartController = TextEditingController();
  final clrEndController = TextEditingController();
  final clrRateController = TextEditingController();

  final bonusStartController = TextEditingController();
  final bonusEndController = TextEditingController();
  final bonusAmountController = TextEditingController();

  double clrIncreaseStep = 1.0;
  RxBool isBonus = true.obs;

  bool applyBonusPenalityForFat = true;

  List<RateStep> fatSteps = [];
  List<RateStep> clrSteps = [];
  List<BonusPenaltyStep> fatBonus = [];
  List<BonusPenaltyStep> clrBonus = [];

  List<double> fatValues = [];
  List<double> clrValues = [];
  List<List<double>> matrix = [];

  resetControllers() {
    fatStartController.clear();
    fatEndController.clear();
    fatRateController.clear();
    clrStartController.clear();
    clrEndController.clear();
    clrRateController.clear();
    bonusStartController.clear();
    bonusEndController.clear();
    bonusAmountController.clear();
  }

  void onSaveMatrix() {
    final addRateChartController = Get.find<AddRateChartController>();

    addRateChartController.getRateChart(
      matrix,
      fatValues,
      null,
      clrValues,
      fatBonus,
      clrBonus,

      widget.isCrlOnly ? [clrSteps] : [fatSteps, clrSteps],
    );
  }

  void addFatStep() {
    final start = double.tryParse(fatStartController.text);
    final end = double.tryParse(fatEndController.text);
    double? rate = double.tryParse(fatRateController.text);
    if (start != null && end != null && rate != null) {
      if (rate < 10 && rate > 0) {
        rate = rate * 100;
      }
      setState(() {
        fatSteps.add(RateStep(start: start, end: end, ratePaisa: rate!));
        generateChart();
      });
    }
  }

  void addClrStep() {
    final start = double.tryParse(clrStartController.text);
    final end = double.tryParse(clrEndController.text);
    double? rate = double.tryParse(clrRateController.text);
    if (start != null && end != null && rate != null) {
      if (rate < 10 && rate > 0) {
        rate = rate * 100;
      }
      setState(() {
        clrSteps.add(RateStep(start: start, end: end, ratePaisa: rate!));
        generateChart();
      });
    }
  }

  void addBonusPenalty() {
    final start = double.tryParse(bonusStartController.text);
    final end = double.tryParse(bonusEndController.text);
    final amount = double.tryParse(bonusAmountController.text);
    if (start != null && end != null && amount != null) {
      setState(() {
        final step = BonusPenaltyStep(
          start: start,
          end: end,
          amount: amount,
          isBonus: isBonus.value,
        );
        if (applyBonusPenalityForFat) {
          fatBonus.add(step);
        } else {
          clrBonus.add(step);
        }
        generateChart();
      });
    }
  }

  void removeLastFatStep() => setState(() {
    if (fatSteps.isNotEmpty) fatSteps.removeLast();
    generateChart();
  });

  void removeLastClrStep() => setState(() {
    if (clrSteps.isNotEmpty) clrSteps.removeLast();
    generateChart();
  });

  void removeLastBonusPenalty(bool isFat) {
    setState(() {
      if (isFat && fatBonus.isNotEmpty) {
        fatBonus.removeLast();
      } else if (!isFat && clrBonus.isNotEmpty) {
        clrBonus.removeLast();
      }
      generateChart();
    });
  }

  void generateChart() async {
    if (fatSteps.isEmpty && clrSteps.isEmpty) {
      fatValues.clear();
      clrValues.clear();
      matrix.clear();
      setState(() {});
      return;
    }

    fatValues = fatSteps.isNotEmpty
        ? generateValues(fatSteps.first.start, fatSteps.last.end, 0.1)
        : [0.0];

    clrValues = clrSteps.isNotEmpty
        ? generateValues(
            clrSteps.first.start,
            clrSteps.last.end,
            clrIncreaseStep,
          )
        : [0.0];

    matrix = generateMatrix(
      fatValues: fatValues,
      clrValues: clrValues,
      fatSteps: fatSteps,
      clrSteps: clrSteps,
      fatBonus: fatBonus,
      clrBonus: clrBonus,
    );

    setState(() {});
  }

  removeFatOrClrStep(bool isFatStep) {
    if (isFatStep) {
      removeLastFatStep();
    } else {
      removeLastClrStep();
    }
    generateChart();
  }

  addStep(bool isFatStep) {
    bool isValidate = rateChartCommonFunctionController
        .rangeValidationForFatandClr(
          fatStartController.text,
          fatEndController.text,
          clrStartController.text,
          clrEndController.text,
          isFatStep ? fatRateController.text : clrRateController.text,
          isFatStep,
        );
    if (!isValidate) return;
    if (isFatStep) {
      addFatStep();
    } else {
      addClrStep();
    }

    AppNavigation.goBack();
  }

  headerCallback(bool isFatStep, bool isFromSteps, String heading) {
    resetControllers();
    if (isFatStep) {
      applyBonusPenalityForFat = true;
      if (fatValues.length > 1) {
        String fatNewStartValue = (fatValues.last + 0.1).toString();
        fatStartController.text = fatNewStartValue;
      }
    } else {
      applyBonusPenalityForFat = false;
      if (clrValues.length > 1) {
        String clrNewStartValue = (clrValues.last + 0.1).toString();
        clrStartController.text = clrNewStartValue;
      }
    }
    showDragableBottomSheet(
      context,
      _buildAddFatClrStepForm(isFromSteps, isFatStep, heading),
    );
  }

  setDataForEditChart() {
    if (!AppState.isRateChartEdit) return;
    fatValues = widget.fatValues;
    clrValues = widget.clrValues;
    fatBonus = widget.fatBonus;
    clrBonus = widget.clrBonus;
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
        Gap.verticalGap(30),

        // Table
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
            snfValues: clrValues,
            isSingleType: false,
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
                <double>[],
                true,
                'add_fat_step',
              ),

              if (fatSteps.isNotEmpty)
                _buildBonusPenalityContainer(
                  'bonus_penalty',
                  fatBonus,
                  'bonus_penalty_on_fat',
                  true,
                ),
            ],
          ),
        ),

        /// CLR COLUMN
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFatClrStepsContainer(
              'add_clr_step',
              clrSteps,
              <double>[],
              false,
              'add_clr_step',
            ),

            if (clrSteps.isNotEmpty)
              _buildBonusPenalityContainer(
                'bonus_penalty',
                clrBonus,
                'bonus_penalty_on_clr',
                false,
              ),
          ],
        ),
      ],
    );
  }

  _buildFatClrStepsContainer(
    String title,
    List<RateStep> steps,
    List<double> bonusPenality,
    bool isFatStep,
    String heading,
  ) {
    return Column(
      children: [
        // _buildHeader(
        //   title,
        //   AppColors.themeColor,
        //   5.r,
        //   true,
        //   isFatStep,
        //   heading,
        // ),
        StepHeader(
          isOnly: widget.isCrlOnly,
          bgColor: AppColors.themeColor,
          title: title,
          radius: 5.r,
          callback: () => headerCallback(isFatStep, true, heading),
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
                                text: steps[index].start.toString(),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                textColor: AppColors.grey900,
                              ),
                              Gap.horizentalGap(4),
                              AppIcons.arrowForwardRange(
                                size: 18,
                                color: AppColors.themeColor,
                              ),
                              Gap.horizentalGap(4),
                              TextWidget(
                                text: steps[index].end.toString(),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                textColor: AppColors.grey900,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextWidget(
                                text: steps[index].ratePaisa.toString(),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                textColor: AppColors.grey900,
                              ),
                              Gap.horizentalGap(7),
                              Visibility(
                                visible: (steps.length - 1) == index,
                                child: InkWell(
                                  onTap: () => removeFatOrClrStep(isFatStep),
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

  _buildBonusPenalityContainer(
    String title,
    List<BonusPenaltyStep> bonuspenality,
    String heading,
    bool isFatStep,
  ) {
    return Column(
      children: [
        //   _buildHeader(title, AppColors.grey700, 0.r, false, isFatStep, heading),
        StepHeader(
          isOnly: widget.isCrlOnly,
          bgColor: AppColors.grey700,
          title: title,

          callback: () => headerCallback(isFatStep, false, heading),
        ),
        Container(
          width: widget.isCrlOnly ? 1.sw / 1.06 : 1.sw / 2.2,

          decoration: BoxDecoration(
            color: AppColors.blackColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(4.r),
              bottomLeft: Radius.circular(4.r),
            ),
          ),

          child: Column(
            children: List.generate(bonuspenality.length, (index) {
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
                                text: bonuspenality[index].start.toString(),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                textColor: AppColors.grey900,
                              ),
                              Gap.horizentalGap(4),
                              AppIcons.arrowForwardRange(
                                size: 18,
                                color: AppColors.themeColor,
                              ),
                              Gap.horizentalGap(4),
                              TextWidget(
                                text: bonuspenality[index].end.toString(),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                textColor: AppColors.grey900,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextWidget(
                                text: bonuspenality[index].amount.toString(),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                textColor: AppColors.grey900,
                              ),
                              Gap.horizentalGap(7),
                              Visibility(
                                visible: (bonuspenality.length - 1) == index,
                                child: InkWell(
                                  onTap: () =>
                                      removeLastBonusPenalty(isFatStep),
                                  child: AppIcons.remove(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !((bonuspenality.length - 1) == index),
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
    bool isFromSteps,
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
                if (isFatStep) {
                  applyBonusPenalityForFat = true;
                  if (fatValues.length > 1) {
                    String fatNewStartValue = (fatValues.last + 0.1).toString();
                    fatStartController.text = fatNewStartValue;
                  }
                } else {
                  applyBonusPenalityForFat = false;
                  if (clrValues.length > 1) {
                    String clrNewStartValue = (clrValues.last + 0.1).toString();
                    clrStartController.text = clrNewStartValue;
                  }
                }
                showDragableBottomSheet(
                  context,
                  _buildAddFatClrStepForm(isFromSteps, isFatStep, heading),
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

  _buildAddFatClrStepForm(bool isFromSteps, bool isFatStep, String heading) {
    return SizedBox(
      width: 1.sw,
      height: isFromSteps
          ? isFatStep
                ? 250.h
                : 290.h
          : 295.h,
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
          Visibility(
            visible: !isFatStep,
            child: _buildDropdownField(hint: ''),
          ),
          Gap.verticalGap(6),
          Visibility(
            visible: !isFromSteps,
            replacement: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DecimalTextformFeild(
                        controller: isFatStep
                            ? fatStartController
                            : clrStartController,
                        lable: 'from',
                        hint: '0.0',
                        fieldWidth: 1.sw / 2.3,
                      ),

                      DecimalTextformFeild(
                        controller: isFatStep
                            ? fatEndController
                            : clrEndController,
                        lable: 'to',
                        hint: '0.0',
                        fieldWidth: 1.sw / 2.3,
                      ),
                    ],
                  ),
                  Gap.verticalGap(12),

                  DecimalTextformFeild(
                    controller: isFatStep
                        ? fatRateController
                        : clrRateController,
                    lable: 'rate',
                    hint: '0.0',
                    fieldWidth: 1.sw,
                  ),
                  InkWell(
                    onTap: () => addStep(isFatStep),
                    child: AppButton(
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      buttonHeight: 45.h,

                      buttonFontWeight: FontWeight.w600,
                      title: 'add',

                      isLoading: false.obs,
                    ),
                  ),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [
                  Obx(
                    () => SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              isBonus.value = true;
                            },
                            child: Row(
                              children: [
                                BonusPenalityRadioButton(isActive: isBonus),
                                Gap.horizentalGap(5.w),
                                TextWidget(
                                  text: 'bonus',
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                          Gap.horizentalGap(20.w),
                          InkWell(
                            onTap: () {
                              isBonus.value = false;
                            },
                            child: Row(
                              children: [
                                BonusPenalityRadioButton(
                                  isActive: isBonus.value
                                      ? false.obs
                                      : true.obs,
                                ),
                                Gap.horizentalGap(5.w),
                                TextWidget(
                                  text: 'penalty',
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap.verticalGap(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DecimalTextformFeild(
                        controller: bonusStartController,
                        lable: 'from',
                        hint: '0.0',
                        fieldWidth: 1.sw / 2.3,
                      ),
                      DecimalTextformFeild(
                        controller: bonusEndController,
                        lable: 'to',
                        hint: '0.0',
                        fieldWidth: 1.sw / 2.3,
                      ),
                    ],
                  ),
                  Gap.verticalGap(12),

                  DecimalTextformFeild(
                    controller: bonusAmountController,
                    lable: 'rate',
                    hint: '0.0',
                    fieldWidth: 1.sw,
                  ),
                  Obx(
                    () => InkWell(
                      onTap: () {
                        addBonusPenalty();
                      },
                      child: AppButton(
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        buttonBorderColor: isBonus.value
                            ? AppColors.themeColor
                            : AppColors.redColor,
                        buttonHeight: 45.h,
                        buttonColor: isBonus.value
                            ? AppColors.themeColor
                            : AppColors.redColor,
                        buttonFontWeight: FontWeight.w600,
                        title: 'add'.trParams({
                          'type': isBonus.value ? 'bonus' : "penalty",
                        }),
                        isLoading: false.obs,
                      ),
                    ),
                  ),
                ],
              ),
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
          height: 38.h,
          margin: EdgeInsets.symmetric(horizontal: 12.w),
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
}

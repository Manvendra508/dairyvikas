import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/fixed_chart.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/rate_cart/presentation/controllers/rate_chart_common_function.dart';
import 'package:DairyVikas/features/rate_cart/presentation/pages/rate_chart_common_widgets/rate_textform_feild.dart';
import 'package:DairyVikas/features/rate_cart/presentation/pages/rate_chart_common_widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../domain/entities/bonus_penality_step_entity.dart';
import '../../../domain/entities/rate_step_entity.dart';
import '../../controllers/add_rate_chart_controller.dart';
import '../rate_chart_common_widgets/bonus_penality_radio_button.dart';

List<double> generateValues(double start, double end) {
  final values = <double>[];
  double current = start;
  while (current <= end + 0.0001) {
    values.add(double.parse(current.toStringAsFixed(1)));
    current += 0.1;
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
  required List<double> snfValues,
  required List<RateStep> fatSteps,
  required List<RateStep> snfSteps,
  required List<BonusPenaltyStep> fatBonus,
  required List<BonusPenaltyStep> snfBonus,
}) {
  List<List<double>> matrix = [];

  for (final fat in fatValues) {
    List<double> row = [];
    for (final snf in snfValues) {
      // FAT rate
      double fatRate = 0;
      if (fatSteps.isNotEmpty) {
        for (final step in fatSteps) {
          if (fat >= step.start && fat <= step.end) fatRate = step.ratePaisa;
        }
      }

      // SNF rate
      double snfRate = 0;
      if (snfSteps.isNotEmpty) {
        for (final step in snfSteps) {
          if (snf >= step.start && snf <= step.end) snfRate = step.ratePaisa;
        }
      }

      // calculate total
      double value = calculateRate(fat, fatRate) + calculateRate(snf, snfRate);

      // apply bonus/penalty
      if (fatSteps.isNotEmpty) value = applyBonusPenalty(fat, value, fatBonus);
      if (snfSteps.isNotEmpty) value = applyBonusPenalty(snf, value, snfBonus);

      row.add(value);
    }
    matrix.add(row);
  }

  return matrix;
}

// Main Widget
class FatSnfRatePerKg extends StatefulWidget {
  final bool isFatOnly;
  final List<List<double>> matrix;
  final List<double> fatValues;
  final List<double> snfValues;
  final List<RateStep> fatSteps;
  final List<RateStep> snfSteps;
  final List<BonusPenaltyStep> fatBonus;
  final List<BonusPenaltyStep> snfBonus;
  const FatSnfRatePerKg({
    super.key,
    required this.isFatOnly,
    required this.fatValues,
    required this.snfValues,
    required this.fatSteps,
    required this.snfSteps,
    required this.fatBonus,
    required this.snfBonus,
    required this.matrix,
  });

  @override
  RateChartScreenState createState() => RateChartScreenState();
}

class RateChartScreenState extends State<FatSnfRatePerKg> with CommonMixin {
  final rateChartCommonFunctionController =
      Get.find<RateChartCommonFunctionController>();
  // Controllers
  final fatStartController = TextEditingController();
  final fatEndController = TextEditingController();
  final fatRateController = TextEditingController();

  final snfStartController = TextEditingController();
  final snfEndController = TextEditingController();
  final snfRateController = TextEditingController();

  final bonusStartController = TextEditingController();
  final bonusEndController = TextEditingController();
  final bonusAmountController = TextEditingController();

  RxBool isBonus = true.obs; // true = bonus, false = penalty
  bool applyBonusPenalityForFat = true; // true = FAT, false = SNF

  List<RateStep> fatSteps = [];
  List<RateStep> snfSteps = [];
  List<BonusPenaltyStep> fatBonus = [];
  List<BonusPenaltyStep> snfBonus = [];

  List<double> fatValues = [];
  List<double> snfValues = [];
  List<List<double>> matrix = [];

  resetControllers() {
    fatStartController.clear();
    fatEndController.clear();
    fatRateController.clear();
    snfStartController.clear();
    snfEndController.clear();
    snfRateController.clear();
    bonusStartController.clear();
    bonusEndController.clear();
    bonusAmountController.clear();
  }

  void onSaveMatrix() {
    final addRateChartController = Get.find<AddRateChartController>();

    addRateChartController.getRateChart(
      matrix,
      fatValues,
      snfValues,
      null,
      fatBonus,
      snfBonus,
      widget.isFatOnly ? [fatSteps] : [fatSteps, snfSteps],
      context,
    );
  }

  // Add Steps
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

  void addSnfStep() {
    final start = double.tryParse(snfStartController.text);
    final end = double.tryParse(snfEndController.text);
    double? rate = double.tryParse(snfRateController.text);
    if (start != null && end != null && rate != null) {
      if (rate < 10 && rate > 0) {
        rate = rate * 100;
      }
      setState(() {
        snfSteps.add(RateStep(start: start, end: end, ratePaisa: rate!));
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
          snfBonus.add(step);
        }
      });
    }

    generateChart();
    AppNavigation.goBack();
  }

  void removeLastFatStep() => setState(() {
    if (fatSteps.isNotEmpty) fatSteps.removeLast();
  });

  void removeLastSnfStep() => setState(() {
    if (snfSteps.isNotEmpty) snfSteps.removeLast();
  });

  void removeLastBonusPenalty(bool isFat) {
    setState(() {
      if (isFat && fatBonus.isNotEmpty) {
        fatBonus.removeLast();
      } else if (!isFat && snfBonus.isNotEmpty) {
        snfBonus.removeLast();
      }
      generateChart();
    });
  }

  void generateChart() async {
    if (fatSteps.isEmpty && snfSteps.isEmpty) {
      fatValues.clear();
      snfValues.clear();
      matrix.clear();
      return;
    }

    // Generate FAT values
    fatValues = fatSteps.isNotEmpty
        ? generateValues(fatSteps.first.start, fatSteps.last.end)
        : [0.0];

    // Generate SNF values
    snfValues = snfSteps.isNotEmpty
        ? generateValues(snfSteps.first.start, snfSteps.last.end)
        : [0.0];

    matrix = generateMatrix(
      fatValues: fatValues,
      snfValues: snfValues,
      fatSteps: fatSteps,
      snfSteps: snfSteps,
      fatBonus: fatBonus,
      snfBonus: snfBonus,
    );

    setState(() {});
  }

  addStep(bool isFatStep) {
    bool isValidate = rateChartCommonFunctionController
        .rangeValidationForFatandSnf(
          fatStartController.text,
          fatEndController.text,
          snfStartController.text,
          snfEndController.text,
          isFatStep ? fatRateController.text : snfRateController.text,
          isFatStep,
        );
    if (!isValidate) return;
    if (isFatStep) {
      addFatStep();
    } else {
      addSnfStep();
    }

    AppNavigation.goBack();
  }

  removeFatOrSnfStep(bool isFatStep) {
    if (isFatStep) {
      removeLastFatStep();
    } else {
      removeLastSnfStep();
    }
    generateChart();
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
      if (snfValues.length > 1) {
        String snfNewStartValue = (snfValues.last + 0.1).toString();
        snfStartController.text = snfNewStartValue;
      }
    }
    showDragableBottomSheet(
      context,
      _buildAddFatSnfStepForm(isFromSteps, isFatStep, heading),
    );
  }

  setDataForEditChart() {
    if (!AppState.isRateChartEdit) return;
    fatValues = widget.fatValues;
    snfValues = widget.snfValues;
    fatBonus = widget.fatBonus;
    snfBonus = widget.snfBonus;
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

        Gap.verticalGap(20.h),
        // Rate Chart
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

            if (fatSteps.isNotEmpty)
              _buildBonusPenalityContainer(
                'bonus_penalty',
                fatBonus,
                'bonus_penalty_on_fat',
                true,
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

              if (snfSteps.isNotEmpty)
                _buildBonusPenalityContainer(
                  'bonus_penalty',
                  snfBonus,
                  'bonus_penalty_on_snf',
                  false,
                ),
            ],
          ),
        ),
      ],
    );
  }

  _buildFatSnfStepsContainer(
    String title,
    List<RateStep> steps,

    bool isFatStep,
    String heading,
  ) {
    return Column(
      children: [
        StepHeader(
          isOnly: widget.isFatOnly,
          bgColor: AppColors.themeColor,
          title: title,
          radius: 5.r,
          callback: () => headerCallback(isFatStep, true, heading),
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
                                  onTap: () => removeFatOrSnfStep(isFatStep),
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
        // _buildHeader(title, AppColors.grey700, 0.r, false, isFatStep, heading),
        StepHeader(
          isOnly: widget.isFatOnly,
          bgColor: AppColors.grey700,
          title: title,
          callback: () => headerCallback(isFatStep, false, heading),
        ),
        Container(
          width: 1.sw / 2.2,

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

  _buildAddFatSnfStepForm(bool isFromSteps, bool isFatStep, String heading) {
    return SizedBox(
      width: 1.sw,
      height: isFromSteps ? 240.h : 290.h,
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
                            : snfStartController,
                        lable: 'from',
                        hint: '0.0',
                        fieldWidth: 1.sw / 2.3,
                      ),

                      DecimalTextformFeild(
                        controller: isFatStep
                            ? fatEndController
                            : snfEndController,
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
                        : snfRateController,
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
}

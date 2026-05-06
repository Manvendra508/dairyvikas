import 'dart:convert';

import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/error/exceptions.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/app_validations.dart';
import 'package:dairysathi/features/auth/registration_flow/data/model/dairy_setting_data_model.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/entities/dairy_setting_data_response_entity.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/usecases/get_dairy_setting_data_usecase.dart'
    show GetDairySettingDataUsecase;
import 'package:dairysathi/features/rate_cart/domain/entities/increase_step_entity.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/add_ratechart_usecase.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/update_rate_chart_usecase.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/upload_excel_usecase.dart';
import 'package:dairysathi/features/rate_cart/presentation/chart_helpers/rate_chart_mapper.dart';
import 'package:dairysathi/features/rate_cart/presentation/pages/rate_charts/fat_snf_rate_per_kg.dart';
import 'package:dio/dio.dart' as fd;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/local_datasources/local_storage_service.dart';
import '../../domain/entities/bonus_penality_step_entity.dart';
import '../../domain/entities/rate_step_entity.dart';
import '../../domain/entities/total_solid_step_entity.dart';
import '../pages/rate_charts/fat_clr_inc_per_fat_clr_point.dart';
import '../pages/rate_charts/fat_clr_rate_per_kg.dart';
import '../pages/rate_charts/fat_clr_total_solid.dart';
import '../pages/rate_charts/fat_snf_inc_per_fatsnf_point.dart';
import '../pages/rate_charts/fat_snf_total_solid_chart.dart';
import 'all_rate_charts_controllers.dart';

class AddRateChartController extends GetxController with CommonMixin {
  final AddRatechartUsecase addRatechartUsecase;
  final UpdateRateChartUsecase updateRateChartUsecase;
  final GetDairySettingDataUsecase getdairySettingsData;
  final UploadExcelUsecase uploadExcelUsecase;
  Rx<DairySettingDataResponseEntity?> dairysSettingData = Rx(null);
  RxBool isSavingChart = false.obs;
  RxBool isLoading = false.obs;
  RxBool isUploading = false.obs;
  RxBool showExcelFileOption = false.obs;
  RxBool hasError = false.obs;
  RxBool showChartFormateDropdown = true.obs;
  RxBool showChartTypeDropdown = true.obs;
  RxMap selectedChartCategory = {}.obs;
  RxDouble adjusmentvalue = 0.0.obs;
  RxBool isAdjustmentPositive = true.obs;

  TextEditingController rateChartName = TextEditingController();
  TextEditingController adjustmentController = TextEditingController();
  RxString fixedRate = '0.0'.obs;
  Map stepsRowData = {};
  RxString selectedChartExcelFile = ''.obs;
  PlatformFile? excelFile;
  RxBool activeSaveButton = false.obs;
  DairySettingDataModel selectedRateChartType = DairySettingDataModel.empty();

  RxMap selectedMilkType = {}.obs;
  RxList<Map<String, dynamic>> milkTypes = <Map<String, dynamic>>[
    {"id": '0', "value": "select_milk_type"},
  ].obs;
  List<List<double>> rateChartValues = [];

  List<double> fatValues = [];
  List<double>? snfValues = [];
  List<double>? clrValues = [];
  List<BonusPenaltyStep> fatBonus = [];
  List<BonusPenaltyStep> snfBonus = [];
  List<BonusPenaltyStep> clrBonus = [];
  List<double> excelFatValues = [];
  List<double>? excelSnfValues = [];
  List<double>? excelClrValues = [];
  String excelchartType = '';
  String excelHeadText = '';
  List<RateStep> ratePerKGfatSteps = [];
  List<RateStep> ratePerKGsnfSteps = [];
  List<RateStep> ratePerKGclrSteps = [];
  List<IncreaseStep> increasePointClrSteps = [];
  List<IncreaseStep> increasePointFatSteps = [];
  List<IncreaseStep> increasePointSnfSteps = [];
  List<TotalSolidStep> totalSolidSteps = [];

  List<DairySettingDataModel> rateChartTypes = [];
  DairySettingDataModel selectedRateChartFormate =
      DairySettingDataModel.empty();
  List<DairySettingDataModel> rateChartFormates = [
    DairySettingDataModel(id: '1', name: 'Rate Per Kg'),
    DairySettingDataModel(id: '2', name: 'Increament By fat/snf point'),

    DairySettingDataModel(id: '3', name: 'Total solid'),
    DairySettingDataModel(id: '4', name: 'Excel'),
  ];

  // keys///////
  final GlobalKey<IncreaseFatSnfChartScreenPerFatSnfPointState>
  increaseSnfChartKey =
      GlobalKey<IncreaseFatSnfChartScreenPerFatSnfPointState>();
  final GlobalKey<TotalSolidChartFatSnfPageState> totalSolidChartFatSnfKey =
      GlobalKey<TotalSolidChartFatSnfPageState>();
  final GlobalKey<IncreaseFatClrChartScreenState> increaseFatClrChartKey =
      GlobalKey<IncreaseFatClrChartScreenState>();

  final GlobalKey<RateChartScreenState> fatSnfRatePerKgChartKey =
      GlobalKey<RateChartScreenState>();

  final GlobalKey<TotalSolidChartFatClrPageState> totalSolidChartFatClrKey =
      GlobalKey<TotalSolidChartFatClrPageState>();
  final GlobalKey<FatClrRatePerKgState> fatClrRatePerKgKey =
      GlobalKey<FatClrRatePerKgState>();
  AddRateChartController(
    this.addRatechartUsecase,
    this.getdairySettingsData,
    this.updateRateChartUsecase,
    this.uploadExcelUsecase,
  );

  @override
  void onInit() {
    firstMethod();

    super.onInit();
  }

  activateSaveButton() {
    if (selectedRateChartFormate.id != '0' && selectedRateChartType.id != '0') {
      activeSaveButton.value = true;
    } else {
      activeSaveButton.value = false;
    }
  }

  Future firstMethod() async {
    selectedChartCategory.value = AppState.rateChartCategories[0];

    selectedMilkType.value = milkTypes[0];

    selectedRateChartType = DairySettingDataModel(id: '0', name: 'nan');
    selectedRateChartFormate = DairySettingDataModel(id: '0', name: 'nan');
    await fetchDairySettingsData();
    if (AppState.isRateChartEdit) {
      setInfoDataOfEditRateChart();
    }
  }

  setInfoDataOfEditRateChart() {
    // set milk-type and category

    selectedMilkType.value = milkTypes.firstWhere(
      (milktype) =>
          milktype['id'] ==
          AppState.currentRateChartForDetailsPage.milkTypeId.toString(),
    );
    selectedChartCategory.value = AppState.rateChartCategories.firstWhere(
      (category) =>
          category['id'] ==
          AppState.currentRateChartForDetailsPage.rateChartCategoryId
              .toString(),
    );
    // set chart-type and formate
    selectedRateChartFormate = rateChartFormates.firstWhere(
      (formate) =>
          formate.name == AppState.currentRateChartForDetailsPage.chartFormat,
    );

    selectedRateChartType = rateChartTypes.firstWhere(
      (formate) =>
          formate.id ==
          AppState.currentRateChartForDetailsPage.chartType.toString(),
    );

    rateChartName.text = AppState.currentRateChartForDetailsPage.name;

    if (AppState.currentRateChartForDetailsPage.chartType.toString() == '6') {
      activeSaveButton.value = true;
    } else {
      activateSaveButton();
    }

    if (selectedRateChartFormate.id != '4') {
      getStepsFromRowString(AppState.currentRateChartForDetailsPage.steps);
    }
    // AddUpdateChartControllerHelper.parseStepsFromJson(
    //   AppState.currentRateChartForDetailsPage.steps,
    //   selectedRateChartFormate.id,
    // );
    setChartData();
  }

  void adjustRateChart() {
    final mapper = AppState.mapper;
    final rc = mapper.rateChart;
    if (adjustmentController.text.isEmpty) {
      showAppToastMessage('please_enter_adjustment_amount', true);
      return;
    }
    double adjustment = isAdjustmentPositive.value
        ? double.parse(adjustmentController.text)
        : -double.parse(adjustmentController.text);
    adjusmentvalue.value = adjustment;
    for (int i = 0; i < rc.length; i++) {
      for (int j = 0; j < rc[i].length; j++) {
        rc[i][j] = double.parse((rc[i][j] + adjustment).toStringAsFixed(2));
      }
    }
    mapper.rateChart = rc;
    adjustmentController.clear();
    update();
    AppNavigation.goBack();
  }

  setChartData() {
    final mapper = AppState.mapper;
    if (selectedRateChartFormate.id == '4') {
      rateChartValues = mapper.rateChart;
      excelFatValues = fatValues = mapper.fatValues;
      excelClrValues = clrValues = mapper.clrValues;
      excelSnfValues = snfValues = mapper.snfValues;

      bool clrISNull = (mapper.clrValues == null || clrValues![0] == 0.0);
      bool snfISNull = (mapper.snfValues == null || snfValues![0] == 0.0);
      excelchartType = clrISNull ? 'FAT_SNF' : "FAT_CLR";
      if (clrISNull && !snfISNull) {
        excelHeadText = 'FAT_SNF';
      } else if (!clrISNull && snfISNull) {
        excelHeadText = 'FAT_CLR';
      } else if (clrISNull && snfISNull) {
        excelHeadText = 'FAT Only';
      } else {
        excelHeadText = 'CLR Only';
      }
    } else {
      rateChartValues = mapper.rateChart;
      fatValues = mapper.fatValues;
      snfValues = mapper.snfValues;
      clrValues = mapper.clrValues;
      fatBonus = mapper.fatBonus;
      snfBonus = mapper.snfBonus;
    }
  }

  getStepsFromRowString(String stepsString) {
    if (stepsString == 'null' || stepsString.isEmpty) return;
    bool isfatandSnf = selectedRateChartType.id == '3';
    bool isfatandClr =
        selectedRateChartType.id == '4' || selectedRateChartType.id == '5';
    bool isFatOnly = selectedRateChartType.id == '1';
    bool isClrOnly = selectedRateChartType.id == '2';
    final Map<String, dynamic> decodedSteps = jsonDecode(stepsString);
    if (selectedRateChartFormate.id == '1') {
      if (isfatandSnf || isfatandClr) {
        final List<Map<String, dynamic>> fatStepsJson =
            List<Map<String, dynamic>>.from(decodedSteps['fat']);
        final List<Map<String, dynamic>> snfOrclrStepsJson =
            List<Map<String, dynamic>>.from(
              isfatandClr ? decodedSteps['clr'] : decodedSteps['snf'],
            );
        ratePerKGfatSteps.addAll(
          fatStepsJson
              .map(
                (fs) => RateStep(
                  start: double.parse(fs['start'].toString()),
                  end: double.parse(fs['end'].toString()),
                  ratePaisa: double.parse(fs['price'].toString()),
                ),
              )
              .toList(),
        );

        if (isfatandSnf) {
          ratePerKGsnfSteps.addAll(
            snfOrclrStepsJson
                .map(
                  (fs) => RateStep(
                    start: double.parse(fs['start'].toString()),
                    end: double.parse(fs['end'].toString()),
                    ratePaisa: double.parse(fs['price'].toString()),
                  ),
                )
                .toList(),
          );
        } else {
          // clr case
          ratePerKGclrSteps.addAll(
            snfOrclrStepsJson
                .map(
                  (fs) => RateStep(
                    start: double.parse(fs['start'].toString()),
                    end: double.parse(fs['end'].toString()),
                    ratePaisa: double.parse(fs['price'].toString()),
                  ),
                )
                .toList(),
          );
        }
      } else if (isFatOnly) {
        final List<Map<String, dynamic>> fatStepsJson =
            List<Map<String, dynamic>>.from(decodedSteps['fat']);
        ratePerKGfatSteps.addAll(
          fatStepsJson
              .map(
                (fs) => RateStep(
                  start: double.parse(fs['start'].toString()),
                  end: double.parse(fs['end'].toString()),
                  ratePaisa: double.parse(fs['price'].toString()),
                ),
              )
              .toList(),
        );
      } else if (isClrOnly) {
        final List<Map<String, dynamic>> snfOrclrStepsJson =
            List<Map<String, dynamic>>.from(decodedSteps['clr']);
        ratePerKGclrSteps.addAll(
          snfOrclrStepsJson
              .map(
                (fs) => RateStep(
                  start: double.parse(fs['start'].toString()),
                  end: double.parse(fs['end'].toString()),
                  ratePaisa: double.parse(fs['price'].toString()),
                ),
              )
              .toList(),
        );
      }
    } else if (selectedRateChartFormate.id == '2') {
      if (isfatandSnf || isfatandClr) {
        final List<Map<String, dynamic>> fatStepsJson =
            List<Map<String, dynamic>>.from(decodedSteps['fat']);
        final List<Map<String, dynamic>> snfOrclrStepsJson =
            List<Map<String, dynamic>>.from(
              isfatandClr ? decodedSteps['clr'] : decodedSteps['snf'],
            );
        increasePointFatSteps.addAll(
          fatStepsJson
              .map(
                (fs) => IncreaseStep(
                  point: double.parse(fs['point'].toString()),
                  amount: double.parse(fs['price'].toString()),
                ),
              )
              .toList(),
        );

        if (isfatandSnf) {
          increasePointSnfSteps.addAll(
            snfOrclrStepsJson
                .map(
                  (fs) => IncreaseStep(
                    point: double.parse(fs['point'].toString()),
                    amount: double.parse(fs['price'].toString()),
                  ),
                )
                .toList(),
          );
        } else {
          // clr case
          increasePointClrSteps.addAll(
            snfOrclrStepsJson
                .map(
                  (fs) => IncreaseStep(
                    point: double.parse(fs['point'].toString()),
                    amount: double.parse(fs['price'].toString()),
                  ),
                )
                .toList(),
          );
        }
      } else if (isFatOnly) {
        final List<Map<String, dynamic>> fatStepsJson =
            List<Map<String, dynamic>>.from(decodedSteps['fat']);
        increasePointFatSteps.addAll(
          fatStepsJson
              .map(
                (fs) => IncreaseStep(
                  point: double.parse(fs['point'].toString()),
                  amount: double.parse(fs['price'].toString()),
                ),
              )
              .toList(),
        );
      } else if (isClrOnly) {
        final List<Map<String, dynamic>> snfOrclrStepsJson =
            List<Map<String, dynamic>>.from(decodedSteps['clr']);
        increasePointClrSteps.addAll(
          snfOrclrStepsJson
              .map(
                (fs) => IncreaseStep(
                  point: double.parse(fs['point'].toString()),
                  amount: double.parse(fs['price'].toString()),
                ),
              )
              .toList(),
        );
      }
    } else if (selectedRateChartFormate.id == '3') {
      final List<Map<String, dynamic>> solidSteps =
          List<Map<String, dynamic>>.from(decodedSteps['solid_steps']);

      totalSolidSteps.addAll(
        solidSteps
            .map(
              (ts) => TotalSolidStep(
                fatFrom: double.parse(ts['fatFrom'].toString()),
                fatTo: double.parse(ts['fatTo'].toString()),
                snfOrclrFrom: double.parse(ts['snfFrom'].toString()),
                snfOrclrTo: double.parse(ts['snfTo'].toString()),
                rate: double.parse(ts['price'].toString()),
              ),
            )
            .toList(),
      );
    }
  }

  getRateChart(
    List<List<double>> matrix,
    List<double> fatvalues,
    List<double>? snfvalues,
    List<double>? clrvalues,

    List<BonusPenaltyStep>? fatBonuses,
    List<BonusPenaltyStep>? snfBonuses,
    List stepsList,
  ) {
    rateChartValues = matrix;
    fatValues = fatvalues;
    snfValues = snfvalues;
    clrValues = clrvalues;
    if (fatBonuses != null) {
      fatBonus = fatBonuses;
    }
    if (snfBonuses != null) {
      snfBonus = snfBonuses;
    }

    stepsRowData = calculateSteps(stepsList);

    addOrUpdateRateChart();
  }

  Future chooseExcelFile() async {
    excelFile = await pickExcelFile();
    if (excelFile == null) return;

    selectedChartExcelFile.value = '${excelFile!.name}.${excelFile!.extension}';
  }

  addChart() async {
    if (selectedRateChartFormate.id == '4') {
      //excel case

      if (selectedChartExcelFile.value.isEmpty && !AppState.isRateChartEdit) {
        return;
      }
      await addOrUpdateRateChart();
    } else {
      if (selectedRateChartType.id == '3' || selectedRateChartType.id == '1') {
        checkForTypeFatSnfAndFatOnly();
      } else if (selectedRateChartType.id == '4' ||
          selectedRateChartType.id == '2' ||
          selectedRateChartType.id == '5') {
        checkForTypeFatClrAndClrOnly();
        // rate type 5 is for FAT + CLR + Auto SNF
      } else if (selectedRateChartType.id == '6') {
        await addOrUpdateRateChart();
      }
    }
  }

  checkForTypeFatClrAndClrOnly() {
    if (selectedRateChartType.id == '4' && selectedRateChartFormate.id == '1') {
      if (fatClrRatePerKgKey.currentState == null) {
        return;
      }
      // type = Fat + clr , formate = rate per kg
      fatClrRatePerKgKey.currentState!.onSaveMatrix();
    } else if (selectedRateChartType.id == '4' &&
        selectedRateChartFormate.id == '2') {
      // type = Fat + clr , formate = increase fat cl per point
      if (increaseFatClrChartKey.currentState == null) return;
      increaseFatClrChartKey.currentState?.onSaveMatrix();
    } else if (selectedRateChartType.id == '4' &&
        selectedRateChartFormate.id == '3') {
      // type = Fat + clr , formate = total solid
      if (totalSolidChartFatClrKey.currentState == null) return;
      totalSolidChartFatClrKey.currentState?.onSaveMatrix();
    }
  }

  checkForTypeFatSnfAndFatOnly() {
    if ((selectedRateChartType.id == '3' || selectedRateChartType.id == '1') &&
        selectedRateChartFormate.id == '1') {
      if (fatSnfRatePerKgChartKey.currentState == null) {
        return;
      }
      // type = Fat + snf , formate = rate per kg
      fatSnfRatePerKgChartKey.currentState!.onSaveMatrix();
    } else if ((selectedRateChartType.id == '3' ||
            selectedRateChartType.id == '1') &&
        selectedRateChartFormate.id == '2') {
      // type = Fat + snf , formate = increase fat snf per point
      if (increaseSnfChartKey.currentState == null) return;
      increaseSnfChartKey.currentState?.onSaveMatrix();
    } else if ((selectedRateChartType.id == '3' ||
            selectedRateChartType.id == '1') &&
        selectedRateChartFormate.id == '3') {
      // type = Fat + snf , formate = total solid
      if (totalSolidChartFatSnfKey.currentState == null) return;
      totalSolidChartFatSnfKey.currentState?.onSaveMatrix();
    }
  }

  bool validateChartData() {
    String? chartNameError = AppValidation().validateChartName(
      rateChartName.text,
    );

    if (chartNameError != null) {
      showAppToastMessage(chartNameError, true);
      return false;
    }

    if (selectedMilkType['id'] == '0') {
      showAppToastMessage('select_milk_type', true);
      return false;
    }

    if (rateChartValues.isEmpty) {
      showAppToastMessage('empty_rate_chart', true);
      return false;
    }

    return true;
  }

  Map<String, double> calculateBonusPenalty({
    required double value,
    required List<BonusPenaltyStep> steps,
  }) {
    double bonus = 0;
    double penalty = 0;

    for (final step in steps) {
      if (value >= step.start && value <= step.end) {
        if (step.isBonus) {
          bonus += step.amount;
        } else {
          penalty += step.amount;
        }
      }
    }

    return {"bonus": bonus, "penalty": penalty};
  }

  Map calculateSteps(List stepList) {
    Map stepData = {};
    bool isfatandSnf = selectedRateChartType.id == '3';
    bool isfatandClr =
        selectedRateChartType.id == '4' || selectedRateChartType.id == '5';
    bool isFatOnly = selectedRateChartType.id == '1';
    bool isClrOnly = selectedRateChartType.id == '2';

    if (selectedRateChartFormate.id == '1') {
      int length = stepList.length;
      // rate per kg
      for (var i = 0; i < length; i++) {
        if (length == 2) {
          if (isfatandSnf) {
            List<RateStep> fs = stepList[0];
            List<RateStep> ss = stepList[1];
            stepData = {
              "fat": fs
                  .map(
                    (f) => {
                      "start": f.start,
                      "end": f.end,
                      "price": f.ratePaisa,
                    },
                  )
                  .toList(),
              "snf": ss
                  .map(
                    (s) => {
                      "start": s.start,
                      "end": s.end,
                      "price": s.ratePaisa,
                    },
                  )
                  .toList(),
            };
          } else {
            // case of fat/clr
            List<RateStep> fs = stepList[0];
            List<RateStep> cs = stepList[1];
            stepData = {
              "fat": fs
                  .map(
                    (f) => {
                      "start": f.start,
                      "end": f.end,
                      "price": f.ratePaisa,
                    },
                  )
                  .toList(),
              "clr": cs
                  .map(
                    (c) => {
                      "start": c.start,
                      "end": c.end,
                      "price": c.ratePaisa,
                    },
                  )
                  .toList(),
            };
          }
        } else {
          if (isFatOnly) {
            List<RateStep> fs = stepList[0];
            stepData = {
              "fat": fs
                  .map(
                    (f) => {
                      "start": f.start,
                      "end": f.end,
                      "price": f.ratePaisa,
                    },
                  )
                  .toList(),
            };
          } else {
            // isClrOnly case
            List<RateStep> cs = stepList[0];
            stepData = {
              "clr": cs
                  .map(
                    (c) => {
                      "start": c.start,
                      "end": c.end,
                      "price": c.ratePaisa,
                    },
                  )
                  .toList(),
            };
          }
        }
      }
    } else if (selectedRateChartFormate.id == '2') {
      // increame per fat/snf point
      int length = stepList.length;

      for (var i = 0; i < length; i++) {
        if (length == 2) {
          if (isfatandSnf) {
            List<IncreaseStep> fs = stepList[0];
            List<IncreaseStep> ss = stepList[1];
            stepData = {
              "fat": fs
                  .map((f) => {"point": f.point, "price": f.amount})
                  .toList(),
              "snf": ss
                  .map((s) => {"point": s.point, "price": s.amount})
                  .toList(),
            };
          } else {
            // case of fat/clr
            List<IncreaseStep> fs = stepList[0];
            List<IncreaseStep> cs = stepList[1];
            stepData = {
              "fat": fs
                  .map((f) => {"point": f.point, "price": f.amount})
                  .toList(),
              "clr": cs
                  .map((c) => {"point": c.point, "price": c.amount})
                  .toList(),
            };
          }
        } else {
          if (isFatOnly) {
            List<IncreaseStep> fs = stepList[0];
            stepData = {
              "fat": fs
                  .map((f) => {"point": f.point, "price": f.amount})
                  .toList(),
            };
          } else {
            // isClrOnly case
            List<IncreaseStep> cs = stepList[0];
            stepData = {
              "clr": cs
                  .map((c) => {"point": c.point, "price": c.amount})
                  .toList(),
            };
          }
        }
      }
    } else if (selectedRateChartFormate.id == '3') {
      // total solid

      List<TotalSolidStep> totalSolidSteps = stepList[0];

      stepData = {
        "solid_steps": totalSolidSteps.map((ts) {
          return {
            "fatFrom": ts.fatFrom,
            "fatTo": ts.fatTo,
            "snfFrom": ts.snfOrclrFrom,
            "snfTo": ts.snfOrclrTo,
            "price": ts.rate,
          };
        }).toList(),
      };
    }
    return stepData;
  }

  Future<Map<String, dynamic>> rateChartDataToSend() async {
    final List<Map<String, dynamic>> rateRows = [];

    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';

    if (selectedRateChartType.id == '6') {
      rateRows.add({"price": double.parse(fixedRate.value)});
    } else {
      for (int i = 0; i < fatValues.length; i++) {
        for (int j = 0; j < rateChartValues[i].length; j++) {
          final Map<String, dynamic> row = {
            "fat": fatValues[i],
            "price": rateChartValues[i][j],
          };

          // Optional SNF
          if (snfValues != null && snfValues!.length > j) {
            row["snf"] = snfValues![j];
          }

          // Optional CLR
          if (clrValues != null && clrValues!.length > j) {
            row["clr"] = clrValues![j];
          }

          /// ---- FAT BONUS / PENALTY ----
          final fatResult = calculateBonusPenalty(
            value: fatValues[i],
            steps: fatBonus,
          );

          /// ---- SNF BONUS / PENALTY (if exists) ----
          if (row.containsKey("snf")) {
            final snfResult = calculateBonusPenalty(
              value: row["snf"],
              steps: snfBonus,
            );

            fatResult["bonus"] = fatResult["bonus"]! + snfResult["bonus"]!;
            fatResult["penalty"] =
                fatResult["penalty"]! + snfResult["penalty"]!;
          }

          /// ---- Attach only if applicable ----
          if (fatResult["bonus"]! > 0) {
            row["bonus"] = fatResult["bonus"];
          }

          if (fatResult["penalty"]! > 0) {
            row["penalty"] = fatResult["penalty"];
          }

          rateRows.add(row);
        }
      }
    }

    return {
      "milkTypeId": int.parse(selectedMilkType['id']),
      "chartTypeId": int.parse(selectedRateChartType.id),
      "name": rateChartName.text.trim(),
      "chartFormatName": selectedRateChartType.id == '6'
          ? rateChartFormates[3].name
          : selectedRateChartFormate.name.trim(),
      "clrIncreamentPoint": AppState.clrIncreaseStep,
      "rateChartCategoryId": int.parse(selectedChartCategory['id']),
      "baseAmount": AppState.baseAmount,
      "chartId": AppState.isRateChartEdit
          ? AppState.currentRateChartForDetailsPage.id
          : '',
      "dairyId": int.parse(dairyId),
      // "isenabled": "1",
      "rateRows": rateRows,
      "steps":
          selectedRateChartType.id == '6' || selectedRateChartFormate.id == '4'
          ? null
          : stepsRowData,
    };
  }

  Future<void> addOrUpdateRateChart() async {
    try {
      if (!validateChartData() || isSavingChart.value) return;
      isSavingChart.value = true;

      Map<String, dynamic> chartData = await rateChartDataToSend();

      if (AppState.isRateChartEdit) {
        Map response = await updateRateChartUsecase(chartData);
        _handleSuccessOrError(response);
      } else {
        Map response = await addRatechartUsecase(chartData);
        _handleSuccessOrError(response);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      isSavingChart.value = false;
    }
  }

  _handleSuccessOrError(Map response) async {
    if (response['success']) {
      final allRatechartController = Get.find<AllRateChartsController>();
      await allRatechartController.getAllRateCharts();
      AppNavigation.goBack();
      showAppToastMessage(response['message'], false);
    } else {
      showAppToastMessage(response['message'], true);
    }
  }

  Future<void> fetchDairySettingsData() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      dairysSettingData.value = await getdairySettingsData();

      if (dairysSettingData.value == null) return;
      if (dairysSettingData.value!.success) {
        rateChartTypes.addAll(
          dairysSettingData.value!.settingData.collectionTypes,
        );

        for (var element in dairysSettingData.value!.settingData.milkTypes) {
          Map<String, dynamic> type = {"id": element.id, "value": element.name};

          if (milkTypes.length < 3) {
            milkTypes.add(type);
          }
        }
        hasError.value = false;
        update();
      } else {
        hasError.value = true;
        showAppToastMessage(dairysSettingData.value!.message, true);
      }
    } catch (e) {
      hasError.value = true;
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadExcelForRateChartData() async {
    if (isUploading.value) return;
    try {
      isUploading.value = true;
      if (excelFile == null) return;
      if (excelFile!.extension != 'xlsx') {
        showAppToastMessage('upload_excel_file', true);
      }

      final multipartFile = excelFile!.path != null
          ? await fd.MultipartFile.fromFile(
              excelFile!.path!,
              filename: excelFile!.name,
            )
          : fd.MultipartFile.fromBytes(
              excelFile!.bytes!,
              filename: excelFile!.name,
            );

      final formData = fd.FormData.fromMap({'file': multipartFile});
      var response = await uploadExcelUsecase(formData);

      if (response['success']) {
        RateChartMapper mapper = RateChartMapper();

        final List<Map<String, dynamic>> rows = (response['rows'] as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        excelHeadText = excelchartType = response['chart_type'];
        if (excelchartType == 'FAT_SNF') {
          selectedRateChartType.id = '3';
        } else if (excelchartType == 'FAT_CLR') {
          selectedRateChartType.id = '4';
        } else if (excelchartType == 'FAT_ONLY') {
          selectedRateChartType.id = '1';
        } else if (excelchartType == 'CLR_ONLY') {
          selectedRateChartType.id = '2';
        }
        mapper.rebuildFromRateRows(rows, true);
        excelFatValues = fatValues = mapper.fatValues;
        if (excelchartType == 'FAT_SNF') {
          excelSnfValues = snfValues = mapper.snfValues ?? [0.0];
        } else if (excelchartType == 'FAT_CLR') {
          excelClrValues = clrValues = mapper.clrValues ?? [0.0];
        }
        rateChartValues = mapper.rateChart;
        activeSaveButton.value = true;
      } else {
        showAppToastMessage(response['success'], false);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      isUploading.value = false;
    }
    update();
  }

  selectValues(int id, DairySettingDataModel value) {
    if (id == 1) {
      selectedRateChartType = value;
    } else if (id == 2) {
      selectedRateChartFormate = value;
    }
    update();
  }

  selectFormate(DairySettingDataModel? dairySetting, int id) {
    if (dairySetting == null) return;

    selectValues(id, dairySetting);
    if (id == 1 && dairySetting.id == '6') {
      showChartFormateDropdown.value = false;
      activeSaveButton.value = true;
    } else if (id == 2 && dairySetting.id == '4') {
      showExcelFileOption.value = true;
      showChartTypeDropdown.value = false;
    } else {
      showChartTypeDropdown.value = true;
      showExcelFileOption.value = false;
      showChartFormateDropdown.value = true;
      activateSaveButton();
    }
  }

  selectCategoryOrMilktype(Map<dynamic, dynamic>? value, int id) {
    if (value == null) return;
    if (id == 1) {
      selectedMilkType.value = value;
    } else if (id == 2) {
      selectedChartCategory.value = value;
    }
  }
}

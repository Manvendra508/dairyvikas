import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/error/exceptions.dart';
import 'package:dairysathi/core/local_datasources/local_storage_service.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/features/rate_cart/data/model/rate_chart_model.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/get_all_rate_charts_usecase.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/unassign_ratechart_dairy_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/shake_widget.dart';
import '../../domain/usecases/assign_chart_to_dairy_usecase.dart';

class AllRateChartsController extends GetxController with CommonMixin {
  final GetAllRateChartsUsecase getAllRateChartsUsecase;
  final AssignChartToDairyUsecase assignChartToDairyUsecase;
  final UnassignRatechartDairyUsecase unassignRatechartDairyUsecase;
  RxBool hasError = false.obs;
  RxBool hasShiftDropDownNotSelected = false.obs;
  RxInt currentStatusFilterIndex = 0.obs;
  RxList<RateChartModel> rateChartsList = <RateChartModel>[].obs;
  RxBool isLoadingChart = false.obs;
  List<RateChartModel> filteredChartList = <RateChartModel>[];
  final shakeKey = GlobalKey<ShakeWidgetState>();
  RxString selectedMilkType = ''.obs;
  RxString selectedStatus = '0'.obs;
  RxList<Map<String, dynamic>> statusFilters = <Map<String, dynamic>>[
    {"id": '0', "title": 'all'},
    {"id": '1', "title": 'active'},
    {"id": '2', "title": 'inactive'},
    {"id": '3', "title": 'assigned'},
  ].obs;
  RxSet<String> selectedMilkTypes = <String>{}.obs;
  RxList<Map<String, dynamic>> milkTypes = <Map<String, dynamic>>[
    {
      "id": '1',
      "value": 'cow',
      'isSelected': false.obs,
      'icon': AppIcons.cow(size: 16),
    },
    {
      "id": '2',
      "value": 'buffalo',
      'isSelected': false.obs,
      'icon': AppIcons.buffalo(size: 16),
    },
  ].obs;

  RxMap<String, dynamic> selectedShift = <String, dynamic>{}.obs;

  AllRateChartsController(
    this.getAllRateChartsUsecase,
    this.assignChartToDairyUsecase,
    this.unassignRatechartDairyUsecase,
  );
  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    await getAllRateCharts();
  }

  Future<void> getAllRateCharts() async {
    try {
      if (isLoadingChart.value) return;
      isLoadingChart.value = true;

      Map response = await getAllRateChartsUsecase();

      if (response['success']) {
        hasError.value = false;
        rateChartsList.clear();
        List<dynamic> charts = response['data'] as List<dynamic>;
        rateChartsList.addAll(
          charts
              .map((e) => RateChartModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
        filteredChartList.assignAll(rateChartsList);
      } else {
        hasError.value = true;
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      hasError.value = true;
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      isLoadingChart.value = false;
    }
  }

  Future<void> assignRateChartToDairy(String chartId) async {
    try {
      if (selectedShift.isEmpty) {
        shakeKey.currentState?.shake();
        hasShiftDropDownNotSelected.value = true;
        showAppToastMessage('select_at_least_shift', true);
        return;
      }
      AppNavigation.goBack();
      if (isLoadingChart.value) return;
      isLoadingChart.value = true;
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      List<String> dairyIds = [];
      dairyIds.add(dairyId); // if we allow add multiple dariy
      final params = {
        "dairy_ids": dairyIds,
        "chart_id": chartId,
        "shift_id": selectedShift['id'].toString(),
      };
      Map response = await assignChartToDairyUsecase(params);

      if (response['success']) {
        isLoadingChart.value =
            false; // because if we dont set false to it , then below function will  not call

        await getAllRateCharts();
        showAppToastMessage(response['message'], false);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      isLoadingChart.value = false;
    }
  }

  Future<void> unassignRateChartToDairy(String chartId) async {
    try {
      AppNavigation.goBack();
      if (isLoadingChart.value) return;
      isLoadingChart.value = true;
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      List<String> dairyIds = [];
      dairyIds.add(dairyId); // if we allow add multiple dariy
      final params = {"dairy_ids": dairyIds};
      Map response = await unassignRatechartDairyUsecase(params);

      if (response['success']) {
        isLoadingChart.value =
            false; // because if we dont set false to it , then below function will  not call

        await getAllRateCharts();
        showAppToastMessage(response['message'], false);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      isLoadingChart.value = false;
    }
  }

  selectStatus(int index) {
    currentStatusFilterIndex.value = index;
    selectedStatus.value = statusFilters[index]['id'];
    filterRateCharts();
  }

  selectMilkType(int index) {
    milkTypes[index]['isSelected'].value =
        !milkTypes[index]['isSelected'].value;
    if (milkTypes[index]['isSelected'].value) {
      selectedMilkTypes.add(milkTypes[index]['id']);
    } else {
      selectedMilkTypes.remove(milkTypes[index]['id']);
    }
    filterRateCharts();
  }

  filterRateCharts() {
    if (selectedStatus.value == '0') {
      filteredChartList.assignAll(rateChartsList);
    } else if (selectedStatus.value == '1') {
      filteredChartList.assignAll(
        rateChartsList.where((chart) => chart.isEnabled).toList(),
      );
    } else if (selectedStatus.value == '2') {
      filteredChartList.assignAll(
        rateChartsList.where((chart) => !chart.isEnabled).toList(),
      );
    } else if (selectedStatus.value == '3') {
      filteredChartList.assignAll(
        rateChartsList
            .where((chart) => chart.isAssigned == 1)
            .toList(), // 1 means chart is assigned to supplier or dairy
      );
    }

    if (selectedMilkTypes.isNotEmpty) {
      filteredChartList = filteredChartList
          .where((c) => selectedMilkTypes.contains(c.milkTypeId.toString()))
          .toList();
    }
    update();
  }
}

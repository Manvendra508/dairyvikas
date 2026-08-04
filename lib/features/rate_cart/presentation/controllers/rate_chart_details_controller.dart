import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/features/rate_cart/data/model/rate_chart_model.dart';
import 'package:DairyVikas/features/rate_cart/domain/usecases/delete_rate_chart_usecase.dart';
import 'package:DairyVikas/features/rate_cart/domain/usecases/get_all_rate_charts_usecase.dart';
import 'package:DairyVikas/features/rate_cart/presentation/controllers/all_rate_charts_controllers.dart';
import 'package:DairyVikas/features/rate_cart/presentation/controllers/rate_chart_common_function.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/usecases/active_inactive_chart_usecase.dart';
import '../../domain/usecases/rate_chart_details_usecase.dart';
import '../chart_helpers/rate_chart_mapper.dart';

class RateChartDetailsController extends GetxController with CommonMixin {
  final GetAllRateChartsUsecase getAllRateChartsUsecase;
  final RateChartDetailsUsecase rateChartDetailsUsecase;
  final DeleteRatechartUsecase deleteChartDetailsUsecase;
  final ActiveInactiveChartUsecase activeInactiveChartUsecase;
  RxBool isProcessing = false.obs;
  final rateChartCommonController =
      Get.find<RateChartCommonFunctionController>();
  final mapper = RateChartMapper();
  RateChartDetailsController(
    this.getAllRateChartsUsecase,
    this.rateChartDetailsUsecase,
    this.deleteChartDetailsUsecase,
    this.activeInactiveChartUsecase,
  );

  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    await fetchRateChartDetails();
  }

  createRateChart(bool isStepsNotNull) {
    mapper.rebuildFromRateRows(
      AppState.currentRateChartForDetailsPage.rateChartValues
          .map((e) => e.toJson())
          .toList(),
      isStepsNotNull,
    );
    AppState.mapper = mapper;
    isProcessing.value = false;
    update();
  }

  Future<void> fetchRateChartDetails() async {
    try {
      if (isProcessing.value) return;
      isProcessing.value = true;

      Map response = await rateChartDetailsUsecase(
        AppState.currentRateChartForDetailsPage.id.toString(),
      );

      if (response['success']) {
        AppState.currentRateChartForDetailsPage = RateChartModel.fromJson(
          response['data'],
        );

        await createRateChart(
          AppState.currentRateChartForDetailsPage.steps != 'null'
              ? true
              : false,
        );
      } else {
        showAppToastMessage(response['message'], true);
      }
      // } catch (e) {
      //   print(e);
      //   String errorMessage = AppExceptionHandler.handleError(e);

      //   showAppToastMessage(errorMessage, true);
      // }
    } catch (e, s) {
      debugPrint('ERROR: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  Future<void> deactivateRateChart() async {
    try {
      if (isProcessing.value) return;
      isProcessing.value = true;

      Map response = await activeInactiveChartUsecase({
        'chart_id': AppState.currentRateChartForDetailsPage.id.toString(),
        'is_enabled': AppState.currentRateChartForDetailsPage.isEnabled
            ? '0'
            : "1",
      });

      if (response['success']) {
        isProcessing.value =
            false; // set this flag to false so that the below function can excute
        await fetchRateChartDetails();
        await Get.find<AllRateChartsController>().getAllRateCharts();
        showAppToastMessage(response['message'], false);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      if (kDebugMode) {
        print(errorMessage);
      }
      showAppToastMessage(errorMessage, true);
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> deleteRateChart() async {
    try {
      if (isProcessing.value) return;
      isProcessing.value = true;

      Map response = await deleteChartDetailsUsecase(
        AppState.currentRateChartForDetailsPage.id.toString(),
      );

      if (response['success']) {
        showAppToastMessage(response['message'], false);
        final allRateChartController = Get.find<AllRateChartsController>();
        await allRateChartController.getAllRateCharts();
        AppNavigation.goBack();
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      isProcessing.value = false;
    }
  }
}

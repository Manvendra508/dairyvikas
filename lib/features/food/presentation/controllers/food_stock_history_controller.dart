import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/features/food/domain/usecases/get_food_stock_history_usecase.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_navigation.dart';
import '../../data/models/stock_history_model.dart';

class FoodStockHistoryController extends GetxController with CommonMixin {
  final GetFoodStockHistoryUsecase getFoodStockHistoryUsecase;

  RxBool hasError = false.obs;
  RxInt currentStatusFilterIndex = 0.obs;
  RxList<StockHistoryModel> stocks = <StockHistoryModel>[].obs;

  RxMap selectedDateRange = {}.obs;
  RxInt currentDateRangeIndex = 0.obs;
  RxBool isLoading = false.obs;
  List<StockHistoryModel> filteredStocks = <StockHistoryModel>[];
  StockHistoryModel selectedFoodItem = StockHistoryModel.empty();

  FoodStockHistoryController(this.getFoodStockHistoryUsecase);
  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    if (AppState.dateRanges.isNotEmpty) {
      selectedDateRange.addAll(AppState.dateRanges[0]);
    }
    await getFoodtStockHistory();
  }

  Future getFoodtStockHistory() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      Map response = await getFoodStockHistoryUsecase(
        dairyId,
        selectedDateRange['start'],
        selectedDateRange['end'],

        AppState.currentStock.itemId.toString(),
      );

      if (response['success']) {
        hasError.value = false;
        stocks.clear();

        List stocksHistoryJson = response['data']['stocks'] as List;

        stocks.assignAll(
          stocksHistoryJson
              .map((item) => StockHistoryModel.fromJson(item))
              .toList(),
        );
        filteredStocks.assignAll(stocks);
        if (stocks.isNotEmpty) {
          selectedFoodItem = stocks[0];
        }
      } else {
        hasError.value = true;
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      hasError.value = true;
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      isLoading.value = false;
    }
  }

  selectDateRange(int index) async {
    currentDateRangeIndex.value = index;
    selectedDateRange.value = AppState.dateRanges[currentDateRangeIndex.value];
    AppNavigation.goBack();
    await getFoodtStockHistory();
  }
}

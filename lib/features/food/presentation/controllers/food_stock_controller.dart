import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/features/food/data/models/stock_model.dart';
import 'package:DairyVikas/features/food/domain/usecases/get_food_stock_usecase.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class FoodStockController extends GetxController with CommonMixin {
  final GetFoodStockUsecase getFoodStockUsecase;

  RxBool hasError = false.obs;
  RxInt currentStatusFilterIndex = 0.obs;
  RxList<StockModel> stocks = <StockModel>[].obs;

  RxBool isLoading = false.obs;
  List<StockModel> filteredStocks = <StockModel>[];

  RxString selectedMilkType = ''.obs;
  RxString selectedStatus = '0'.obs;
  TextEditingController searchController = TextEditingController();
  RxList<Map<String, dynamic>> statusFilters = <Map<String, dynamic>>[
    {"id": '0', "title": 'all'},
    {"id": '1', "title": 'in_stock_lower'},
    {"id": '2', "title": 'out_of_stock_lower'},
  ].obs;

  FoodStockController(this.getFoodStockUsecase);
  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    await getFoodtStock();
  }

  Future getFoodtStock() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      Map response = await getFoodStockUsecase(dairyId);

      if (response['success']) {
        hasError.value = false;
        stocks.clear();

        List stocksJson = response['data']['stock'] as List;

        stocks.assignAll(
          stocksJson.map((item) => StockModel.fromJson(item)).toList(),
        );
        filteredStocks.assignAll(stocks);
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

  selectStatus(int index) {
    currentStatusFilterIndex.value = index;
    selectedStatus.value = statusFilters[index]['id'];
    filterStockItems();
  }

  filterStockItems() {
    if (selectedStatus.value == '0') {
      filteredStocks.assignAll(stocks);
    } else if (selectedStatus.value == '1') {
      filteredStocks.assignAll(stocks.where((s) => s.stockLeft > 0).toList());
    } else if (selectedStatus.value == '2') {
      filteredStocks.assignAll(stocks.where((s) => s.stockLeft == 0).toList());
    }

    update();
  }
}

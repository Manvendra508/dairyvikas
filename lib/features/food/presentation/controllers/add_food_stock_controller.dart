import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart' show AppExceptionHandler;
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/app_validations.dart';
import 'package:DairyVikas/features/food/data/models/dealer_model.dart';
import 'package:DairyVikas/features/food/domain/usecases/get_food_dealers_usecase.dart';
import 'package:DairyVikas/features/food/domain/usecases/get_units_usecase.dart';
import 'package:DairyVikas/features/food/domain/usecases/update_food_stock_usecase.dart';
import 'package:DairyVikas/features/food/presentation/controllers/food_stock_controller.dart';
import 'package:DairyVikas/features/food/presentation/controllers/food_stock_history_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/local_datasources/local_storage_service.dart';
import '../../domain/usecases/add_food_stock_usecase.dart';

class AddFoodStockController extends GetxController with CommonMixin {
  final AddFoodStockUsecase _addFoodStockUsecase;
  final GetFoodDealersUsecase _getFoodDealersUsecase;
  final UpdateFoodStockUsecase _updateFoodStockUsecase;
  final GetUnitsUsecase _getUnitsUsecase;
  String validationErrorMessage = '';
  RxBool hasFieldError = false.obs;
  RxBool isDealerFoundByCode = false.obs;
  AppValidation appValidation = AppValidation();
  RxBool proccessing = false.obs;
  RxBool isLoading = true.obs;
  final dealerCode = TextEditingController();
  DealerModel searchedDealer = DealerModel.empty();
  final foodName = TextEditingController();
  int foodId = 0;
  final foodQuantity = TextEditingController();
  final foodBuyRate = TextEditingController();
  final foodSaleRate = TextEditingController();
  final foodAmountPaid = TextEditingController();
  RxString selectedDateString = ''.obs;
  List<DealerModel> dealers = <DealerModel>[];
  List<DealerModel> dealersForBottomList = <DealerModel>[];
  final dropDownKey = GlobalKey<DropdownSearchState>();

  AddFoodStockController(
    this._addFoodStockUsecase,
    this._getFoodDealersUsecase,
    this._updateFoodStockUsecase,
    this._getUnitsUsecase,
  );

  @override
  void onInit() {
    _firstMethod();
    super.onInit();
  }

  _firstMethod() async {
    if (!AppState.isFoodStockEdit) {
      selectedDateString.value = formatDateforApi(
        DateTime.now(),
      ); // add this only if vendro add the food stock. not in edit case.
    }

    await getAllFoodDealers();
    //await getUnits();
    if (AppState.isFoodStockEdit) {
      setStockDataForUpdate();
    }

    if (AppState.currentStockItem.stockId != 0 && !AppState.isFoodStockEdit) {
      foodId = AppState.currentStockItem.itemId;
      foodName.text = AppState.currentStockItem.itemName;
    }
    // this is case when use add new food stock then we have selected only
    //the particular item. so that he can not add another product.

    isLoading.value = false;
  }

  pickDateForFilter(BuildContext context) async {
    if (AppState.isFoodStockEdit) {
      showAppToastMessage('date_can_not_be_change', true);
      return;
    }
    selectedDateString.value =
        await pickDate(
          context: context,
          initialDate: selectedDateString.value.isNotEmpty
              ? DateTime.tryParse(selectedDateString.value)
              : DateTime.now(),
        ) ??
        formatDateforApi(DateTime.now());
  }

  Future setStockDataForUpdate() async {
    if (!AppState.isFoodStockEdit) return;
    selectedDateString.value = AppState.currentStockHistoryItem.purchaseDate;
    foodId = AppState.currentStockHistoryItem.itemId;
    foodName.text = AppState.currentStockHistoryItem.itemName;
    foodQuantity.text = AppState.currentStockHistoryItem.purchasedQuantity
        .toString();
    foodBuyRate.text = AppState.currentStockHistoryItem.purchasePrice
        .toString();
    foodSaleRate.text = AppState.currentStockHistoryItem.sellingPrice
        .toString();
    searchedDealer = dealers.firstWhere(
      (dealer) => dealer.id == AppState.currentStockHistoryItem.dealerId,
      orElse: () => DealerModel.empty(),
    );
    if (searchedDealer.id != 0) {
      dealerCode.text = searchedDealer.dealerCode;

      isDealerFoundByCode.value = true;
    }
    update();
  }

  Future getUnits() async {
    try {
      // final String dairyId =
      //     await SharedPrefsService.instance.getDairyId() ?? '0';
      Map response = await _getUnitsUsecase();

      if (response['success']) {
        // List dealersJson = response['data'] as List;

        // dealersForBottomList.addAll(
        //   dealersJson.map((dealerJson) => DealerModel.fromJson(dealerJson)),
        // );
        // dealers.assignAll(dealersForBottomList);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    }
  }

  Future getAllFoodDealers() async {
    try {
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      Map response = await _getFoodDealersUsecase(dairyId);

      if (response['success']) {
        dealersForBottomList.clear();
        List dealersJson = response['data'] as List;

        dealersForBottomList.addAll(
          dealersJson.map((dealerJson) => DealerModel.fromJson(dealerJson)),
        );
        dealers.assignAll(dealersForBottomList);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    }
  }

  bool validateData() {
    if (searchedDealer.id == 0) {
      _showErrorBox('select_dealer_first');
      return false;
    }

    if (foodId == 0 || foodName.text.isEmpty) {
      _showErrorBox('please_select_food');
      return false;
    }
    if (foodQuantity.text.isEmpty) {
      _showErrorBox('enter_food_qty');
      return false;
    }
    if (foodBuyRate.text.isEmpty) {
      _showErrorBox('enter_food__buy_rate');
      return false;
    }

    if (foodSaleRate.text.isEmpty) {
      _showErrorBox('enter_food__sale_rate');
      return false;
    }

    return true;
  }

  void _showErrorBox(String message) {
    validationErrorMessage = message;
    hasFieldError.value = true;

    Future.delayed(Duration(seconds: 3), () {
      hasFieldError.value = false;
    });
  }

  searchDealerInList(String searchTerm) {
    dealersForBottomList.assignAll(
      dealers.where(
        (dealer) =>
            dealer.dealerName.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ) ||
            dealer.dealerCode.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ) ||
            dealer.mobile.toLowerCase().startsWith(searchTerm.toLowerCase()),
      ),
    );
    update();
  }

  searchDealerToAddFoodStockOf(String code) {
    if (code.isEmpty) {
      isDealerFoundByCode.value = false;

      update();
      return;
    }
    searchedDealer = dealers.firstWhere(
      (dealer) => dealer.dealerCode == code.trim(),
      orElse: () => DealerModel.empty(),
    );
    if (searchedDealer.id == 0) {
      isDealerFoundByCode.value = false;
    } else {
      isDealerFoundByCode.value = true;
    }

    update();
  }

  selectDealerBySearchingInList(DealerModel dealer) {
    searchDealerToAddFoodStockOf(dealer.dealerCode);
    dealerCode.text = dealer.dealerCode;
    dealersForBottomList.clear();
    dealersForBottomList.assignAll(
      dealers,
    ); // this is because when user tap on dealer card after searching from list
    // // the searched data retained in dealerForBottomList. so we have to reset
    // //this list with all data again.
    AppNavigation.goBack();
  }

  Future<void> addStock(bool isFromStockListing) async {
    if (!validateData() || proccessing.value) return;

    proccessing.value = true;
    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';
    final stockData = {
      'dairy_id': dairyId,
      "item_id": foodId,
      "dealer_id": searchedDealer.id,
      "quantity": foodQuantity.text,
      "purchase_price": foodBuyRate.text,
      'selling_price': foodSaleRate.text,
      'unit': 'kg',
      'purchase_date': selectedDateString.value,
    };

    try {
      var response = await _addFoodStockUsecase(stockData);

      _proccessResponse(response, isFromStockListing);
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      proccessing.value = false;
    }
  }

  Future<void> updateStock() async {
    if (!validateData() || proccessing.value) return;

    proccessing.value = true;
    // final String dairyId =
    //     await SharedPrefsService.instance.getDairyId() ?? '0';
    final dealerData = {
      // 'dairy_id': dairyId,
      'dealer_id': AppState.currentStockHistoryItem.dealerId,
      "stock_id": AppState.currentStockHistoryItem.stockId,
      "quantity": foodQuantity.text,
      "purchase_price": foodBuyRate.text,
      "selling_price": foodSaleRate.text,
      "purchase_date": selectedDateString.value,

      'unit': 'kg',
    };
    try {
      var response = await _updateFoodStockUsecase(dealerData);
      _proccessResponse(response, null);
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      proccessing.value = false;
    }
  }

  _proccessResponse(var response, bool? isFromStockListing) async {
    if (response['success']) {
      if (isFromStockListing == null || isFromStockListing == false) {
        // this is the case if user came from stock history
        final foodStockHistoryController =
            Get.find<FoodStockHistoryController>();
        showAppToastMessage(response['message'], false);

        await foodStockHistoryController.getFoodtStockHistory();
      } else {
        // this is the case if user came from stock listing
        final foodStockController = Get.find<FoodStockController>();
        showAppToastMessage(response['message'], false);

        await foodStockController.getFoodtStock();
      }

      AppNavigation.goBack();
    } else {
      showAppToastMessage(response['message'], true);
    }
  }
}

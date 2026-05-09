import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart' show AppExceptionHandler;
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/app_validations.dart';
import 'package:DairyVikas/features/food/data/models/sale_model.dart';
import 'package:DairyVikas/features/food/data/models/supplier_buyer_model.dart';
import 'package:DairyVikas/features/food/presentation/controllers/food_sales_controller.dart';
import 'package:DairyVikas/features/milk_sale/data/models/milk_buyer_model.dart';
import 'package:DairyVikas/features/milk_sale/domain/usecases/get_all_milk_buyers_usecase.dart';
import 'package:DairyVikas/features/milk_suppliers/data/model/milk_supplier_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/local_datasources/local_storage_service.dart';
import '../../../milk_sale/data/models/milk_buyers_response_model.dart';
import '../../data/models/stock_model.dart';
import '../../domain/usecases/add_food_sale_usecase.dart';
import '../../domain/usecases/get_food_stock_usecase.dart';
import '../../domain/usecases/update_sale_usecase.dart';

class AddFoodSaleController extends GetxController with CommonMixin {
  final UpdateSaleUsecase _updateSaleUsecase;
  final GetAllMilkBuyersUsecase _getAllMilkBuyersUsecase;
  final GetFoodStockUsecase getFoodStockUsecase;
  final AddFoodSaleUsecase addFoodSaleUsecase;
  String validationErrorMessage = '';
  RxBool hasFieldError = false.obs;
  RxBool isSupplierBuyerFoundByCode = false.obs;
  AppValidation appValidation = AppValidation();
  RxBool proccessing = false.obs;
  RxBool isLoading = true.obs;
  final supllierOrBuyerCode = TextEditingController();

  final foodName = TextEditingController();
  final foodQuantity = TextEditingController();
  final foodSellingRate = TextEditingController();
  final receiptNumber = TextEditingController();
  final saleAmount = TextEditingController();
  RxString selectedDateString = ''.obs;
  RxBool isSupplierBuyerInActive = false.obs;
  SupplierBuyerModel searchedSupplierBuyer = SupplierBuyerModel.empty();
  List<SupplierBuyerModel> supplierAndBuyers = <SupplierBuyerModel>[];

  List<SupplierBuyerModel> supplierAndBuyersForBottomList =
      <SupplierBuyerModel>[];
  MilkBuyerResponseModel milkBuyersResponseModel =
      MilkBuyerResponseModel.empty();
  List<MilkBuyerModel> buyers = <MilkBuyerModel>[];
  RxList<StockModel> vendorFoodStock = <StockModel>[].obs;
  RxList<StockModel> filteredvendorFoodStock = <StockModel>[].obs;
  StockModel selectFoodItem = StockModel.empty();
  AddFoodSaleController(
    this._updateSaleUsecase,
    this._getAllMilkBuyersUsecase,
    this.getFoodStockUsecase,
    this.addFoodSaleUsecase,
  );

  @override
  void onInit() {
    _firstMethod();
    super.onInit();
  }

  _firstMethod() async {
    if (!AppState.isFoodSaleEdit) {
      selectedDateString.value = formatDateforApi(
        DateTime.now(),
      ); // add this only if vendor add the food sale. not in edit case.
    }

    await Future.wait([getAllMilkBuyers(), getVendorFoodtStock()]);
    addAllSupplierAndBuyersInCommonList();

    if (AppState.isFoodSaleEdit) {
      setSaleDataForUpdate(); // call is here because at this point we have all data from above functions.
    }
    isLoading.value = false;
  }

  Future getVendorFoodtStock() async {
    try {
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      Map response = await getFoodStockUsecase(dairyId);

      if (response['success']) {
        vendorFoodStock.clear();

        List stocksJson = response['data']['stock'] as List;

        vendorFoodStock.assignAll(
          stocksJson.map((item) => StockModel.fromJson(item)).toList(),
        );
        filteredvendorFoodStock.assignAll(vendorFoodStock);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    }
  }

  void addAllSupplierAndBuyersInCommonList() {
    final List<MilkSupplierModel> suppliers = AppState.milkSuppliers;

    final supplierItems = suppliers.map(
      (s) => SupplierBuyerModel(
        id: int.tryParse(s.id) ?? 0,
        name: s.supplierName,
        code: s.milkSupplierCode,
        mobile: s.supplierMobile,
        type: 'ms',
        status: s.status,
      ),
    );

    final buyerItems = buyers.map(
      (b) => SupplierBuyerModel(
        id: b.id,
        name: b.buyerName,
        code: b.milkBuyerCode,
        mobile: b.buyerMobile,
        type: 'mb',
        status: b.status,
      ),
    );

    supplierAndBuyers
      ..clear()
      ..addAll(supplierItems)
      ..addAll(buyerItems);
    supplierAndBuyersForBottomList.clear();
    supplierAndBuyersForBottomList.assignAll(supplierAndBuyers);
    supplierAndBuyersForBottomList.shuffle();
  }

  Future getAllMilkBuyers() async {
    try {
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      Map response = await _getAllMilkBuyersUsecase(dairyId);

      if (response['success']) {
        milkBuyersResponseModel = MilkBuyerResponseModel.fromJson(
          response['data'],
        );

        buyers.addAll(milkBuyersResponseModel.buyers);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    }
  }

  pickDateForFilter(BuildContext context) async {
    if (AppState.isFoodSaleEdit) {
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

  void setSaleDataForUpdate() {
    SaleModel sale = AppState.currentFoodSale;

    selectedDateString.value = sale.saleDate;
    if (sale.buyerId == null) {
      searchedSupplierBuyer = supplierAndBuyers.firstWhere(
        (sb) => sb.id == sale.supplierId,
        orElse: () => SupplierBuyerModel.empty(),
      );
    } else {
      searchedSupplierBuyer = supplierAndBuyers.firstWhere(
        (sb) => sb.id == sale.buyerId,
        orElse: () => SupplierBuyerModel.empty(),
      );
    }
    supllierOrBuyerCode.text = searchedSupplierBuyer.code;
    if (supllierOrBuyerCode.text.isNotEmpty) {
      isSupplierBuyerFoundByCode.value = true;
    }

    selectFoodItem = vendorFoodStock.firstWhere(
      (item) => item.itemId == sale.saleItemDetails.id,
      orElse: () => StockModel.empty(),
    );
    foodName.text = selectFoodItem.itemName;
    foodQuantity.text = sale.quantity.toString();
    foodSellingRate.text = sale.sellingPrice.toString();
    saleAmount.text = (sale.quantity * sale.sellingPrice).toString();
    update();
  }

  calculateSaleAmount() {
    saleAmount.text =
        ((int.tryParse(foodQuantity.text) ?? 0) *
                (int.tryParse(foodSellingRate.text) ?? 0))
            .toString();
  }

  bool validateData() {
    final codeError = appValidation.validateCustomerCode(
      supllierOrBuyerCode.text,
    );

    if (codeError != null) {
      _showErrorBox('please_select_customer');
      return false;
    }

    if (selectFoodItem.itemId == 0) {
      _showErrorBox('select_food_item');
      return false;
    }
    if (foodQuantity.text.trim().isEmpty) {
      _showErrorBox('enter_food_qty');
      return false;
    }

    if (foodSellingRate.text.trim().isEmpty) {
      _showErrorBox('enter_food_selling_price');
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

  searchSupplierBuyerInList(String searchTerm) {
    supplierAndBuyersForBottomList.assignAll(
      supplierAndBuyers.where(
        (sb) =>
            sb.name.toLowerCase().startsWith(searchTerm.toLowerCase()) ||
            sb.code.toLowerCase().startsWith(searchTerm.toLowerCase()) ||
            sb.mobile.toLowerCase().startsWith(searchTerm.toLowerCase()),
      ),
    );
    update();
  }

  searchFoodItemInList(String searchTerm) {
    filteredvendorFoodStock.assignAll(
      vendorFoodStock.where(
        (fs) => fs.itemName.toLowerCase().startsWith(searchTerm.toLowerCase()),
      ),
    );
    update();
  }

  searchSupplierOrBuyerToAddFoodSaleOf(String code) {
    if (code.isEmpty) {
      isSupplierBuyerFoundByCode.value = false;
      isSupplierBuyerInActive.value = false;
      update();
      return;
    }
    searchedSupplierBuyer = supplierAndBuyers.firstWhere(
      (sb) => sb.code == code.trim(),
      orElse: () => SupplierBuyerModel.empty(),
    );
    if (searchedSupplierBuyer.id == 0) {
      isSupplierBuyerFoundByCode.value = false;
    } else {
      if (searchedSupplierBuyer.status) {
        isSupplierBuyerInActive.value = false;
      } else {
        isSupplierBuyerInActive.value = true;
      }
      isSupplierBuyerFoundByCode.value = true;
    }

    update();
  }

  selectSupplierBuyerBySearchingInList(SupplierBuyerModel sb) {
    searchSupplierOrBuyerToAddFoodSaleOf(sb.code);
    supllierOrBuyerCode.text = sb.code;
    supplierAndBuyersForBottomList.clear();
    supplierAndBuyersForBottomList.assignAll(
      supplierAndBuyers,
    ); // this is because when user tap on supplierbuyer card after searching from list
    // // the searched data retained in suppierbuyerForBottomList. so we have to reset
    // //this list with all data again.
    AppNavigation.goBack();
  }

  Future<void> addNewFoodSale() async {
    if (!validateData() || proccessing.value) return;

    proccessing.value = true;
    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';
    final saleData = {
      "sale_date": selectedDateString.value,
      'dairy_id': dairyId,
      "item_id": selectFoodItem.itemId,
      "quantity": foodQuantity.text.trim(),
      "selling_price": foodSellingRate.text.trim(),
      "buyer_id": searchedSupplierBuyer.type == 'mb'
          ? searchedSupplierBuyer.id
          : null,
      "supplier_id": searchedSupplierBuyer.type == 'ms'
          ? searchedSupplierBuyer.id
          : null,
    };

    try {
      var response = await addFoodSaleUsecase(saleData);

      _proccessResponse(response);
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      proccessing.value = false;
    }
  }

  Future<void> updateFoodSale() async {
    if (!validateData() || proccessing.value) return;

    proccessing.value = true;
    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';
    final saleData = {
      'dairy_id': dairyId,
      "item_id": selectFoodItem.itemId,
      "quantity": foodQuantity.text.trim(),
      "selling_price": foodSellingRate.text.trim(),
      "buyer_id": searchedSupplierBuyer.type == 'mb'
          ? searchedSupplierBuyer.id
          : null,
      "supplier_id": searchedSupplierBuyer.type == 'ms'
          ? searchedSupplierBuyer.id
          : null,
      "sale_id": AppState.currentFoodSale.id,
    };
    try {
      var response = await _updateSaleUsecase(saleData);
      _proccessResponse(response);
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      proccessing.value = false;
    }
  }

  _proccessResponse(var response) async {
    if (response['success']) {
      final foodSaleController = Get.find<FoodSalesController>();
      showAppToastMessage(response['message'], false);

      await foodSaleController.getFoodtSales();

      AppNavigation.goBack();
    } else {
      showAppToastMessage(response['message'], true);
    }
  }
}

import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/features/milk_sale/data/models/milk_sale_model.dart';
import 'package:DairyVikas/features/milk_sale/domain/usecases/get_all_milksales_usecase.dart';
import 'package:DairyVikas/features/milk_suppliers/data/model/milk_suppliers_response_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AllMilkSalesControllers extends GetxController with CommonMixin {
  final GetAllMilksalesUsecase getAllMilksalesUsecase;

  final RxDouble avgFat = 0.0.obs;
  final RxDouble avgSnf = 0.0.obs;
  final RxDouble avgClr = 0.0.obs;
  final RxDouble avgRate = 0.0.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxDouble totalLitre = 0.0.obs;
  RxBool hasError = false.obs;
  RxBool isShowFullDataOpen = false.obs;
  RxInt currentStatusFilterIndex = 0.obs;
  RxList<MilkSaleModel> allMilkSales = <MilkSaleModel>[].obs;
  RxBool isLoading = false.obs;

  RxList<MilkSaleModel> filteredMilkSales = <MilkSaleModel>[].obs;
  MilkSuppliersResponseModel milkSuppliersResponseModel =
      MilkSuppliersResponseModel.empty();
  RxMap<String, dynamic> selectedMilkType = <String, dynamic>{}.obs;
  RxMap<String, dynamic> selectedShift = <String, dynamic>{}.obs;

  RxList<Map<String, dynamic>> shiftFilters = <Map<String, dynamic>>[
    {"id": 0, "name": 'all (shifts)'},
  ].obs;
  RxList<Map<String, dynamic>> milkTypes = <Map<String, dynamic>>[
    {"id": '0', "value": 'all (milk)'},
    {"id": '1', "value": "cow"},
    {"id": '2', "value": "buffalo"},
  ].obs;

  RxMap<String, dynamic> selectedSortBy = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> sortBy = <Map<String, dynamic>>[
    {"id": '1', "value": "sort_by_time"},
    {"id": '2', "value": "sort_by_amount_ascending"},
    {"id": '3', "value": "sort_by_amount_descending"},
  ].obs;

  RxString selectedStatus = '0'.obs;
  RxString curentDate = ''.obs;
  TextEditingController searchController = TextEditingController();
  RxList<Map<String, dynamic>> statusFilters = <Map<String, dynamic>>[
    {"id": '0', "title": 'all'},
    {"id": '1', "title": 'active'},
    {"id": '2', "title": 'inactive'},
  ].obs;

  AllMilkSalesControllers(this.getAllMilksalesUsecase);
  @override
  void onInit() {
    selectedMilkType.value = milkTypes[0];

    selectedShift.value = shiftFilters[0];
    shiftFilters.addAll(AppState.shifts);
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    curentDate.value = formatDateforApi(DateTime.now());
    await getAllMilkSale();
  }

  pickDateForFilter(BuildContext context) async {
    curentDate.value =
        await pickDate(
          context: context,
          initialDate: curentDate.value.isNotEmpty
              ? DateTime.tryParse(curentDate.value)
              : DateTime.now(),
        ) ??
        formatDateforApi(DateTime.now());

    await getAllMilkSale();
  }

  Future<void> getAllMilkSale() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';

      var response = await getAllMilksalesUsecase(dairyId, curentDate.value);

      if (response['success']) {
        List sales = response['data'] as List;
        hasError.value = false;
        allMilkSales.clear();
        allMilkSales.addAll(
          sales.map((sale) => MilkSaleModel.fromJson(sale)).toList(),
        );

        filteredMilkSales.assignAll(allMilkSales);
        calculateTotalAndAvg();
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

  calculateTotalAndAvg() {
    calculateTotals();
    calculateDairyAverages();
  }

  void calculateTotals() {
    double amount = 0.0;
    double litre = 0.0;

    for (final item in filteredMilkSales) {
      final double ltr = (item.litre as num).toDouble();
      final double a = (item.totalAmount).toDouble();

      litre += ltr;
      amount += a;
    }

    totalLitre.value = litre;

    totalAmount.value = amount;
  }

  void calculateDairyAverages() {
    if (filteredMilkSales.isEmpty) return;

    double fatWeighted = 0.0;
    double clrWeighted = 0.0;
    double snfWeighted = 0.0;
    double totalAmount = 0.0;
    double totalLitre = 0.0;

    for (final item in filteredMilkSales) {
      final double litre = (item.litre as num).toDouble();
      final double fat = (item.fat as num).toDouble();
      final double clr = ((item.clr ?? 0) as num).toDouble();
      final double snf = ((item.snf ?? 0) as num).toDouble();
      final double amount = (item.totalAmount as num).toDouble();

      totalLitre += litre;
      fatWeighted += litre * fat;
      clrWeighted += litre * clr;
      snfWeighted += litre * snf;
      totalAmount += amount;
    }

    avgFat.value = fatWeighted / totalLitre;
    avgClr.value = clrWeighted / totalLitre;
    avgSnf.value = snfWeighted / totalLitre;
    avgRate.value = totalAmount / totalLitre;
  }

  searchMilkSale(String searchTerm) {
    filteredMilkSales.assignAll(
      allMilkSales.where(
        (sale) =>
            sale.saleBuyer.buyerName.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ) ||
            sale.saleBuyer.milkBuyerCode.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ) ||
            sale.totalAmount.toString().startsWith(searchTerm.toLowerCase()),
      ),
    );
    calculateTotalAndAvg();
    // update();
  }

  // sortMilkSales() {
  //   if (selectedSortBy['id'] == '2') {
  //     filteredMilkSales.sort((a, b) {
  //       final aAmt = (a.totalAmount as num).toDouble();
  //       final bAmt = (b.totalAmount as num).toDouble();
  //       return aAmt.compareTo(bAmt);
  //     });
  //   } else if (selectedSortBy['id'] == '3') {
  //     filteredMilkSales.sort((a, b) {
  //       final aAmt = (a.totalAmount as num).toDouble();
  //       final bAmt = (b.totalAmount as num).toDouble();
  //       return bAmt.compareTo(aAmt);
  //     });
  //   } else {}

  //   AppNavigation.goBack();
  //   update();
  // }

  void filterMilkSales() {
    filteredMilkSales.assignAll(
      allMilkSales.where((item) {
        final bool milkMatch =
            selectedMilkType['id'].toString() == '0' ||
            item.milkTypeId.toString() == selectedMilkType['id'].toString();

        final bool shiftMatch =
            selectedShift['id'].toString() == '0' ||
            item.shiftId.toString() == selectedShift['id'].toString();

        return milkMatch && shiftMatch;
      }).toList(),
    );

    calculateTotalAndAvg();
  }
}

import 'dart:convert';

import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/features/collection/domain/usecases/get_collection_adjusments_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/local_datasources/app_state.dart';
import '../../../milk_suppliers/data/model/milk_supplier_model.dart';
import '../../../milk_suppliers/domain/usecases/get_all_milk_suppliers_usecase.dart';

class AdjustCollectionController extends GetxController with CommonMixin {
  final GetCollectionAdjusmentsUsecase getCollectionAdjusmentsUsecase;
  final GetAllMilkSuppliersUsecase getAllMilkSuppliersUsecase;

  RxBool isLoading = true.obs;
  RxBool showBottomBox = false.obs;
  RxBool hasError = false.obs;
  RxBool isSupplierFoundByCode = false.obs;
  RxBool isSupplierInActive = false.obs;
  final supplierCode = TextEditingController();
  List<MilkSupplierModel> milkSuppliers = <MilkSupplierModel>[];
  RxList<MilkSupplierModel> filteredmMlkSuppliers = <MilkSupplierModel>[].obs;
  MilkSupplierModel searchedSupplier = MilkSupplierModel.empty();
  TextEditingController searchController = TextEditingController();
  RxBool isShowFullDataOpen = false.obs;

  RxMap selectedDateRange = {}.obs;
  RxInt currentDateRangeIndex = 0.obs;
  String morningShiftKey = 'MORNING';

  String cowKey = 'COW';

  final RxDouble avgFat = 0.0.obs;
  final RxDouble avgSnf = 0.0.obs;
  final RxDouble avgClr = 0.0.obs;
  final RxDouble avgRate = 0.0.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxDouble totalLitre = 0.0.obs;

  RxList supplierCollection = [].obs;

  AdjustCollectionController(
    this.getCollectionAdjusmentsUsecase,

    this.getAllMilkSuppliersUsecase,
  );

  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    await getMilkSuppliers();
    if (AppState.dateRanges.isNotEmpty) {
      selectedDateRange.addAll(AppState.dateRanges[0]);
    }
    isLoading.value = false;
  }

  Future getMilkSuppliers() async {
    try {
      milkSuppliers = AppState.milkSuppliers;
      filteredmMlkSuppliers.assignAll(milkSuppliers);
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    }
  }

  Widget getShiftIcon(String key) {
    return key.contains(morningShiftKey)
        ? SizedBox(width: 18, height: 18, child: AppIcons.morning())
        : SizedBox(width: 15, height: 15, child: AppIcons.evening());
  }

  Widget getMilkTypeIcon(String key) {
    return key.contains(cowKey)
        ? SizedBox(width: 17, height: 17, child: AppIcons.cow())
        : SizedBox(width: 18, height: 18, child: AppIcons.buffalo());
  }

  bool validateData() {
    if (supplierCode.text.isEmpty) {
      showAppToastMessage('select_a_supplier_first', true);
      return false;
    }

    if (isSupplierInActive.value) {
      showAppToastMessage(
        'is_inactive'.trParams({'name': searchedSupplier.supplierName}),
        true,
      );
      return false;
    }

    return true;
  }

  Future<void> getCollectionsForAdjusment() async {
    try {
      if (!validateData() || isLoading.value) return;
      if (supplierCode.text.isEmpty) {
        showAppToastMessage('select_a_supplier_first', true);
        return;
      }
      isLoading.value = true;

      var response = await getCollectionAdjusmentsUsecase(
        searchedSupplier.id,
        selectedDateRange['start'],
        selectedDateRange['end'],
      );

      if (response['success']) {
        supplierCollection.clear();
        showBottomBox.value = true;
        hasError.value = false;
        Map collections = response['data'];

        for (var item in collections.entries) {
          List data = [];
          double totalAmount = 0.0;
          Map dailyCollection = {
            "row_date": "",
            "date": "",
            "total_amount": "",
            'data': [
              {
                'id': "",
                "supplier_id": "",
                "shift_id": "",
                "milk_type_id": "",
                "rate_per_litre": "",
                "collection_date": "",
                "total_amount": "",
                'sample_count': "",
                'shift_icon': "",
                'milk_type_icon': "",
                'fat': "",
                'clr': "",
                "snf": "",
                "ltr": "",
                "rate": "",
                'can_data': [],
              },
            ],
          };
          String completeDate = '';
          String weekday = getWeekDay(item.key);
          String formatedDate = formatDate(item.key);
          completeDate = '$formatedDate, $weekday';

          dailyCollection['date'] = completeDate;
          dailyCollection['row_date'] = item.key;

          Map dayCollection = item.value;

          for (var singleCollection in dayCollection.entries) {
            Map singleCollectionMap = {
              'id': "",
              "supplier_id": "",
              "shift_id": "",
              "milk_type_id": "",
              "rate_per_litre": "",
              "total_amount": "",
              "collection_date": "",
              'shift_icon': "",
              'milk_type_icon': "",
              'sample_count': "",
              'fat': "",
              'clr': "",
              "snf": "",
              "ltr": "",
              "rate": "",
              'can_data': [],
            };
            String key = singleCollection.key;
            List? value = singleCollection.value;
            Widget shiftWidget = getShiftIcon(key);
            Widget milkTypeWidget = getMilkTypeIcon(key);
            if (value == null) {
              singleCollectionMap['shift_icon'] = shiftWidget;
              singleCollectionMap['milk_type_icon'] = milkTypeWidget;
              singleCollectionMap['fat'] = '0';
              singleCollectionMap['snf'] = '0';

              singleCollectionMap['clr'] = '0';
              singleCollectionMap['ltr'] = '0';

              singleCollectionMap['rate'] = '0';
              data.add(singleCollectionMap);
            } else {
              var singleCollectionJson = value[0];
              singleCollectionMap['shift_icon'] = shiftWidget;
              singleCollectionMap['milk_type_icon'] = milkTypeWidget;
              singleCollectionMap['id'] = singleCollectionJson['id'];
              singleCollectionMap['supplier_id'] =
                  singleCollectionJson['supplier_id'];
              singleCollectionMap['milk_type_id'] =
                  singleCollectionJson['milk_type_id'];
              singleCollectionMap['shift_id'] =
                  singleCollectionJson['shift_id'];
              singleCollectionMap['rate_per_litre'] =
                  singleCollectionJson['rate_per_litre'];
              singleCollectionMap['total_amount'] =
                  singleCollectionJson['total_amount'];
              singleCollectionMap['sample_count'] =
                  singleCollectionJson['sample_count'];
              singleCollectionMap['collection_date'] =
                  singleCollectionJson['collection_date'];

              singleCollectionMap['fat'] = singleCollectionJson['fat'];
              singleCollectionMap['snf'] = singleCollectionJson['snf'] ?? '0';

              singleCollectionMap['clr'] = singleCollectionJson['clr'] ?? '0';
              singleCollectionMap['ltr'] = singleCollectionJson['litre'];

              singleCollectionMap['rate'] =
                  singleCollectionJson['rate_per_litre'];

              if (singleCollectionJson['can_data'] != null ||
                  singleCollectionJson['can_data'].toString().isNotEmpty) {
                List canSteps = jsonDecode(singleCollectionJson['can_data']);
                singleCollectionMap['can_data'] = canSteps;
              }

              totalAmount += singleCollectionJson['total_amount'] ?? 0.0;
              data.add(singleCollectionMap);
            }
          }

          dailyCollection['data'] = data;
          dailyCollection['total_amount'] = totalAmount;
          supplierCollection.add(dailyCollection);
        }
        if (supplierCollection.isNotEmpty) {
          calculateDataTotalAndAvg();
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

  searchSuppliers(String code) {
    if (code.isEmpty) {
      isSupplierFoundByCode.value = false;
      isSupplierInActive.value = false;
      supplierCollection.clear();
      update();
      return;
    }
    searchedSupplier = milkSuppliers.firstWhere(
      (supplier) => supplier.milkSupplierCode == code.trim(),
      orElse: () => MilkSupplierModel.empty(),
    );
    if (searchedSupplier.id.isEmpty) {
      isSupplierFoundByCode.value = false;
    } else {
      if (searchedSupplier.status) {
        isSupplierInActive.value = false;
      } else {
        isSupplierInActive.value = true;
      }
      isSupplierFoundByCode.value = true;
    }
    update();
  }

  selectDateRange(int index) async {
    currentDateRangeIndex.value = index;
    selectedDateRange.value = AppState.dateRanges[currentDateRangeIndex.value];
    AppNavigation.goBack();
    await getCollectionsForAdjusment();
  }

  selectSupplierFromList(MilkSupplierModel supplier) async {
    supplierCode.text = supplier.milkSupplierCode;
    searchSuppliers(supplier.milkSupplierCode);
    AppNavigation.goBack();
    await Future.delayed(Duration(milliseconds: 350), () {
      getCollectionsForAdjusment();
    });
  }

  searchSupplierInList(String searchTerm) {
    filteredmMlkSuppliers.assignAll(
      milkSuppliers.where(
        (supplier) =>
            supplier.supplierName.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ) ||
            supplier.milkSupplierCode.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ) ||
            supplier.supplierMobile.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ),
      ),
    );
    update();
  }

  calculateDataTotalAndAvg() {
    calculateTotals();
    calculateAverages();
  }

  void calculateTotals() {
    double amount = 0.0;
    double litre = 0.0;

    for (final day in supplierCollection) {
      amount += day['total_amount'] ?? 0.0;
      final List data = day['data'] ?? [];

      for (final row in data) {
        litre += row['ltr'] == '-'
            ? 0.0
            : double.tryParse(row['ltr'].toString()) ?? 0.0;
      }
    }

    totalLitre.value = litre;

    totalAmount.value = amount;
  }

  void calculateAverages() {
    double totalLiter = 0.0;

    double fatSum = 0.0;
    double snfSum = 0.0;
    double clrSum = 0.0;
    double rateSum = 0.0;

    for (final day in supplierCollection) {
      final List data = day['data'] ?? [];

      for (final row in data) {
        final double liter = row['ltr'] == '-'
            ? 0.0
            : double.tryParse(row['ltr'].toString()) ?? 0.0;
        if (liter == 0) continue;

        totalLiter += liter;

        fatSum +=
            (row['fat'] == '-'
                ? 0.0
                : double.tryParse(row['fat'].toString()) ?? 0.0) *
            liter;
        snfSum +=
            (row['snf'] == '-'
                ? 0.0
                : double.tryParse(row['snf'].toString()) ?? 0.0) *
            liter;
        clrSum +=
            (row['clr'] == '-'
                ? 0.0
                : double.tryParse(row['clr'].toString()) ?? 0.0) *
            liter;
        rateSum +=
            (row['rate'] == '-'
                ? 0.0
                : double.tryParse(row['rate'].toString()) ?? 0.0) *
            liter;
      }
    }

    if (totalLiter == 0) {
      avgFat.value = 0.0;
      avgSnf.value = 0.0;
      avgClr.value = 0.0;
      avgRate.value = 0.0;
    } else {
      avgFat.value = fatSum / totalLiter;
      avgSnf.value = snfSum / totalLiter;
      avgClr.value = clrSum / totalLiter;
      avgRate.value = rateSum / totalLiter;
    }
  }
}

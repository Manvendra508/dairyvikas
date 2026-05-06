import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/error/exceptions.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/local_datasources/local_storage_service.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/features/collection/data/model/collection_model.dart';
import 'package:dairysathi/features/collection/domain/usecases/get_all_collection_usecase.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AllCollectionController extends GetxController with CommonMixin {
  final GetAllCollectionUsecase getAllCollectionUsecase;
  final RxDouble avgFat = 0.0.obs;
  final RxDouble avgSnf = 0.0.obs;
  final RxDouble avgClr = 0.0.obs;
  final RxDouble avgRate = 0.0.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxDouble totalLitre = 0.0.obs;
  RxBool hasError = false.obs;
  RxBool isShowFullDataOpen = false.obs;
  RxInt currentStatusFilterIndex = 0.obs;
  RxList<CollectionModel> allCollections = <CollectionModel>[].obs;
  RxBool isLoading = false.obs;

  RxList<CollectionModel> filteredCollectionsList = <CollectionModel>[].obs;

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
  int absentSuppliersCount = 0;
  int presentSuppliersCount = 0;
  int totalSuppliersCount = 0;
  TextEditingController searchController = TextEditingController();
  RxList<Map<String, dynamic>> statusFilters = <Map<String, dynamic>>[
    {"id": '0', "title": 'all'},
    {"id": '1', "title": 'active'},
    {"id": '2', "title": 'inactive'},
  ].obs;

  AllCollectionController(this.getAllCollectionUsecase);
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
    await getAllCollection();
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

    await getAllCollection();
  }

  Future<void> getAllCollection() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';

      var response = await getAllCollectionUsecase(dairyId, curentDate.value);

      if (response['success']) {
        List collections = response['data']['collections'] as List;
        hasError.value = false;
        allCollections.clear();
        allCollections.addAll(
          collections.map((colle) => CollectionModel.fromJson(colle)).toList(),
        );

        filteredCollectionsList.assignAll(allCollections);

        calculateTotalAndAvg();
        Map supplierAttendance = response['data']['supplierAttendance'];
        absentSuppliersCount = supplierAttendance['absent'] ?? 0;
        presentSuppliersCount = supplierAttendance['present'] ?? 0;
        totalSuppliersCount = supplierAttendance['total'] ?? 0;
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

    for (final item in filteredCollectionsList) {
      final double ltr = (item.litre as num).toDouble();
      final double a = (item.totalAmount).toDouble();

      litre += ltr;
      amount += a;
    }

    totalLitre.value = litre;

    totalAmount.value = amount;
  }

  void calculateDairyAverages() {
    if (filteredCollectionsList.isEmpty) return;

    double fatWeighted = 0.0;
    double clrWeighted = 0.0;
    double snfWeighted = 0.0;
    double totalAmount = 0.0;
    double totalLitre = 0.0;

    for (final item in filteredCollectionsList) {
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

  searchCollection(String searchTerm) {
    filteredCollectionsList.assignAll(
      allCollections.where(
        (collection) =>
            collection.collectionSupplier.supplierName.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ) ||
            collection.collectionSupplier.milkSupplierCode
                .toLowerCase()
                .startsWith(searchTerm.toLowerCase()) ||
            collection.totalAmount.toString().startsWith(
              searchTerm.toLowerCase(),
            ),
      ),
    );
    calculateTotalAndAvg();
    // update();
  }

  sortCollections() {
    if (selectedSortBy['id'] == '2') {
      filteredCollectionsList.sort((a, b) {
        final aAmt = (a.totalAmount as num).toDouble();
        final bAmt = (b.totalAmount as num).toDouble();
        return aAmt.compareTo(bAmt);
      });
    } else if (selectedSortBy['id'] == '3') {
      filteredCollectionsList.sort((a, b) {
        final aAmt = (a.totalAmount as num).toDouble();
        final bAmt = (b.totalAmount as num).toDouble();
        return bAmt.compareTo(aAmt);
      });
    } else {}

    AppNavigation.goBack();
    update();
  }

  void filterCollections() {
    filteredCollectionsList.assignAll(
      allCollections.where((item) {
        final bool milkMatch =
            selectedMilkType['id'].toString() == '0' ||
            item.milkTypeId.toString() == selectedMilkType['id'].toString();

        final bool shiftMatch =
            selectedShift['id'].toString() == '0' ||
            item.collectionShiftId.toString() == selectedShift['id'].toString();

        return milkMatch && shiftMatch;
      }).toList(),
    );

    calculateTotalAndAvg();
  }
}

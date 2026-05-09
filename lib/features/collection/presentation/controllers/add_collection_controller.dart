import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/features/collection/data/model/assigned_chart_model.dart';
import 'package:DairyVikas/features/collection/data/model/assignment_model.dart';
import 'package:DairyVikas/features/collection/data/model/collection_model.dart';
import 'package:DairyVikas/features/collection/domain/usecases/add_collection_usecase.dart';
import 'package:DairyVikas/features/collection/domain/usecases/delete_collection_usecase.dart';
import 'package:DairyVikas/features/collection/domain/usecases/update_collection_usecase.dart';
import 'package:DairyVikas/features/collection/presentation/controllers/adjust_collection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/select_bool_option_widget.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/local_datasources/local_storage_service.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../core/utils/app_navigation.dart';
import '../../../milk_suppliers/data/model/milk_supplier_model.dart';
import '../../../milk_suppliers/domain/usecases/get_all_milk_suppliers_usecase.dart';
import '../../../rate_cart/data/model/rate_chart_values_model.dart';
import '../../data/model/collection_can_model.dart';
import '../../domain/usecases/get_assigned_charts_usecase.dart';
import 'all_collection_controller.dart';

class AddNewCollectionController extends GetxController with CommonMixin {
  final GetAllssignedChartsUsecase getAllssignedChartsUsecase;
  final GetAllMilkSuppliersUsecase getAllMilkSuppliersUsecase;
  final AddCollectionUsecase addCollectionUsecase;
  final UpdateCollectionUsecase updateCollectionUsecase;
  final DeleteCollectionUsecase _deleteCollectionUsecase;

  double literPerviousValue = 0.0;

  RxBool proccessing = false.obs;
  RxBool isLoading = true.obs;
  bool isSupplierFoundByCode = false;
  RxBool isSupplierInActive = false.obs;
  RxBool isDeleting = false.obs;
  final supplierCode = TextEditingController();
  final fatController = TextEditingController();
  final snfController = TextEditingController();
  final clrController = TextEditingController();
  final literController = TextEditingController();
  final previousValueController = TextEditingController(text: '0');
  final rateController = TextEditingController();
  final wScaleController = TextEditingController();
  final canController = TextEditingController(text: '1');
  RxString createTempTotalValueOfLiter = '0'.obs;

  RxString selectedDateString = ''.obs;
  String rateChartValueId = '';
  AssignChartModel? foundChartForDairyOrSuppliers;
  RxList<String> samples = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ].obs;
  RxString selectedSampleValue = '1'.obs;
  RxMap<String, dynamic> selectedShift = <String, dynamic>{}.obs;
  RxMap<String, dynamic> selectedMilkType = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> milkTypes = <Map<String, dynamic>>[
    {"id": '1', "value": 'cow', 'icon': AppIcons.cow(size: 16)},
    {"id": '2', "value": 'buffalo', 'icon': AppIcons.buffalo(size: 16)},
  ].obs;

  List<MilkSupplierModel> milkSuppliers = <MilkSupplierModel>[];
  List<MilkSupplierModel> milkSuppliersForBottomList = <MilkSupplierModel>[];
  MilkSupplierModel searchedSupplier = MilkSupplierModel.empty();
  MilkCollectionCanModel can = MilkCollectionCanModel.empty();
  List<AssignChartModel> assignedCharts = <AssignChartModel>[];
  List<AssignmentModel> chartAssiignments = <AssignmentModel>[];

  List<RateChartValuesModel> chartValuesOfFoundSupplierAndDairy =
      <RateChartValuesModel>[];

  AddNewCollectionController(
    this.getAllssignedChartsUsecase,
    this.getAllMilkSuppliersUsecase,
    this.addCollectionUsecase,
    this.updateCollectionUsecase,
    this._deleteCollectionUsecase,
  );
  @override
  void onInit() {
    selectedShift.value = AppState.shifts[0];
    literController.addListener(() {
      update();
    });
    rateController.addListener(() {
      update();
    });
    firstMethod();
    super.onInit();
  }

  pickDateForFilter(BuildContext context) async {
    if (AppState.isCollectionEdit) {
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

  Future firstMethod() async {
    if (!AppState.isCollectionEdit) {
      selectedDateString.value = formatDateforApi(
        DateTime.now(),
      ); // add this only if user add the collection. not in edit case.
    }
    await getAllAssignedRatecharts();
    await getAllMilkSuppliers();
    if (AppState.isCollectionEdit) {
      setDataForUpdateCollection();
    }
    isLoading.value = false;
  }

  setDataForUpdateCollection() {
    CollectionModel collectionForUpdate = AppState.currentCollectionforUpdate;

    if (collectionForUpdate.collectionId == 0) {
      selectedDateString.value = collectionForUpdate.collectionDate;
      supplierCode.text =
          collectionForUpdate.collectionSupplier.milkSupplierCode;
      searchSupplierToAddCollectionFor(supplierCode.text);
    } else {
      selectedMilkType.value = milkTypes.firstWhere(
        (mt) => mt['id'] == collectionForUpdate.milkTypeId.toString(),
      );

      selectedShift.value = AppState.shifts.firstWhere(
        (cs) => cs['id'] == collectionForUpdate.collectionShiftId,
      );
      literController.text = collectionForUpdate.litre.toString();
      fatController.text = collectionForUpdate.fat.toString();
      snfController.text = collectionForUpdate.snf.toString();
      clrController.text = collectionForUpdate.clr.toString();
      rateController.text = collectionForUpdate.ratePerLitre.toString();
      selectedDateString.value = collectionForUpdate.collectionDate;
      selectedSampleValue.value = collectionForUpdate.sampleCount.toString();
      supplierCode.text =
          collectionForUpdate.collectionSupplier.milkSupplierCode;
      searchSupplierToAddCollectionFor(supplierCode.text);
      can.steps.assignAll(collectionForUpdate.steps);
    }
  }

  Future getAllMilkSuppliers() async {
    milkSuppliers.addAll(AppState.milkSuppliers);
    milkSuppliersForBottomList.assignAll(
      milkSuppliers,
    ); // for search in the  bottom list
  }

  Future<void> getAllAssignedRatecharts() async {
    try {
      Map response = await getAllssignedChartsUsecase();

      if (response['success']) {
        var data = response['data'];
        List charts = data['charts'] as List;
        List assignments = data['assignments'] as List;

        assignedCharts.assignAll(
          charts.map((chart) => AssignChartModel.fromJson(chart)).toList(),
        );

        chartAssiignments.assignAll(
          assignments.map((as) => AssignmentModel.fromJson(as)).toList(),
        );
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    }
  }

  bool isValidate() {
    if (selectedDateString.value.isEmpty) {
      showAppToastMessage('select_a_date_to_add_collection', true);
      return false;
    }

    if (!isSupplierFoundByCode) {
      showAppToastMessage('select_a_supplier_first', true);
      return false;
    }

    if (isSupplierInActive.value) {
      showAppToastMessage('please_select_a_active_supplier', true);
      return false;
    }

    if (literController.text.isEmpty) {
      showAppToastMessage('please_add_collection_liter', true);
      return false;
    }

    if (fatController.text.isEmpty) {
      showAppToastMessage('please_add_fat_point', true);
      return false;
    }
    if (snfController.text.isEmpty) {
      // this can change form dairy center setting it can be for snf or for clr. it will be dynamic.
      showAppToastMessage('please_add_snf_or_clr_point', true);
      return false;
    }

    if (rateController.text.isEmpty) {
      // this can change form dairy center setting it can be for snf or for clr. it will be dynamic.
      showAppToastMessage('rate_is_empty', true);
      return false;
    }

    return true;
  }

  Future<Map> bodyDataTosend() async {
    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';

    Map json = {
      "dairy_id": dairyId,
      "supplier_id": searchedSupplier.id,
      "milk_type_id": int.parse(selectedMilkType['id']),
      "shift_id": selectedShift['id'],
      "litre": double.tryParse(literController.text.trim()),
      "fat": double.tryParse(fatController.text.trim()),
      "snf": double.tryParse(snfController.text.trim()),
      "clr": double.tryParse(clrController.text.trim()),
      "rate_per_litre": rateController.text,
      "collection_date": selectedDateString.value,
      "number_of_cans": can.steps.isEmpty ? 0 : can.steps.last.canNumber,
      "can_data": can.steps.map((step) => step.toJson()).toList(),
      "sample_count": selectedSampleValue.value,
      "rate_chart_id": foundChartForDairyOrSuppliers == null
          ? ''
          : foundChartForDairyOrSuppliers!.id,
      "rate_chart_detail_id": rateChartValueId,
    };
    if (AppState.isCollectionEdit &&
        AppState.currentCollectionforUpdate.supplierId != 0) {
      // It means edir should be true and collection should not be empty
      json.addAll({
        "collection_id": AppState.currentCollectionforUpdate.collectionId,
      });
    }
    return json;
  }

  Future<void> addOrUpdateCollection(bool isfromCollectionList) async {
    try {
      if (!isValidate() || proccessing.value) return;
      proccessing.value = true;
      Map bodyData = await bodyDataTosend();
      if (AppState.isCollectionEdit &&
          AppState.currentCollectionforUpdate.supplierId != 0) {
        // It means edir should be true and collection should not be empty
        var response = await updateCollectionUsecase(bodyData);
        _processResponse(response, isfromCollectionList);
      } else {
        var response = await addCollectionUsecase(bodyData);
        _processResponse(response, isfromCollectionList);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      proccessing.value = false;
    }
  }

  Future<void> removeColection(bool isfromCollectionList) async {
    if (isDeleting.value) return;

    isDeleting.value = true;

    try {
      var response = await _deleteCollectionUsecase(
        AppState.currentNoticePostForUpdate.id.toString(),
      );
      if (response['success']) {
        _processResponse(response, isfromCollectionList);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isDeleting.value = false;
    }
  }

  _processResponse(var response, bool isfromCollectionList) async {
    if (response['success']) {
      if (isfromCollectionList) {
        showAppToastMessage(response['message'], false);
        final allCollections = Get.find<AllCollectionController>();
        await allCollections.getAllCollection();
        AppNavigation.goBack();
      } else {
        showAppToastMessage(response['message'], false);
        final adjustmentCollectionController =
            Get.find<AdjustCollectionController>();
        await adjustmentCollectionController.getCollectionsForAdjusment();
        AppNavigation.goBack();
      }
    } else {
      showAppToastMessage(response['message'], true);
    }
  }

  _clearControllers() {
    fatController.clear();
    literController.clear();
    clrController.clear();
    snfController.clear();
    rateController.clear();
  }

  searchSupplierToAddCollectionFor(String code) {
    if (code.isEmpty) {
      isSupplierFoundByCode = false;
      isSupplierInActive.value = false;
      _clearControllers();
      update();
      return;
    }
    searchedSupplier = milkSuppliers.firstWhere(
      (supplier) => supplier.milkSupplierCode == code.trim(),
      orElse: () => MilkSupplierModel.empty(),
    );
    if (searchedSupplier.id.isEmpty) {
      isSupplierFoundByCode = false;
    } else {
      if (searchedSupplier.status) {
        isSupplierInActive.value = false;
      } else {
        isSupplierInActive.value = true;
      }
      isSupplierFoundByCode = true;
      if (isSupplierFoundByCode && !isSupplierInActive.value) {
        findRateChartOfFoundSupplier();
      }
    }
    update();
  }

  selectSupplierBySearching(MilkSupplierModel supplier) {
    searchSupplierToAddCollectionFor(supplier.milkSupplierCode);
    supplierCode.text = supplier.milkSupplierCode;
    milkSuppliersForBottomList.clear();
    milkSuppliersForBottomList.assignAll(
      milkSuppliers,
    ); // this is because when user tap on customer card after searching from list
    // the searched data retained in milkSuppliersForBottomList. so we have to reset
    //this list with all data again.
    AppNavigation.goBack();
  }

  searchSupplierInList(String searchTerm) {
    milkSuppliersForBottomList.assignAll(
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

  removeCanStep(int index) {
    literController.text =
        (int.parse(literController.text) - can.steps[index].canLiter)
            .toString();
    can.steps.removeAt(index);
    update();
  }

  addCanStep() {
    CanStepModel step = CanStepModel(
      canNumber: can.steps.length + 1,
      canLiter: int.parse(wScaleController.text),
    );

    if (int.parse(createTempTotalValueOfLiter.value) > 0) {
      literController.text = createTempTotalValueOfLiter.value;
    }

    previousValueController.text = literController.text;
    can.steps.add(step);
    wScaleController.clear();
    update();
    AppNavigation.goBack();
  }

  calculateTempTotalValue() {
    createTempTotalValueOfLiter.value =
        (int.parse(literController.text.isEmpty ? '0' : literController.text) +
                int.parse(
                  wScaleController.text.isEmpty ? '0' : wScaleController.text,
                ))
            .toString();
  }

  selectMilkType(String milkTypeId) {
    selectedMilkType.value = milkTypes.firstWhere(
      (mt) => mt['id'] == milkTypeId,
    );
  }

  findRateChartOfFoundSupplier() async {
    if (!isSupplierFoundByCode) return;
    final caForsupplier = chartAssiignments.firstWhereOrNull(
      (ca) => ca.supplierId == int.parse(searchedSupplier.id),
    );

    if (caForsupplier != null) {
      int chartIdOfFoundsupplier = caForsupplier.rateChartId;
      String? currentMilkTypeId = selectedMilkType['id'];

      if (currentMilkTypeId == null) {
        foundChartForDairyOrSuppliers = assignedCharts.firstWhereOrNull(
          (ac) => ac.id == chartIdOfFoundsupplier,
        );
        selectMilkType(foundChartForDairyOrSuppliers!.milkTypeId.toString());
      } else {
        List<AssignChartModel> foundedSuppliersCharts = [];
        List<AssignmentModel> rateChartIdsassignedToCurrentSupplier =
            chartAssiignments
                .where((ca) => ca.supplierId == int.parse(searchedSupplier.id))
                .toList();
        final List<AssignChartModel> result = [];

        for (var i = 0; i < rateChartIdsassignedToCurrentSupplier.length; i++) {
          result.addAll(
            assignedCharts.where(
              (ac) =>
                  ac.id ==
                      rateChartIdsassignedToCurrentSupplier[i].rateChartId &&
                  currentMilkTypeId == ac.milkTypeId.toString(),
            ),
          );
        }

        foundedSuppliersCharts.assignAll(result);

        if (foundedSuppliersCharts.isNotEmpty) {
          foundChartForDairyOrSuppliers = foundedSuppliersCharts[0];
        }
      }

      if (foundChartForDairyOrSuppliers == null) return;

      chartValuesOfFoundSupplierAndDairy.clear();
      chartValuesOfFoundSupplierAndDairy.assignAll(
        foundChartForDairyOrSuppliers!.rateChartValues,
      );
      checkPriceForFatAnsSnfValue();
    } else {
      // this is the case if rate chart is not found for supplier then we will look for a rate
      //chart which is assigned to dairy. and will apply rates of that chart
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      List<String> ratechartsIdsAssignedTodairy = [];
      List<AssignChartModel> dairyAssiendCharts =
          []; //The charts which are assigned to dairy
      String? currentMilkTypeId = selectedMilkType['id'];
      for (var i = 0; i < chartAssiignments.length; i++) {
        if (chartAssiignments[i].dairyId.toString() == dairyId) {
          ratechartsIdsAssignedTodairy.add(
            chartAssiignments[i].rateChartId.toString(),
          );
        }
      }

      final List<AssignChartModel> result = [];

      for (var i = 0; i < ratechartsIdsAssignedTodairy.length; i++) {
        result.addAll(
          assignedCharts.where(
            (ac) =>
                ac.id.toString() == ratechartsIdsAssignedTodairy[i] &&
                currentMilkTypeId == ac.milkTypeId.toString(),
          ),
        );
      }

      dairyAssiendCharts.assignAll(result);
      if (dairyAssiendCharts.isNotEmpty) {
        foundChartForDairyOrSuppliers = dairyAssiendCharts[0];
      }

      if (foundChartForDairyOrSuppliers == null) return;

      chartValuesOfFoundSupplierAndDairy.clear();
      chartValuesOfFoundSupplierAndDairy.assignAll(
        foundChartForDairyOrSuppliers!.rateChartValues,
      );
      checkPriceForFatAnsSnfValue();
    }
  }

  void checkPriceForFatAnsSnfValue() {
    if (chartValuesOfFoundSupplierAndDairy.isEmpty) return;
    if (foundChartForDairyOrSuppliers != null) {
      if (selectedMilkType['id'] !=
          foundChartForDairyOrSuppliers!.milkTypeId.toString()) {
        rateController.clear();
        return;
      }
    }
    //  Basic validation
    if (fatController.text.isEmpty) {
      rateController.clear();
      return;
    }

    if (snfController.text.isEmpty && clrController.text.isEmpty) {
      rateController.clear();
      return;
    }

    //  Parse values safely
    final double? fat = double.tryParse(fatController.text);
    final double? snf = double.tryParse(snfController.text);
    final double? clr = double.tryParse(clrController.text);

    if (fat == null) {
      rateController.clear();
      return;
    }

    //  Find matching rate chart value
    final matchedChart = chartValuesOfFoundSupplierAndDairy.firstWhereOrNull((
      cv,
    ) {
      final bool fatMatch = cv.fat == fat;

      final bool snfMatch = snf != null && cv.snf != null && cv.snf == snf;

      final bool clrMatch = clr != null && cv.clr != null && cv.clr == clr;

      return fatMatch && (snfMatch || clrMatch);
    });

    // 4️⃣ Handle result
    if (matchedChart != null) {
      rateChartValueId = matchedChart.id.toString();
      rateController.text = matchedChart.price.toString();
    } else {
      rateController.clear();
    }
  }

  String getTotalAmount() {
    return (rateController.text.isEmpty
            ? 0
            : ((double.tryParse(rateController.text) ?? 0.0) *
                      int.parse(
                        literController.text.isEmpty
                            ? '0'
                            : literController.text,
                      ))
                  .toStringAsFixed(2))
        .toString();
  }

  showDeletePostOption(
    BuildContext context,
    String message,
    bool isfromCollectionList,
  ) {
    showMyBottomSheet(
      context,
      SelectBoolOptionWidget(
        message: message,
        title: 'warning',
        callback: () async {
          AppNavigation.goBack();
          await removeColection(isfromCollectionList);
        },
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/select_bool_option_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/features/collection/data/model/assigned_chart_model.dart';
import 'package:DairyVikas/features/collection/data/model/assignment_model.dart';
import 'package:DairyVikas/features/collection/domain/usecases/update_milk_sale_usecase.dart';
import 'package:DairyVikas/features/milk_sale/data/models/milk_sale_model.dart';
import 'package:DairyVikas/features/milk_sale/domain/usecases/add_milk_sale_usecase.dart';
import 'package:DairyVikas/features/milk_sale/domain/usecases/get_all_milk_buyers_usecase.dart';
import 'package:DairyVikas/features/milk_sale/presentation/controllers/all_milk_sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/local_datasources/local_storage_service.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../core/utils/app_navigation.dart';
import '../../../collection/data/model/collection_can_model.dart';
import '../../../collection/domain/usecases/get_assigned_charts_usecase.dart';
import '../../../rate_cart/data/model/rate_chart_values_model.dart';
import '../../data/models/milk_buyer_model.dart';
import '../../data/models/milk_buyers_response_model.dart';

class AddMilksaleController extends GetxController with CommonMixin {
  final GetAllssignedChartsUsecase getAllssignedChartsUsecase;
  final GetAllMilkBuyersUsecase getAllMilkBuyersUsecase;
  final GlobalKey addSaleKey = GlobalKey();
  final GlobalKey buyersKey = GlobalKey();
  final GlobalKey dateFilterKey = GlobalKey();
  final GlobalKey milkTypeFilterKey = GlobalKey();
  final GlobalKey summaryKey = GlobalKey();
  final AddMilkSaleUsecase addMilkSaleUsecase;
  final UpdateMilkSaleUsecase updateMilkSaleUsecase;
  double literPerviousValue = 0.0;

  RxBool proccessing = false.obs;
  RxBool isLoading = true.obs;
  RxBool showRateChartForm = false.obs;
  RxBool showOnlyFixedRateField = false.obs;
  bool setReadyOnlyToFixedRateFiled = false;
  RxBool isBuyerFoundByCode = false.obs;
  RxBool isBuyerInActive = false.obs;
  final buyerCode = TextEditingController();
  final fatController = TextEditingController();
  final snfController = TextEditingController();
  final clrController = TextEditingController();
  final literController = TextEditingController();
  final previousValueController = TextEditingController(text: '0');
  final rateController = TextEditingController();
  final fixedBuffaloRateController = TextEditingController();
  final fixedCowRateController = TextEditingController();
  final fixedBuffaloRateLiterController = TextEditingController();
  final fixedCowRateLiterController = TextEditingController();
  final wScaleController = TextEditingController();
  final amountController = TextEditingController();
  final paidController = TextEditingController();
  final balanceController = TextEditingController();
  final canController = TextEditingController(text: '1');
  RxString createTempTotalValueOfLiter = '0'.obs;

  RxString selectedDateString = ''.obs;
  String rateChartValueId = '';
  AssignChartModel? foundChartForDairyOrBuyer;

  RxMap<String, dynamic> selectedShift = <String, dynamic>{}.obs;
  RxMap<String, dynamic> selectedMilkType = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> milkTypes = <Map<String, dynamic>>[
    {"id": '1', "value": 'cow', 'icon': AppIcons.cow(size: 16)},
    {"id": '2', "value": 'buffalo', 'icon': AppIcons.buffalo(size: 16)},
  ].obs;
  // MilkSuppliersResponseModel milkSuppliersResponseModel =
  //     MilkSuppliersResponseModel.empty();
  // List<MilkSupplierModel> milkSuppliers = <MilkSupplierModel>[];
  List<MilkBuyerModel> milkBuyersForBottomList = <MilkBuyerModel>[];
  MilkBuyerModel searchedBuyer = MilkBuyerModel.empty();
  MilkBuyerResponseModel milkBuyersResponseModel =
      MilkBuyerResponseModel.empty();
  RxList<MilkBuyerModel> allmilkBuyers = <MilkBuyerModel>[].obs;

  MilkCollectionCanModel can = MilkCollectionCanModel.empty();

  List<AssignChartModel> assignedCharts = <AssignChartModel>[];
  List<AssignmentModel> chartAssignments = <AssignmentModel>[];

  List<RateChartValuesModel> chartValuesOfFoundBuyerAndDairy =
      <RateChartValuesModel>[];

  AddMilksaleController(
    this.getAllssignedChartsUsecase,
    this.getAllMilkBuyersUsecase,
    this.addMilkSaleUsecase,
    this.updateMilkSaleUsecase,
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
    if (AppState.isMilkSaleEdit) {
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
    if (!AppState.isMilkSaleEdit) {
      selectedDateString.value = formatDateforApi(
        DateTime.now(),
      ); // add this only if user add the sale. not in edit case.
    }
    await getAllAssignedRatecharts();
    await getAllMilkBuyers();
    if (AppState.isMilkSaleEdit) {
      setDataForUpdateSale();
    }
    isLoading.value = false;
  }

  setDataForUpdateSale() {
    MilkSaleModel saleForUpdate = AppState.currentMilkSaleforUpdate;

    selectedMilkType.value = milkTypes.firstWhere(
      (mt) => mt['id'] == saleForUpdate.milkTypeId.toString(),
    );

    selectedShift.value = AppState.shifts.firstWhere(
      (cs) => cs['id'] == saleForUpdate.shiftId,
    );

    buyerCode.text = saleForUpdate.saleBuyer.milkBuyerCode;
    searchBuyerToAddMilkSaleFor(buyerCode.text);
    bool isRateTypeTwo =
        searchedBuyer.buffaloMilkRateType == 2 ||
        searchedBuyer.cowMilkRateType == 2;
    bool isRateTypeThree =
        searchedBuyer.buffaloMilkRateType == 3 ||
        searchedBuyer.cowMilkRateType == 3;

    bool isRateTypeOne =
        searchedBuyer.buffaloMilkRateType == 1 ||
        searchedBuyer.cowMilkRateType == 1;
    if (isRateTypeOne) {
      literController.text = saleForUpdate.litre.toString();
      fatController.text = saleForUpdate.fat.toString();
      snfController.text = saleForUpdate.snf.toString();
      clrController.text = saleForUpdate.clr.toString();
      rateController.text = saleForUpdate.ratePerLitre.toString();
      selectedDateString.value = saleForUpdate.saleDate;
    } else if (isRateTypeTwo || isRateTypeThree) {
      showRateChartForm.value = false;
      showOnlyFixedRateField.value = true;
      if (selectedMilkType.value['id'] == '1') {
        // handle this case if milk type is cow
        fixedCowRateController.text = saleForUpdate.ratePerLitre.toString();
        fixedCowRateLiterController.text = saleForUpdate.litre.toString();
      } else if (selectedMilkType.value['id'] == '2') {
        fixedBuffaloRateController.text = saleForUpdate.ratePerLitre.toString();
        fixedBuffaloRateLiterController.text = saleForUpdate.litre.toString();
        // handle this case if milk type is buffalo
      }
    }
  }

  Future getAllMilkBuyers() async {
    try {
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      Map response = await getAllMilkBuyersUsecase(dairyId);

      if (response['success']) {
        allmilkBuyers.clear();
        milkBuyersResponseModel = MilkBuyerResponseModel.fromJson(
          response['data'],
        );

        allmilkBuyers.addAll(milkBuyersResponseModel.buyers);
        milkBuyersForBottomList.clear();
        milkBuyersForBottomList.assignAll(allmilkBuyers);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    }
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

        chartAssignments.assignAll(
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
      showAppToastMessage('select_a_date_to_add_sale', true);
      return false;
    }

    if (!isBuyerFoundByCode.value) {
      showAppToastMessage('select_a_buyer_first', true);
      return false;
    }

    if (isBuyerInActive.value) {
      showAppToastMessage('select_a_active_buyer', true);
      return false;
    }

    if (selectedMilkType.isEmpty) {
      showAppToastMessage('select_milk_type', true);
      return false;
    }

    if (showRateChartForm.value) {
      if (literController.text.isEmpty) {
        showAppToastMessage('please_add_sale_liter', true);
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
    } else {
      if (selectedMilkType['id'] == '1') {
        if (fixedCowRateLiterController.text.isEmpty) {
          showAppToastMessage('please_add_sale_liter', true);
          return false;
        }
        if (fixedCowRateController.text.isEmpty) {
          // this can change form dairy center setting it can be for snf or for clr. it will be dynamic.
          showAppToastMessage('rate_is_empty', true);
          return false;
        }
      } else {
        if (fixedBuffaloRateLiterController.text.isEmpty) {
          showAppToastMessage('please_add_sale_liter', true);
          return false;
        }
        if (fixedBuffaloRateController.text.isEmpty) {
          // this can change form dairy center setting it can be for snf or for clr. it will be dynamic.
          showAppToastMessage('rate_is_empty', true);
          return false;
        }
      }
    }

    return true;
  }

  List getLiterAndRate() {
    List data = [];
    if (selectedMilkType.isEmpty) return [];
    if (selectedMilkType['id'] == '1') {
      if (showRateChartForm.value) {
        // cow + rate-chart case...
        data.add(double.tryParse(literController.text.trim()) ?? 0.0);
        data.add(rateController.text);
      } else {
        // cow + fixedrate case...
        data.add(
          double.tryParse(fixedCowRateLiterController.text.trim()) ?? 0.0,
        );
        data.add(fixedCowRateController.text);
      }
    } else if (selectedMilkType['id'] == '2') {
      if (showRateChartForm.value) {
        // buffalo + rate-chart case...
        data.add(double.tryParse(literController.text.trim()) ?? 0.0);
        data.add(rateController.text);
      } else {
        // buffalo + fixed-rate case...
        data.add(
          double.tryParse(fixedBuffaloRateLiterController.text.trim()) ?? 0.0,
        );
        data.add(fixedBuffaloRateController.text);
      }
    }
    return data;
  }

  Future<Map> bodyDataTosend(bool addMoreSale) async {
    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';
    List rateLiter = getLiterAndRate();
    Map json = {
      "dairy_id": dairyId,
      "buyer_id": searchedBuyer.id,
      "milk_type_id": int.parse(selectedMilkType['id']),
      "shift_id": selectedShift['id'],
      "litre": rateLiter[0],
      "fat": double.tryParse(fatController.text.trim()),
      "snf": double.tryParse(snfController.text.trim()),
      "clr": double.tryParse(clrController.text.trim()),
      "rate_per_litre": rateLiter.isEmpty ? 0 : rateLiter[1],
      "sale_date": selectedDateString.value,
      "addMoreSale": addMoreSale,
      "milk_sale_type": showRateChartForm.value ? 'RATE_CHART' : "FIXED",
      "rate_chart_id": foundChartForDairyOrBuyer?.id,
      "rate_chart_detail_id": showRateChartForm.value
          ? int.parse(rateChartValueId)
          : null,
    };

    if (AppState.isMilkSaleEdit) {
      json.addAll({"sale_id": AppState.currentMilkSaleforUpdate.saleId});
    }

    return json;
  }

  Future<void> addOrUpdateMilkSale(
    BuildContext context,
    bool addMoreSale,
  ) async {
    try {
      if (!isValidate() || proccessing.value) return;
      proccessing.value = true;
      Map bodyData = await bodyDataTosend(addMoreSale);

      if (AppState.isMilkSaleEdit) {
        var response = await updateMilkSaleUsecase(bodyData);
        _processResponse(response, context);
      } else {
        var response = await addMilkSaleUsecase(bodyData);
        _processResponse(response, context);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      proccessing.value = false;
    }
  }

  _processResponse(var response, BuildContext context) async {
    if (response['success']) {
      showAppToastMessage(response['message'], false);
      final allMilkSalesController = Get.find<AllMilkSalesControllers>();
      await allMilkSalesController.getAllMilkSale();

      AppNavigation.goBack();
    } else {
      if (response['type'] == 'CONFIRMATION_REQUIRED') {
        showAddMoreSaleOption(context, response['mesaage']);
      } else {
        showAppToastMessage(response['message'], true);
      }
    }
  }

  showAddMoreSaleOption(BuildContext context, String message) {
    showMyBottomSheet(
      context,
      SelectBoolOptionWidget(
        message: message,
        title: 'warning',
        callback: () async {
          AppNavigation.goBack();
          await addOrUpdateMilkSale(context, true);
        },
      ),
    );
  }

  _clearControllers() {
    fatController.clear();
    literController.clear();
    clrController.clear();
    snfController.clear();
    rateController.clear();
  }

  searchBuyerToAddMilkSaleFor(String code) {
    if (code.isEmpty) {
      isBuyerFoundByCode.value = false;
      isBuyerInActive.value = false;
      _clearControllers();
      update();
      return;
    }
    searchedBuyer = allmilkBuyers.firstWhere(
      (buyer) => buyer.milkBuyerCode == code.trim(),
      orElse: () => MilkBuyerModel.empty(),
    );
    if (searchedBuyer.id == 0) {
      isBuyerFoundByCode.value = false;
    } else {
      if (searchedBuyer.status) {
        isBuyerInActive.value = false;
      } else {
        isBuyerInActive.value = true;
      }
      isBuyerFoundByCode.value = true;
    }
    checkMilkRateType();
    update();
  }

  // checkMilkRateType() {
  //   if (isBuyerFoundByCode.value && !isBuyerInActive.value) {
  //     if ((searchedBuyer.buffaloMilkRateType == 0 &&
  //             selectedMilkType['id'] == '2') ||
  //         (searchedBuyer.cowMilkRateType == 0 &&
  //             selectedMilkType['id'] == '1')) {
  //       showOnlyFixedRateField.value = false;
  //       // this is the edge case if buyer has not any rate type selected for particualt milk type
  //       return;
  //     }

  //     if (searchedBuyer.buffaloMilkRateType == 2 ||
  //         searchedBuyer.cowMilkRateType == 2) {
  //       showOnlyFixedRateField.value = true;
  //       setReadyOnlyToFixedRateFiled = true;

  //       // case if one of these has rate type 2 means fixed rate
  //       if (searchedBuyer.buffaloMilkRateType == 2 &&
  //           searchedBuyer.cowMilkRateType == 2) {
  //         // case if  all of these has rate type 2 means fixed rate
  //         fixedBuffaloRateController.text = searchedBuyer.buffaloMilkRate
  //             .toString();
  //         fixedBuffaloRateLiterController.text = '1';
  //         fixedCowRateController.text = searchedBuyer.cowMilkRate.toString();
  //         fixedCowRateLiterController.text = '1';
  //       } else {
  //         // here the case that we dont know for which case the rate type is 2
  //         if (searchedBuyer.buffaloMilkRateType == 2 &&
  //             selectedMilkType['id'] == '2') {
  //           fixedBuffaloRateController.text = searchedBuyer.buffaloMilkRate
  //               .toString();
  //           fixedBuffaloRateLiterController.text = '1';
  //           showForm.value = false;
  //         } else if (searchedBuyer.cowMilkRateType == 2 &&
  //             selectedMilkType['id'] == '1') {
  //           fixedCowRateController.text = searchedBuyer.cowMilkRate.toString();
  //           fixedCowRateLiterController.text = '1';
  //           showForm.value = false;
  //         } else {
  //           showOnlyFixedRateField.value = false;
  //           showForm.value = true;
  //           findRateChartOfFoundBuyer();
  //           // again milk rate type is rate-chart
  //         }
  //       }
  //     } else if (searchedBuyer.buffaloMilkRateType == 3 ||
  //         searchedBuyer.cowMilkRateType == 3) {
  //       showOnlyFixedRateField.value = true;
  //       setReadyOnlyToFixedRateFiled = false;
  //     } else if (searchedBuyer.buffaloMilkRateType == 1 ||
  //         searchedBuyer.cowMilkRateType == 1) {
  //       showOnlyFixedRateField.value = false;
  //       showForm.value = true;
  //       findRateChartOfFoundBuyer();
  //     }
  //   }
  // }

  void checkMilkRateType() {
    if (!isBuyerFoundByCode.value || isBuyerInActive.value) return;

    final isBuffalo = selectedMilkType['id'] == '2';
    final buffaloType = searchedBuyer.buffaloMilkRateType;
    final cowType = searchedBuyer.cowMilkRateType;

    final selectedRateType = isBuffalo ? buffaloType : cowType;

    // 🔹 Edge case: no rate type selected for this milk
    if (selectedRateType == 0) {
      showOnlyFixedRateField.value = false;
      return;
    }

    // 🔹 Fixed rate
    if (selectedRateType == 2) {
      showOnlyFixedRateField.value = true;
      setReadyOnlyToFixedRateFiled = true;
      showRateChartForm.value = false;

      if (isBuffalo) {
        fixedBuffaloRateController.text = searchedBuyer.buffaloMilkRate
            .toString();
        fixedBuffaloRateLiterController.text = '1';
      } else {
        fixedCowRateController.text = searchedBuyer.cowMilkRate.toString();
        fixedCowRateLiterController.text = '1';
      }
      return;
    }

    // 🔹 Fixed + Editable
    if (selectedRateType == 3) {
      showOnlyFixedRateField.value = true;
      setReadyOnlyToFixedRateFiled = false;
      showRateChartForm.value = false;
      return;
    }

    // 🔹 Rate chart
    if (selectedRateType == 1) {
      showOnlyFixedRateField.value = false;
      showRateChartForm.value = true;
      findRateChartOfFoundBuyer();
    }
  }

  selectSupplierBySearching(MilkBuyerModel buyer) {
    searchBuyerToAddMilkSaleFor(buyer.milkBuyerCode);
    buyerCode.text = buyer.milkBuyerCode;
    milkBuyersForBottomList.clear();
    milkBuyersForBottomList.assignAll(
      allmilkBuyers,
    ); // this is because when user tap on supplier card after searching from list
    // the searched data retained in milkSuppliersForBottomList. so we have to reset
    //this list with all data again.
    AppNavigation.goBack();
  }

  searchBuyerInList(String searchTerm) {
    milkBuyersForBottomList.assignAll(
      allmilkBuyers.where(
        (buyer) =>
            buyer.buyerName.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ) ||
            buyer.milkBuyerCode.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ) ||
            buyer.buyerMobile.toLowerCase().startsWith(
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
    checkMilkRateType();
  }

  findRateChartOfFoundBuyer() async {
    if (!isBuyerFoundByCode.value) return;
    final caForBuyer = chartAssignments.firstWhereOrNull(
      (ca) => ca.buyerId == searchedBuyer.id,
    );

    if (caForBuyer != null) {
      int chartIdOfFoundBuyer = caForBuyer.rateChartId;
      String? currentMilkTypeId = selectedMilkType['id'];

      if (currentMilkTypeId == null) {
        foundChartForDairyOrBuyer = assignedCharts.firstWhereOrNull(
          (ac) => ac.id == chartIdOfFoundBuyer,
        );
        selectMilkType(foundChartForDairyOrBuyer!.milkTypeId.toString());
      } else {
        List<AssignChartModel> foundedBuyersCharts = [];
        List<AssignmentModel> rateChartIdsassignedToCurrentBuyer =
            chartAssignments
                .where((ca) => ca.buyerId == searchedBuyer.id)
                .toList();
        final List<AssignChartModel> result = [];

        for (var i = 0; i < rateChartIdsassignedToCurrentBuyer.length; i++) {
          result.addAll(
            assignedCharts.where(
              (ac) =>
                  ac.id == rateChartIdsassignedToCurrentBuyer[i].rateChartId &&
                  currentMilkTypeId == ac.milkTypeId.toString(),
            ),
          );
        }

        foundedBuyersCharts.assignAll(result);

        if (foundedBuyersCharts.isNotEmpty) {
          foundChartForDairyOrBuyer = foundedBuyersCharts[0];
        }
      }

      if (foundChartForDairyOrBuyer == null) return;

      chartValuesOfFoundBuyerAndDairy.clear();
      chartValuesOfFoundBuyerAndDairy.assignAll(
        foundChartForDairyOrBuyer!.rateChartValues,
      );
      checkPriceForFatAnsSnfValue();
    } else {
      // this is the case if rate chart is not found for supplier then we will look for a rate
      //chart which is assigned to dairy. and will apply rates of that chart
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      List<String> ratechartsIdsAssignedTodairy = [];
      List<AssignChartModel> dairyAssignedCharts =
          []; //The charts which are assigned to dairy
      String? currentMilkTypeId = selectedMilkType['id'];
      for (var i = 0; i < chartAssignments.length; i++) {
        if (chartAssignments[i].dairyId.toString() == dairyId) {
          ratechartsIdsAssignedTodairy.add(
            chartAssignments[i].rateChartId.toString(),
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

      dairyAssignedCharts.assignAll(result);
      if (dairyAssignedCharts.isNotEmpty) {
        foundChartForDairyOrBuyer = dairyAssignedCharts[0];
      }

      if (foundChartForDairyOrBuyer == null) return;

      chartValuesOfFoundBuyerAndDairy.clear();
      chartValuesOfFoundBuyerAndDairy.assignAll(
        foundChartForDairyOrBuyer!.rateChartValues,
      );
      checkPriceForFatAnsSnfValue();
    }
  }

  void checkPriceForFatAnsSnfValue() {
    if (chartValuesOfFoundBuyerAndDairy.isEmpty) return;
    if (foundChartForDairyOrBuyer != null) {
      if (selectedMilkType['id'] !=
          foundChartForDairyOrBuyer!.milkTypeId.toString()) {
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
    final matchedChart = chartValuesOfFoundBuyerAndDairy.firstWhereOrNull((cv) {
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
}

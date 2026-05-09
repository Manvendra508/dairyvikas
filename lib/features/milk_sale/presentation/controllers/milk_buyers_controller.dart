import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/features/milk_sale/data/models/milk_buyer_model.dart';
import 'package:DairyVikas/features/milk_sale/data/models/milk_buyers_response_model.dart';
import 'package:DairyVikas/features/milk_sale/domain/usecases/delete_milk_buyer_usecase.dart';
import 'package:DairyVikas/features/milk_sale/domain/usecases/get_all_milk_buyers_usecase.dart';
import 'package:DairyVikas/features/milk_sale/domain/usecases/update_buyer_status_usecase.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/select_bool_option_widget.dart';
import '../../../../core/utils/app_navigation.dart';

class MilkBuyersController extends GetxController with CommonMixin {
  final GetAllMilkBuyersUsecase getAllMilkBuyersUsecase;
  final UpdateMilkBuyerStatusUsecase updateBuyerStatusUsecase;
  final DeleteMilkBuyerUsecase deleteMilkBuyerUsecase;
  RxBool hasError = false.obs;
  RxInt currentStatusFilterIndex = 0.obs;
  RxList<MilkBuyerModel> allmilkBuyers = <MilkBuyerModel>[].obs;
  RxBool isLoading = false.obs;
  List<MilkBuyerModel> filteredBuyersList = <MilkBuyerModel>[];
  MilkBuyerResponseModel milkBuyersResponseModel =
      MilkBuyerResponseModel.empty();
  RxString selectedMilkType = ''.obs;
  RxString selectedStatus = '0'.obs;
  TextEditingController searchController = TextEditingController();
  RxList<Map<String, dynamic>> statusFilters = <Map<String, dynamic>>[
    {"id": '0', "title": 'all'},
    {"id": '1', "title": 'active'},
    {"id": '2', "title": 'inactive'},
  ].obs;

  MilkBuyersController(
    this.getAllMilkBuyersUsecase,
    this.updateBuyerStatusUsecase,
    this.deleteMilkBuyerUsecase,
  );
  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    await getAllMilkBuyers();
  }

  Future getAllMilkBuyers() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      Map response = await getAllMilkBuyersUsecase(dairyId);

      if (response['success']) {
        hasError.value = false;
        allmilkBuyers.clear();
        milkBuyersResponseModel = MilkBuyerResponseModel.fromJson(
          response['data'],
        );

        allmilkBuyers.addAll(milkBuyersResponseModel.buyers);
        filteredBuyersList.assignAll(allmilkBuyers);
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

  Future<void> changeBuyerStatus(MilkBuyerModel milkBuyer) async {
    if (isLoading.value) return;

    isLoading.value = true;
    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';
    final buyerData = {
      "dairy_id": dairyId,
      "buyer_id": milkBuyer.id,

      'status': milkBuyer.status
          ? '0'
          : '1', // its  a reverse case if active then we have to send 0 to inactive supplier and if inactive we have to send 1 to active.
    };
    try {
      var response = await updateBuyerStatusUsecase(buyerData);
      if (response['success']) {
        isLoading.value =
            false; // because if we dont set false to it , then below function will  not call
        await getAllMilkBuyers();

        showAppToastMessage(response['message'], false);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isLoading.value = false;
    }
  }

  selectStatus(int index) {
    currentStatusFilterIndex.value = index;
    selectedStatus.value = statusFilters[index]['id'];
    filterMilkBuyers();
  }

  filterMilkBuyers() {
    if (selectedStatus.value == '0') {
      filteredBuyersList.assignAll(allmilkBuyers);
    } else if (selectedStatus.value == '1') {
      filteredBuyersList.assignAll(
        allmilkBuyers.where((chart) => chart.status).toList(),
      );
    } else if (selectedStatus.value == '2') {
      filteredBuyersList.assignAll(
        allmilkBuyers.where((chart) => !chart.status).toList(),
      );
    }

    update();
  }

  searchBuyers(String searchTerm) {
    filteredBuyersList.assignAll(
      allmilkBuyers.where(
        (supplier) =>
            supplier.buyerName.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ) ||
            supplier.milkBuyerCode.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ),
      ),
    );
    update();
  }

  Future<void> deleteMilkBuyer(String buyerId) async {
    try {
      var response = await deleteMilkBuyerUsecase(buyerId);
      if (response['success']) {
        showAppToastMessage(response['message'], false);

        await getAllMilkBuyers();
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    }
  }

  showDeleteBuyerOption(
    BuildContext context,
    String buyerId,
    String buyerName,
  ) {
    showMyBottomSheet(
      context,
      SelectBoolOptionWidget(
        message: 'remove_supplier_warning_message'.trParams({
          'name': buyerName,
        }),
        title: 'warning',
        callback: () async {
          AppNavigation.goBack();
          await deleteMilkBuyer(buyerId);
        },
      ),
    );
  }
}

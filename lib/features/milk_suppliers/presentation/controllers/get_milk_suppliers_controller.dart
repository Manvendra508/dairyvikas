import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/features/milk_suppliers/data/model/milk_supplier_model.dart';
import 'package:DairyVikas/features/milk_suppliers/data/model/milk_suppliers_response_model.dart';
import 'package:DairyVikas/features/milk_suppliers/domain/usecases/get_all_milk_suppliers_usecase.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../domain/usecases/update_supplier_status_usecase.dart';

class AllMilkSuppliersController extends GetxController with CommonMixin {
  final GetAllMilkSuppliersUsecase getAllMilkSuppliersUsecase;
  final UpdateSupplierStatusUsecase updateSupplierStatusUsecase;
  RxBool hasError = false.obs;
  RxBool isLoading = false.obs;
  RxInt currentStatusFilterIndex = 0.obs;
  RxList<MilkSupplierModel> allmilkSuppliers = <MilkSupplierModel>[].obs;

  List<MilkSupplierModel> filteredSuppliersList = <MilkSupplierModel>[];
  MilkSuppliersResponseModel milkSuppliersResponseModel =
      MilkSuppliersResponseModel.empty();
  RxString selectedMilkType = ''.obs;
  RxString selectedStatus = '0'.obs;
  TextEditingController searchController = TextEditingController();
  RxList<Map<String, dynamic>> statusFilters = <Map<String, dynamic>>[
    {"id": '0', "title": 'all'},
    {"id": '1', "title": 'active'},
    {"id": '2', "title": 'inactive'},
  ].obs;

  AllMilkSuppliersController(
    this.getAllMilkSuppliersUsecase,
    this.updateSupplierStatusUsecase,
  );
  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    await getAllMilkSuppliers();
  }

  Future getAllMilkSuppliers() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      Map response = await getAllMilkSuppliersUsecase(dairyId);

      if (response['success']) {
        hasError.value = false;
        allmilkSuppliers.clear();
        milkSuppliersResponseModel = MilkSuppliersResponseModel.fromJson(
          response['data'],
        );

        allmilkSuppliers.addAll(milkSuppliersResponseModel.suppliers);
        AppState.milkSuppliers.assignAll(
          allmilkSuppliers,
        ); // this will reset the global list if user add, update or delete supplier.
        filteredSuppliersList.assignAll(allmilkSuppliers);
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

  Future<void> changeCutomerStatus(MilkSupplierModel milkSupplier) async {
    if (isLoading.value) return;

    isLoading.value = true;
    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';
    final supplierData = {
      "dairy_id": dairyId,
      "supplier_id": milkSupplier.id,

      'status': milkSupplier.status
          ? '0'
          : '1', // its  a reverse case if active then we have to send 0 to inactive supplier and if inactive we have to send 1 to active.
    };
    try {
      var response = await updateSupplierStatusUsecase(supplierData);
      if (response['success']) {
        isLoading.value =
            false; // because if we dont set false to it , then below function will  not call
        await getAllMilkSuppliers();

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
    filterMilkSuppliers();
  }

  filterMilkSuppliers() {
    if (selectedStatus.value == '0') {
      filteredSuppliersList.assignAll(allmilkSuppliers);
    } else if (selectedStatus.value == '1') {
      filteredSuppliersList.assignAll(
        allmilkSuppliers.where((chart) => chart.status).toList(),
      );
    } else if (selectedStatus.value == '2') {
      filteredSuppliersList.assignAll(
        allmilkSuppliers.where((chart) => !chart.status).toList(),
      );
    }

    update();
  }

  searchSupplier(String searchTerm) {
    filteredSuppliersList.assignAll(
      allmilkSuppliers.where(
        (supplier) =>
            supplier.supplierName.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ) ||
            supplier.milkSupplierCode.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ),
      ),
    );
    update();
  }
}

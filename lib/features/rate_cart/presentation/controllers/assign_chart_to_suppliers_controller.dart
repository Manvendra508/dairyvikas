import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/features/rate_cart/data/model/assignable_supplier_model.dart';
import 'package:DairyVikas/features/rate_cart/domain/usecases/get_all_assignable_suppliers_usecase.dart';
import 'package:DairyVikas/features/rate_cart/presentation/controllers/all_rate_charts_controllers.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_navigation.dart';
import '../../domain/usecases/aasign_chart_to_suppliers_usecase.dart';
import '../../domain/usecases/unassign_chart_to_suppliers_usecase.dart';

class AssignChartToSuppliersController extends GetxController with CommonMixin {
  final GetAllAssignableSuppliersUsecase getAllAssignableSuppliersUsecase;
  final AssignChartToSuppliersUsecase assignChartToSuppliersUsecase;
  final UnassignChartToSuppliersUsecase unassignChartToSuppliersUsecase;

  RxBool isSelectAllToAssign = false.obs;
  RxBool isSelectAllToUnAssign = false.obs;
  RxBool showSelected = false.obs;
  RxMap<String, dynamic> selectedShift = <String, dynamic>{}.obs;
  RxBool isLoading = false.obs;
  RxBool isAssigning = false.obs;
  RxBool hasError = false.obs;
  RxList<AssignableSupplierModel> assignedToChartSuppliers =
      <AssignableSupplierModel>[].obs;
  RxList<AssignableSupplierModel> unAssignedToChartSuppliers =
      <AssignableSupplierModel>[].obs;
  RxList<AssignableSupplierModel> filteredAssignedToChartSuppliers =
      <AssignableSupplierModel>[].obs;
  RxList<AssignableSupplierModel> filteredUnAssignedToChartSuppliers =
      <AssignableSupplierModel>[].obs;

  RxList<String> toBeAssignsuppliersIds =
      <String>[].obs; // these are the ids that are to be assigned

  RxList<String> toBeUnAssignsuppliersIds =
      <String>[].obs; // these are the ids that are to be unassigned
  AssignChartToSuppliersController(
    this.getAllAssignableSuppliersUsecase,
    this.assignChartToSuppliersUsecase,
    this.unassignChartToSuppliersUsecase,
  );

  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    await getAllRateAssignableSuppliers();
  }

  _clearSuppliersData() {
    toBeAssignsuppliersIds.clear();
    toBeUnAssignsuppliersIds.clear();
    filteredAssignedToChartSuppliers.clear();
    filteredUnAssignedToChartSuppliers.clear();
    assignedToChartSuppliers.clear();
    unAssignedToChartSuppliers.clear();
  }

  Future<void> getAllRateAssignableSuppliers() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;

      Map response = await getAllAssignableSuppliersUsecase(
        AppState.chartIdForassignablesupplierScreen,
        AppState.customerTypeForassignablSupplierScreen,
      );

      if (response['success']) {
        hasError.value = false;
        _clearSuppliersData();
        List<dynamic> assignedSupliers =
            response['data']['assigned'] as List<dynamic>;
        bool isSupplier =
            AppState.customerTypeForassignablSupplierScreen ==
            AppState.supplierCustomerType;
        if (isSupplier) {
          assignedToChartSuppliers.addAll(
            assignedSupliers
                .map(
                  (e) => AssignableSupplierModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList(),
          );
        } else {
          assignedToChartSuppliers.addAll(
            assignedSupliers
                .map(
                  (e) => AssignableSupplierModel.fromJsonForBuyer(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList(),
          );
        }
        filteredAssignedToChartSuppliers.assignAll(assignedToChartSuppliers);

        // unassigned
        List<dynamic> unassignedSupliers =
            response['data']['unassigned'] as List<dynamic>;
        if (isSupplier) {
          unAssignedToChartSuppliers.addAll(
            unassignedSupliers
                .map(
                  (e) => AssignableSupplierModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList(),
          );
        } else {
          unAssignedToChartSuppliers.addAll(
            unassignedSupliers
                .map(
                  (e) => AssignableSupplierModel.fromJsonForBuyer(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList(),
          );
        }
        filteredUnAssignedToChartSuppliers.assignAll(
          unAssignedToChartSuppliers,
        );
        if (filteredAssignedToChartSuppliers.isEmpty) {
          isSelectAllToUnAssign.value = false;
        }
        if (filteredUnAssignedToChartSuppliers.isEmpty) {
          isSelectAllToAssign.value = false;
        }
        update();
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

  selectSingleSuppliersToAssignRatechart(AssignableSupplierModel supplier) {
    // 1️⃣ Toggle current supplier
    supplier.isSelected.value = !supplier.isSelected.value;

    final hasAnySelected = unAssignedToChartSuppliers.any(
      (supplier) => supplier.isSelected.value,
    );

    if (!hasAnySelected) {
      showSelected.value = false;

      update();
      return;
    }

    // 2️⃣ Add / remove from ID list
    if (supplier.isSelected.value) {
      toBeAssignsuppliersIds.add(supplier.id.toString());
    } else {
      toBeAssignsuppliersIds.remove(supplier.id.toString());
    }

    // 3️⃣ Update Select All based on ALL items
    isSelectAllToAssign.value = filteredUnAssignedToChartSuppliers.every(
      (item) => item.isSelected.value,
    );

    update();
  }

  selectSingleSuppliersToUnAssignRatechart(AssignableSupplierModel supplier) {
    // 1️⃣ Toggle supplier selection first
    supplier.isSelected.value = !supplier.isSelected.value;

    // 2️⃣ Update ID list
    if (supplier.isSelected.value) {
      toBeUnAssignsuppliersIds.add(supplier.id.toString());
    } else {
      toBeUnAssignsuppliersIds.remove(supplier.id.toString());
    }

    // 3️⃣ Update Select All ONLY if all are selected
    isSelectAllToUnAssign.value = filteredAssignedToChartSuppliers.every(
      (item) => item.isSelected.value,
    );

    update();
  }

  selectAllToAssign() {
    isSelectAllToAssign.value = !isSelectAllToAssign.value;

    if (!isSelectAllToAssign.value) {
      toBeAssignsuppliersIds.clear();
    } else {
      toBeAssignsuppliersIds
        ..clear()
        ..assignAll(
          filteredUnAssignedToChartSuppliers
              .map((item) => item.id.toString())
              .toList(),
        );
    }
    if (isSelectAllToAssign.value) {
      for (var item in filteredUnAssignedToChartSuppliers) {
        item.isSelected.value = true;
      }
    } else {
      for (var item in filteredUnAssignedToChartSuppliers) {
        item.isSelected.value = false;
      }
    }

    update();
  }

  selectAllToUnAssign() {
    isSelectAllToUnAssign.value = !isSelectAllToUnAssign.value;

    if (!isSelectAllToUnAssign.value) {
      toBeUnAssignsuppliersIds.clear();
    } else {
      toBeUnAssignsuppliersIds
        ..clear()
        ..assignAll(
          filteredAssignedToChartSuppliers
              .map((item) => item.id.toString())
              .toList(),
        );
    }
    if (isSelectAllToUnAssign.value) {
      for (var item in filteredAssignedToChartSuppliers) {
        item.isSelected.value = true;
      }
    } else {
      for (var item in filteredAssignedToChartSuppliers) {
        item.isSelected.value = false;
      }
    }

    update();
  }

  showAllSelectedUnAssignedSupplier() {
    showSelected.value = !showSelected.value;
    if (showSelected.value) {
      filteredUnAssignedToChartSuppliers.assignAll(
        unAssignedToChartSuppliers.where(
          (supplier) => supplier.isSelected.value,
        ),
      );
    } else {
      filteredUnAssignedToChartSuppliers.assignAll(unAssignedToChartSuppliers);
    }

    update();
  }

  Future<void> assignRateChartToSuppliers() async {
    try {
      if (isAssigning.value) return;
      if (selectedShift.isEmpty) {
        showAppToastMessage('select_at_least_shift', true);
        return;
      } else if (toBeAssignsuppliersIds.isEmpty) {
        showAppToastMessage('select_at_least_one_supplier', true);
        return;
      }

      isAssigning.value = true;

      Map params = {
        "chart_id": AppState.chartIdForassignablesupplierScreen,
        "shift_id": selectedShift['id'].toString(),
      };

      if (AppState.customerTypeForassignablSupplierScreen ==
          AppState.supplierCustomerType) {
        params.addAll({"supplier_ids": toBeAssignsuppliersIds.value});
      } else {
        params.addAll({"buyer_ids": toBeAssignsuppliersIds.value});
      }
      Map response = await assignChartToSuppliersUsecase(params);

      if (response['success']) {
        isLoading.value =
            false; // because if we dont set false to it , then below function will  not call

        await getAllRateAssignableSuppliers();
        Get.find<AllRateChartsController>().getAllRateCharts();
        AppNavigation.goBack();

        showAppToastMessage(response['message'], false);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      isAssigning.value = false;
    }
  }

  Future<void> unassignRateChartToSuppliers() async {
    try {
      if (isLoading.value) return;
      if (toBeUnAssignsuppliersIds.isEmpty) {
        showAppToastMessage('select_at_least_one_supplier', true);
        return;
      }

      isLoading.value = true;

      final params = {
        "supplier_ids": toBeUnAssignsuppliersIds.value,
        "chartId": AppState.chartIdForassignablesupplierScreen,
      };
      Map response = await unassignChartToSuppliersUsecase(params);

      if (response['success']) {
        isLoading.value =
            false; // because if we dont set false to it , then below function will  not call

        await getAllRateAssignableSuppliers();
        Get.find<AllRateChartsController>().getAllRateCharts();

        showAppToastMessage(response['message'], false);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      isLoading.value = false;
    }
  }

  searchAssignedSupplier(String searchTerm) {
    filteredAssignedToChartSuppliers.assignAll(
      assignedToChartSuppliers.where(
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

  searchUnAssignedSupplier(String searchTerm) {
    filteredUnAssignedToChartSuppliers.assignAll(
      unAssignedToChartSuppliers.where(
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
}

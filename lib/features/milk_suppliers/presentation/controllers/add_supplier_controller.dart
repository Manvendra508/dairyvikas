import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/error/exceptions.dart' show AppExceptionHandler;
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/app_validations.dart';
import 'package:dairysathi/features/milk_suppliers/data/model/milk_supplier_model.dart';
import 'package:dairysathi/features/milk_suppliers/domain/usecases/add_milk_supplier_usecase.dart';
import 'package:dairysathi/features/milk_suppliers/domain/usecases/update_milk_suppliers_usecase.dart';
import 'package:dairysathi/features/milk_suppliers/presentation/controllers/get_milk_suppliers_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/local_datasources/local_storage_service.dart';

class AddMilkSupplierController extends GetxController with CommonMixin {
  final AddMilkSupplierUsecase _addMilkSupplierUsecase;
  final UpdateMilkSuppliersUsecase _updateMilkSupplierUsecase;
  String validationErrorMessage = '';
  RxBool hasFieldError = false.obs;
  AppValidation appValidation = AppValidation();
  RxBool proccessing = false.obs;
  final supplierCode = TextEditingController();
  final supplierFullName = TextEditingController();

  final supplierMobileNumber = TextEditingController();

  RxMap<String, dynamic> selectedMilkType = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> milkTypes = <Map<String, dynamic>>[
    {"id": '1', "value": "cow"},
    {"id": '2', "value": "buffalo"},
    {"id": "3", "value": "cow_buffalo"},
  ].obs;

  RxMap<String, dynamic> selectedStatus = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> status = <Map<String, dynamic>>[
    {"id": '1', "value": "active", "status": true},
    {"id": '2', "value": "inactive", "status": false},
  ].obs;

  AddMilkSupplierController(
    this._addMilkSupplierUsecase,
    this._updateMilkSupplierUsecase,
  );

  @override
  void onInit() {
    setSupplierDataForUpdate();
    super.onInit();
  }

  Future setSupplierDataForUpdate() async {
    if (!AppState.isSupplierEdit) return;
    MilkSupplierModel supplier = AppState.currentSupplierForUpdate;
    supplierCode.text = supplier.milkSupplierCode;
    supplierFullName.text = supplier.supplierName;
    supplierMobileNumber.text = supplier.supplierMobile;

    selectedMilkType.value = milkTypes.firstWhere(
      (mt) => mt['id'] == supplier.milkTypeId,
    );
    selectedStatus.value = status.firstWhere(
      (st) => st['status'] == supplier.status,
    );
  }

  getContactNameORNumber() async {
    List<String> contactDetails = await pickContactWithPermission();
    if (contactDetails.isNotEmpty) {
      if (contactDetails.length == 2) {
        supplierFullName.text = contactDetails[0];

        String phoneNumber = contactDetails[1];
        supplierMobileNumber.text = phoneNumber;
      } else if (contactDetails.length == 1) {
        supplierMobileNumber.text = contactDetails[0];
      }
    }
  }

  bool validateData() {
    final codeError = appValidation.validateCustomerCode(supplierCode.text);
    final mobileError = appValidation.validatePhoneForContacts(
      supplierMobileNumber.text,
    );

    final nameError = appValidation.validateName(supplierFullName.text);

    if (codeError != null) {
      _showErrorBox(codeError);
      return false;
    }

    if (nameError != null) {
      _showErrorBox(nameError);
      return false;
    }

    if (mobileError != null) {
      _showErrorBox(mobileError);
      return false;
    }

    if (selectedMilkType.isEmpty) {
      _showErrorBox('select_milk_type');
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

  Future<void> addNewMilkSupplier() async {
    if (!validateData() || proccessing.value) return;

    proccessing.value = true;

    final supplierData = {
      "milk_supplier_code": supplierCode.text,
      "supplierMobile": supplierMobileNumber.text.trim(),
      "supplierName": supplierFullName.text.trim(),
      "milk_type": int.parse(selectedMilkType['id'].toString()),
    };

    try {
      var response = await _addMilkSupplierUsecase(supplierData);
      _proccessResponse(response, false);
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      proccessing.value = false;
    }
  }

  Future<void> updateMilkSupplier() async {
    if (!validateData() || proccessing.value) return;

    proccessing.value = true;
    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';
    final supplierData = {
      "dairy_id": dairyId,
      "supplier_id": AppState.currentSupplierForUpdate.id,

      "milk_supplier_code": supplierCode.text,

      "supplier_name": supplierFullName.text.trim(),
      "milk_type": int.parse(selectedMilkType['id'].toString()),

      'status': selectedStatus['status'] ? '1' : '0',
    };
    try {
      var response = await _updateMilkSupplierUsecase(supplierData);
      _proccessResponse(response, true);
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      proccessing.value = false;
    }
  }

  _proccessResponse(var response, bool isFromupdate) async {
    if (response['success']) {
      final allMilkSuppliersController = Get.find<AllMilkSuppliersController>();
      showAppToastMessage(response['message'], false);

      await allMilkSuppliersController.getAllMilkSuppliers();

      if (isFromupdate) {
        AppNavigation.goBack();

        Future.delayed(const Duration(milliseconds: 100), () {
          AppNavigation.goBack();
        });
      } else {
        AppNavigation.goBack();
      }
    } else {
      showAppToastMessage(response['message'], true);
    }
  }
}

import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart' show AppExceptionHandler;
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_validations.dart';
import 'package:DairyVikas/features/milk_sale/data/models/milk_buyer_model.dart';
import 'package:DairyVikas/features/milk_sale/presentation/controllers/milk_buyers_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/local_datasources/local_storage_service.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../core/utils/app_navigation.dart';
import '../../domain/usecases/add_milk_buyer_usecase.dart';
import '../../domain/usecases/update_milk_buyer_usecase.dart';

class AddMilkBuyerController extends GetxController with CommonMixin {
  final AddMilkBuyerUsecase _addBuyerUsecase;
  final UpdateMilkBuyerUsecase _updateMilkBuyerUsecase;
  String validationErrorMessage = '';
  RxBool hasFieldError = false.obs;
  AppValidation appValidation = AppValidation();
  RxBool proccessing = false.obs;
  final buyerCode = TextEditingController();
  final buyerFullName = TextEditingController();

  final fixedCowRateController = TextEditingController();
  final fixedBuffaloRateController = TextEditingController();
  RxBool showCowFixedRateFormField = false.obs;
  RxBool showBufflaoFixedRateFormField = false.obs;
  final buyerMobileNumber = TextEditingController();
  int? currentMilkTypeId;
  RxList<Map<String, dynamic>> milkTypes = <Map<String, dynamic>>[
    {
      "id": 1,
      "value": 'cow',
      'icon': AppIcons.cow(size: 16),
      "isSelected": false.obs,
    },
    {
      "id": 2,
      "value": 'buffalo',
      'icon': AppIcons.buffalo(size: 16),
      "isSelected": false.obs,
    },
  ].obs;

  // RxMap<String, dynamic> selectedStatus = <String, dynamic>{}.obs;
  // RxList<Map<String, dynamic>> status = <Map<String, dynamic>>[
  //   {"id": '1', "value": "active", "status": true},
  //   {"id": '2', "value": "inactive", "status": false},
  // ].obs;
  RxList milktypIds = [].obs;
  RxMap<String, dynamic> selectedCowRateType = <String, dynamic>{}.obs;
  RxMap<String, dynamic> selectedBuffaloRateType = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> rateTypes = <Map<String, dynamic>>[
    {"id": 1, "value": "As Per Rate Chart"},
    {"id": 2, "value": "Fixed Rate"},
    {"id": 3, "value": "Manual Rate"},
  ].obs;

  AddMilkBuyerController(this._addBuyerUsecase, this._updateMilkBuyerUsecase);

  @override
  void onInit() {
    setBuyerDataForUpdate();
    super.onInit();
  }

  Future setBuyerDataForUpdate() async {
    if (!AppState.isMilkBuyerEdit) return;
    MilkBuyerModel buyer = AppState.currentBuyerForUpdate;
    buyerCode.text = buyer.milkBuyerCode;
    buyerFullName.text = buyer.buyerName;
    buyerMobileNumber.text = buyer.buyerMobile;
    if (buyer.milkTypeId == 1) {
      milktypIds.add(1);
    } else if (buyer.milkTypeId == 2) {
      milktypIds.add(2);
    } else if (buyer.milkTypeId == 3) {
      milktypIds.add(1);
      milktypIds.add(2);
    }

    selectedBuffaloRateType.value = rateTypes.firstWhere(
      (rt) => rt['id'] == buyer.buffaloMilkRateType,
      orElse: () => {},
    );

    selectedCowRateType.value = rateTypes.firstWhere(
      (rt) => rt['id'] == buyer.cowMilkRateType,
      orElse: () => {},
    );

    if (selectedCowRateType['id'] == 2) {
      showCowFixedRateFormField.value = true;
      fixedCowRateController.text = buyer.cowMilkRate.toString();
    }
    if (selectedBuffaloRateType['id'] == 2) {
      showBufflaoFixedRateFormField.value = true;
      fixedBuffaloRateController.text = buyer.buffaloMilkRate.toString();
    }

    // selectedMilkType.value = milkTypes.firstWhere(
    //   (mt) => mt['id'] == buyer.milkTypeId.toString(),
    // );
    // selectedMilkType.value['isSelected'] = true.obs;
    // selectedStatus.value = status.firstWhere(
    //   (st) => st['status'] == supplier.status,
    // );
  }

  getContactNameORNumber() async {
    List<String> contactDetails = await pickContactWithPermission();

    if (contactDetails.isNotEmpty) {
      if (contactDetails.length == 2) {
        buyerFullName.text = contactDetails[0];

        buyerMobileNumber.text = contactDetails[1];
      } else if (contactDetails.length == 1) {
        buyerMobileNumber.text = contactDetails[0];
      }
    }
  }

  bool validateData() {
    final codeError = appValidation.validateCustomerCode(buyerCode.text);
    final mobileError = appValidation.validatePhoneForContacts(
      buyerMobileNumber.text,
    );

    final nameError = appValidation.validateName(buyerFullName.text);

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

    // if (milktypIds.isEmpty) {
    //   _showErrorBox('select_milk_type');
    //   return false;
    // }

    // if (selectedMilkType.isEmpty) {
    //   _showErrorBox('select_milk_type');
    //   return false;
    // }

    if (milktypIds.isNotEmpty) {
      if (milktypIds.contains(1) && milktypIds.contains(2)) {
        // both cow and buffalo case

        // now check if user has selected rate type or not

        if (selectedCowRateType.isEmpty) {
          _showErrorBox('select_cow_rate_type');
          return false;
        } else {
          if (showCowFixedRateFormField.value) {
            if (fixedCowRateController.text.isEmpty) {
              _showErrorBox('enter_fixed_cow_rate');
              return false;
            }
          }
        }

        if (selectedBuffaloRateType.isEmpty) {
          _showErrorBox('select_buffalo_rate_type');
          return false;
        } else {
          if (showBufflaoFixedRateFormField.value) {
            if (fixedBuffaloRateController.text.isEmpty) {
              _showErrorBox('enter_fixed_buffalo_rate');
              return false;
            }
          }
        }
      } else {
        if (milktypIds.contains(1)) {
          // cow case

          // now check if user has selected rate type or not

          if (selectedCowRateType.isEmpty) {
            _showErrorBox('select_cow_rate_type');
            return false;
          } else {
            if (showCowFixedRateFormField.value) {
              if (fixedCowRateController.text.isEmpty) {
                _showErrorBox('enter_fixed_cow_rate');
                return false;
              }
            }
          }
        } else if (milktypIds.contains(2)) {
          // buffalo case
          if (selectedBuffaloRateType.isEmpty) {
            _showErrorBox('select_buffalo_rate_type');
            return false;
          } else {
            if (showBufflaoFixedRateFormField.value) {
              if (fixedBuffaloRateController.text.isEmpty) {
                _showErrorBox('enter_fixed_buffalo_rate');
                return false;
              }
            }
          }
        }
      }
    } else {
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

  Future<void> addNewMilkBuyer() async {
    if (!validateData() || proccessing.value) return;

    proccessing.value = true;
    int? milkTypeId;
    if (milktypIds.contains(1) && milktypIds.contains(2)) {
      milkTypeId = 3; // both
    } else if (milktypIds.contains(1)) {
      milkTypeId = 1; // cow
    } else if (milktypIds.contains(2)) {
      milkTypeId = 2; // buffalo
    }
    final buyerData = {
      "milk_buyer_code": buyerCode.text,
      "buyerMobile": buyerMobileNumber.text.trim(),
      "buyerName": buyerFullName.text.trim(),
      "milk_type": milkTypeId ?? 0,
      "cow_milk_Rate_type": selectedCowRateType['id'] ?? 0,
      "buffalo_milk_rate_type": selectedBuffaloRateType['id'] ?? 0,
    };

    if (selectedCowRateType['id'] == 2) {
      buyerData['cow_milk_rate'] = fixedCowRateController.text.trim();
    }
    if (selectedBuffaloRateType['id'] == 2) {
      buyerData['buffalo_milk_rate'] = fixedBuffaloRateController.text.trim();
    }

    try {
      var response = await _addBuyerUsecase(buyerData);
      _proccessResponse(response);
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      proccessing.value = false;
    }
  }

  Future<void> updateMilkBuyer() async {
    if (!validateData() || proccessing.value) return;

    proccessing.value = true;
    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';
    int? milkTypeId;
    if (milktypIds.contains(1) && milktypIds.contains(2)) {
      milkTypeId = 3; // both
    } else if (milktypIds.contains(1)) {
      milkTypeId = 1; // cow
    } else if (milktypIds.contains(2)) {
      milkTypeId = 2; // buffalo
    }
    final buyerData = {
      "dairy_id": dairyId,
      "buyer_id": AppState.currentBuyerForUpdate.id,
      "buyerMobile": buyerMobileNumber.text.trim(),
      "milk_buyer_code": buyerCode.text,

      "buyerName": buyerFullName.text.trim(),
      "milk_type": milkTypeId ?? 0,
      "cow_milk_Rate_type": selectedCowRateType['id'],
      "buffalo_milk_rate_type": selectedBuffaloRateType['id'],
      'status': '1',
    };
    if (selectedCowRateType['id'] == 2) {
      buyerData['cow_milk_rate'] = fixedCowRateController.text.trim();
    }
    if (selectedBuffaloRateType['id'] == 2) {
      buyerData['buffalo_milk_rate'] = fixedBuffaloRateController.text.trim();
    }
    try {
      var response = await _updateMilkBuyerUsecase(buyerData);
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
      final allMilkBuyersController = Get.find<MilkBuyersController>();
      showAppToastMessage(response['message'], false);

      await allMilkBuyersController.getAllMilkBuyers();

      AppNavigation.goBack();
    } else {
      showAppToastMessage(response['message'], true);
    }
  }

  selectMilkTypes() {
    if (currentMilkTypeId != null) {
      if (milktypIds.contains(currentMilkTypeId)) {
        milktypIds.remove(currentMilkTypeId);
      } else {
        milktypIds.add(currentMilkTypeId);
      }
    }
    update();
  }

  selectRatetype(int id) {
    if (id == 1) {
      // cow case
      if (selectedCowRateType['id'] == 2) {
        showCowFixedRateFormField.value = true;
      } else {
        showCowFixedRateFormField.value = false;
        fixedCowRateController.clear();
      }
    } else {
      if (selectedBuffaloRateType['id'] == 2) {
        showBufflaoFixedRateFormField.value = true;
      } else {
        showBufflaoFixedRateFormField.value = false;
        fixedBuffaloRateController.clear();
      }
    }
  }
}

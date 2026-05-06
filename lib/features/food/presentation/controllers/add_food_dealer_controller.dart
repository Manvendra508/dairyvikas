import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/error/exceptions.dart' show AppExceptionHandler;
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/app_validations.dart';
import 'package:dairysathi/features/food/data/models/dealer_model.dart';
import 'package:dairysathi/features/food/domain/usecases/add_food_dealer_usecase.dart';
import 'package:dairysathi/features/food/domain/usecases/update_food_dealer_usecase.dart';
import 'package:dairysathi/features/food/presentation/controllers/food_dealers_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/local_datasources/local_storage_service.dart';

class AddFoodDealerController extends GetxController with CommonMixin {
  final AddFoodDealerUsecase _addFoodDealerUsecase;
  final UpdateFoodDealerUsecase _updateFoodDealerUsecase;
  String validationErrorMessage = '';
  RxBool hasFieldError = false.obs;
  AppValidation appValidation = AppValidation();
  RxBool proccessing = false.obs;
  final dealerCode = TextEditingController();

  final dealerFullName = TextEditingController();
  final dealerAddress = TextEditingController();
  final dealerRemark = TextEditingController();
  final dealerMobileNumber = TextEditingController();

  AddFoodDealerController(
    this._addFoodDealerUsecase,
    this._updateFoodDealerUsecase,
  );

  @override
  void onInit() {
    setdealerDataForUpdate();
    super.onInit();
  }

  Future setdealerDataForUpdate() async {
    if (!AppState.isDealerEdit) return;
    DealerModel dealer = AppState.currentDealerForUpdate;
    dealerCode.text = dealer.dealerCode;
    dealerFullName.text = dealer.dealerName;
    dealerMobileNumber.text = dealer.mobile;
    dealerAddress.text = dealer.address;
    dealerRemark.text = dealer.details;
  }

  getContactNameORNumber() async {
    List<String> contactDetails = await pickContactWithPermission();
    if (contactDetails.isNotEmpty) {
      if (contactDetails.length == 2) {
        dealerFullName.text = contactDetails[0];

        dealerMobileNumber.text = contactDetails[1];
      } else if (contactDetails.length == 1) {
        dealerMobileNumber.text = contactDetails[0];
      }
    }
  }

  bool validateData() {
    final codeError = appValidation.validateCustomerCode(dealerCode.text);
    final mobileError = appValidation.validatePhoneForContacts(
      dealerMobileNumber.text,
    );

    final nameError = appValidation.validateName(dealerFullName.text);

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

    if (dealerAddress.text.trim().isEmpty) {
      _showErrorBox('enter_dealer_address');
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

  Future<void> addNewDealer() async {
    if (!validateData() || proccessing.value) return;

    proccessing.value = true;
    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';
    final dealerData = {
      'dairy_id': dairyId,
      "dealer_code": dealerCode.text,
      "dealerMobile": dealerMobileNumber.text.trim(),
      "dealerName": dealerFullName.text.trim(),
      "address": dealerAddress.text.trim(),
      'details': dealerRemark.text.trim(),
      'status': "1",
    };

    try {
      var response = await _addFoodDealerUsecase(dealerData);

      _proccessResponse(response);
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      proccessing.value = false;
    }
  }

  Future<void> updateDealer() async {
    if (!validateData() || proccessing.value) return;

    proccessing.value = true;
    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';
    final dealerData = {
      'dairy_id': dairyId,
      'dealer_id': AppState.currentDealerForUpdate.id,
      "dealer_code": dealerCode.text,
      "dealerMobile": dealerMobileNumber.text.trim(),
      "dealerName": dealerFullName.text.trim(),
      "address": dealerAddress.text.trim(),
      'status': 1,
      'details': dealerRemark.text.trim(),
    };
    try {
      var response = await _updateFoodDealerUsecase(dealerData);
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
      final foodDealersController = Get.find<FoodDealersController>();
      showAppToastMessage(response['message'], false);

      await foodDealersController.getAllFoodDealers();

      AppNavigation.goBack();
    } else {
      showAppToastMessage(response['message'], true);
    }
  }
}

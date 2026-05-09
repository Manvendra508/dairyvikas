// lib/presentation/controllers/auth/login_controller.dart
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/app_validations.dart';
import 'package:DairyVikas/features/auth/registration_flow/data/model/dairy_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DairyCenterDetailsController extends GetxController with CommonMixin {
  final AppValidation appValidation = AppValidation();

  RxBool showPassword = false.obs;
  final phoneController = TextEditingController();
  final pincodeController = TextEditingController();
  final dairyNameController = TextEditingController();
  final villageNameController = TextEditingController();
  final talukaNameController = TextEditingController();
  RxBool isSaving = false.obs;
  final otpController = TextEditingController();
  RxMap<String, dynamic> selectedState = <String, dynamic>{}.obs;
  RxMap<String, dynamic> selectedDisctrict = <String, dynamic>{}.obs;
  RxBool isVerifiedPincode = false.obs;
  final picodeNumberCount = 0.obs;
  String languageCode = 'en';
  String validationErrorMessage = '';
  RxBool hasFieldError = false.obs;

  @override
  void onInit() {
    languageCode = getLocal();
    super.onInit();
  }

  skipAddDairyStep() async {
    await SharedPrefsService.instance.savedairyDetailsSikped(true);
    AppNavigation.goToDashboardPage();
  }

  Future verifyPincode() async {
    bool isVerified = await fetchStateAndCityData(pincodeController.text);
    isVerifiedPincode.value = isVerified;
  }

  bool validateData() {
    if (dairyNameController.text.isEmpty) {
      _showErrorBox('dairyname_required');
      return false;
    }

    if (villageNameController.text.isEmpty) {
      _showErrorBox('village_name_required');
      return false;
    }

    if (talukaNameController.text.isEmpty) {
      _showErrorBox('taluka_name_required');
      return false;
    }

    if (pincodeController.text.isEmpty) {
      _showErrorBox('pincode_required');
      return false;
    } else if (pincodeController.text.length < 6) {
      _showErrorBox('invalid_pincode');
      return false;
    }

    if (selectedState['id'] == null) {
      _showErrorBox('state_required');
      return false;
    }

    if (selectedDisctrict['id'] == null) {
      _showErrorBox('district_required');
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

  clearData() {
    dairyNameController.clear();
    talukaNameController.clear();
    villageNameController.clear();
    pincodeController.clear();
    selectedState.value = AppState.indianStates[0];
    selectedDisctrict.clear();
  }

  Future saveDairyInfoInLocal() async {
    if (!validateData() || isSaving.value) return;

    try {
      isSaving.value = true;

      DairyModel addDairyModel = DairyModel(
        dairyName: dairyNameController.text.trim(),
        state: selectedState['id'].toString(),

        district: selectedDisctrict['id'].toString(),
        village: villageNameController.text,
        taluka: talukaNameController.text,
        pincode: pincodeController.text,
        collectionShift: '',
        collectionType: '',
        milkType: '',
        paymentPeriod: '',
        id: '',
        vendorName: '',
      );
      await SharedPrefsService.instance.saveDairyDetails(addDairyModel);
      showAppToastMessage('Dairy details added!', false);
      clearData();
      AppNavigation.goToDairyCenterSettingsPage();
    } finally {
      isSaving.value = false;
    }
  }

  cleaData() {
    dairyNameController.clear();
    talukaNameController.clear();
    villageNameController.clear();
    pincodeController.clear();
    selectedState.value = AppState.indianStates[0];
    selectedDisctrict.clear();
  }
}

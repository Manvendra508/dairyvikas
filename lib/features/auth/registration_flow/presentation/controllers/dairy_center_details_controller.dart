// lib/presentation/controllers/auth/login_controller.dart
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/app_validations.dart';
import 'package:DairyVikas/features/auth/registration_flow/data/model/dairy_model.dart';
import 'package:DairyVikas/features/auth/registration_flow/data/model/dairy_setting_data_model.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/entities/add_dairy_response_entity.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/entities/dairy_setting_data_response_entity.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/usecases/add_dairy_details_usecase.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/usecases/get_dairy_setting_data_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DairyCenterDetailsController extends GetxController with CommonMixin {
  final AppValidation appValidation = AppValidation();
  final AddDairyDetailsUsecase addDairyDetailsUsecase;

  final GetDairySettingDataUsecase getdairySettingsData;
  RxBool showPassword = false.obs;
  final phoneController = TextEditingController();
  final pincodeController = TextEditingController();
  final dairyNameController = TextEditingController();
  final villageNameController = TextEditingController();
  final talukaNameController = TextEditingController();
  RxBool isSaving = false.obs;
  Rx<AddDairyResponseEntity?> dairyDetails = Rx(null);
  final otpController = TextEditingController();
  RxMap<String, dynamic> selectedState = <String, dynamic>{}.obs;
  RxMap<String, dynamic> selectedDisctrict = <String, dynamic>{}.obs;
  RxBool isVerifiedPincode = false.obs;
  final picodeNumberCount = 0.obs;
  String languageCode = 'en';
  String validationErrorMessage = '';
  RxBool hasFieldError = false.obs;
  DairySettingDataModel selectedCollectionTypeId =
      DairySettingDataModel.empty();
  DairySettingDataModel selectedMilkTypeId = DairySettingDataModel.empty();
  DairySettingDataModel selectedCollectionShiftId =
      DairySettingDataModel.empty();
  DairySettingDataModel selectedPaymentPeriodId = DairySettingDataModel.empty();
  Rx<DairySettingDataResponseEntity?> dairysSettingData = Rx(null);
  List<DairySettingDataModel> collectionTypes = [];
  List<DairySettingDataModel> milkTypes = [];
  List<DairySettingDataModel> collectionShifts = [];
  List<DairySettingDataModel> paymentPeriods = [];

  DairyCenterDetailsController(
    this.addDairyDetailsUsecase,
    this.getdairySettingsData,
  );
  @override
  void onInit() {
    languageCode = getLocal();
    fetchDairySettingsData();
    selectedCollectionTypeId = DairySettingDataModel(id: '0', name: 'nan');
    selectedCollectionShiftId = DairySettingDataModel(id: '0', name: 'nan');
    selectedMilkTypeId = DairySettingDataModel(id: '0', name: 'nan');
    selectedPaymentPeriodId = DairySettingDataModel(id: '0', name: 'nan');
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
    if (selectedCollectionTypeId.id == '0') {
      _showErrorBox('select_collection_type');
      return false;
    }

    if (selectedPaymentPeriodId.id == '0') {
      _showErrorBox('select_payment_period');
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

  selectValues(int id, DairySettingDataModel value) {
    if (id == 1) {
      selectedCollectionTypeId = value;
    } else if (id == 2) {
      selectedMilkTypeId = value;
    } else if (id == 3) {
      selectedCollectionShiftId = value;
    } else if (id == 4) {
      selectedPaymentPeriodId = value;
    }
    update();
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

  Future<void> fetchDairySettingsData() async {
    try {
      dairysSettingData.value = await getdairySettingsData();

      if (dairysSettingData.value == null) return;
      if (dairysSettingData.value!.success) {
        collectionTypes.addAll(
          dairysSettingData.value!.settingData.collectionTypes,
        );

        collectionShifts.addAll(
          dairysSettingData.value!.settingData.collectionshifts,
        );
        milkTypes.addAll(dairysSettingData.value!.settingData.milkTypes);

        paymentPeriods.addAll(
          dairysSettingData.value!.settingData.paymentPeriods,
        );
        update();
      } else {
        showAppToastMessage(dairysSettingData.value!.message, true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    }
  }

  Future<void> addDairyDetails() async {
    if (!validateData() || isSaving.value) return;

    isSaving.value = true;

    List milktype = [1, 2];

    final map = {
      "dairyName": dairyNameController.text.trim(),
      "state": int.parse(selectedState['id'].toString()),

      "district": int.parse(selectedDisctrict['id'].toString()),
      "village": villageNameController.text.trim(),
      "taluka": talukaNameController.text.trim(),
      "pincode": int.parse(pincodeController.text),
      "collection_type": int.parse(selectedCollectionTypeId.id),

      "shift": 3,

      "milk_type": milktype,
      "payment_period": int.parse(selectedPaymentPeriodId.id),
    };

    try {
      dairyDetails.value = await addDairyDetailsUsecase(map);

      if (dairyDetails.value == null) return;
      if (dairyDetails.value!.success) {
        await SharedPrefsService.instance.saveDairyId(
          dairyDetails.value!.dairyModel.id,
        );

        await SharedPrefsService.instance.saveIsDairyAdded(true);

        AppState.isDairyAdded = true;

        showAppToastMessage('Dairy details added!', false);
        clearData();
        AppNavigation.goToDashboardPage();
      } else {
        showAppToastMessage(dairyDetails.value!.message, true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isSaving.value = false;
    }
  }

  // cleaData() {
  //   dairyNameController.clear();
  //   talukaNameController.clear();
  //   villageNameController.clear();
  //   pincodeController.clear();
  //   selectedState.value = AppState.indianStates[0];
  //   selectedDisctrict.clear();
  // }
}

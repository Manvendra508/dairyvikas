// lib/presentation/controllers/auth/login_controller.dart
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/error/exceptions.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/local_datasources/local_storage_service.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/features/auth/registration_flow/data/model/dairy_model.dart';
import 'package:dairysathi/features/auth/registration_flow/data/model/dairy_setting_data_model.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/entities/add_dairy_response_entity.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/usecases/add_dairy_details_usecase.dart';
import 'package:get/get.dart';

import '../../domain/entities/dairy_setting_data_response_entity.dart';
import '../../domain/usecases/get_dairy_setting_data_usecase.dart';

class DairyCenterSettingsController extends GetxController with CommonMixin {
  final AddDairyDetailsUsecase addDairyDetailsUsecase;

  final GetDairySettingDataUsecase getdairySettingsData;
  final appState = AppState();
  Rx<DairySettingDataResponseEntity?> dairysSettingData = Rx(null);
  Rx<AddDairyResponseEntity?> dairyDetails = Rx(null);
  RxBool isProccessing = false.obs;
  RxBool isLoading = true.obs;
  DairySettingDataModel selectedCollectionTypeId =
      DairySettingDataModel.empty();
  DairySettingDataModel selectedMilkTypeId = DairySettingDataModel.empty();
  DairySettingDataModel selectedCollectionShiftId =
      DairySettingDataModel.empty();
  DairySettingDataModel selectedPaymentPeriodId = DairySettingDataModel.empty();
  String validationErrorMessage = '';
  RxBool hasFieldError = false.obs;

  List<DairySettingDataModel> collectionTypes = [];
  List<DairySettingDataModel> milkTypes = [];
  List<DairySettingDataModel> collectionShifts = [];
  List<DairySettingDataModel> paymentPeriods = [];

  DairyCenterSettingsController(
    this.addDairyDetailsUsecase,
    this.getdairySettingsData,
  );

  @override
  void onInit() {
    fetchDairySettingsData();
    selectedCollectionTypeId = DairySettingDataModel(id: '0', name: 'nan');
    selectedCollectionShiftId = DairySettingDataModel(id: '0', name: 'nan');
    selectedMilkTypeId = DairySettingDataModel(id: '0', name: 'nan');
    selectedPaymentPeriodId = DairySettingDataModel(id: '0', name: 'nan');
    super.onInit();
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

  bool validateData() {
    if (selectedCollectionTypeId.id == '0') {
      _showErrorBox('select_collection_type');
      return false;
    }

    if (selectedMilkTypeId.id == '0') {
      _showErrorBox('select_milk_type');
      return false;
    }

    if (selectedCollectionShiftId.id == '0') {
      _showErrorBox('select_collection_shift');
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

  clearData() {
    selectedCollectionTypeId = DairySettingDataModel(id: '0', name: 'nan');
    selectedCollectionShiftId = DairySettingDataModel(id: '0', name: 'nan');
    selectedMilkTypeId = DairySettingDataModel(id: '0', name: 'nan');
    selectedPaymentPeriodId = DairySettingDataModel(id: '0', name: 'nan');
  }

  Future<void> addDairyDetails() async {
    if (!validateData() || isProccessing.value) return;

    isProccessing.value = true;
    DairyModel? dairyModel = await SharedPrefsService.instance
        .getDairyDetails();

    if (dairyModel == null) {
      showAppToastMessage('dairy_details_missing', true);
      return;
    }
    List milktype = [];
    if (int.parse(selectedMilkTypeId.id) == 1 ||
        int.parse(selectedMilkTypeId.id) == 2) {
      milktype.add(int.parse(selectedMilkTypeId.id));
    } else {
      milktype.add(1);
      milktype.add(2);
    }
    final map = {
      "dairyName": dairyModel.dairyName,
      "state": int.parse(dairyModel.state),

      "district": int.parse(dairyModel.district),
      "village": dairyModel.village,
      "taluka": dairyModel.taluka,
      "pincode": int.parse(dairyModel.pincode),
      "collection_type": int.parse(selectedCollectionTypeId.id),

      "shift": int.parse(selectedCollectionShiftId.id),

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

        AppState.isDairyAdded = true;

        await SharedPrefsService.instance.remove(
          SharedPrefsService.dairyDetailsKey,
        );
        clearData();
        AppNavigation.goToDashboardPage();
      } else {
        showAppToastMessage(dairyDetails.value!.message, true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isProccessing.value = false;
    }
  }
}

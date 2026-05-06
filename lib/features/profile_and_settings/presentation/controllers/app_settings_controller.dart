import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/error/exceptions.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/local_datasources/local_storage_service.dart';
import 'package:dairysathi/features/profile_and_settings/domain/usecases/update_dairy_setting_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/registration_flow/data/model/dairy_setting_data_model.dart';
import '../../../auth/registration_flow/domain/entities/dairy_setting_data_response_entity.dart';
import '../../../auth/registration_flow/domain/usecases/get_dairy_setting_data_usecase.dart';
import '../../domain/usecases/get_existing_setting_data_usecase.dart';

class AppSettingController extends GetxController with CommonMixin {
  final GetDairySettingDataUsecase getdairySettingsData;
  final GetExistingSettingDataUsecase getExistingSettingDataUsecase;
  final UpdateDairySettingUsecase updateDairySettingUsecase;

  final phoneController = TextEditingController();
  final pincodeController = TextEditingController();
  final dairyNameController = TextEditingController();
  final villageNameController = TextEditingController();
  final talukaNameController = TextEditingController();

  RxMap<String, dynamic> selectedState = <String, dynamic>{}.obs;
  RxMap<String, dynamic> selectedDisctrict = <String, dynamic>{}.obs;
  RxBool isVerifiedPincode = false.obs;
  final picodeNumberCount = 0.obs;
  String languageCode = 'en';
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  DairySettingDataModel selectedCollectionType = DairySettingDataModel.empty();
  DairySettingDataModel selectedMilkType = DairySettingDataModel.empty();
  DairySettingDataModel selectedCollectionShift = DairySettingDataModel.empty();
  DairySettingDataModel selectedPaymentPeriod = DairySettingDataModel.empty();

  List<DairySettingDataModel> collectionTypes = [];
  List<DairySettingDataModel> milkTypes = [];
  List<DairySettingDataModel> collectionShifts = [];
  List<DairySettingDataModel> paymentPeriods = [];

  Rx<DairySettingDataResponseEntity?> dairysSettingData = Rx(null);

  AppSettingController({
    required this.getdairySettingsData,
    required this.getExistingSettingDataUsecase,
    required this.updateDairySettingUsecase,
  });

  @override
  void onInit() {
    selectedCollectionType = DairySettingDataModel(id: '0', name: 'nan');
    selectedCollectionShift = DairySettingDataModel(id: '0', name: 'nan');
    selectedMilkType = DairySettingDataModel(id: '0', name: 'nan');
    selectedPaymentPeriod = DairySettingDataModel(id: '0', name: 'nan');
    super.onInit();

    firstMethod();
  }

  firstMethod() async {
    isLoading.value = true;

    await fetchDairySettingsData();
    await getExistingDairySettingsData();

    isLoading.value = false;
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

  Future<void> getExistingDairySettingsData() async {
    try {
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';

      Map response = await getExistingSettingDataUsecase(dairyId);

      if (response['success']) {
        Map<String, dynamic> data = response['data'];
        // basic details
        dairyNameController.text = data['dairy_name'] ?? '';
        villageNameController.text = data['village'] ?? '';
        talukaNameController.text = data['taluka'] ?? '';
        pincodeController.text = data['pincode'].toString();
        picodeNumberCount.value = pincodeController.text.length;
        selectedCollectionType = collectionTypes.firstWhere(
          (element) =>
              element.id == data['settings']['collection_type'].toString(),
          orElse: () => DairySettingDataModel(id: '0', name: 'nan'),
        );
        List list = data['settings']['milk_type'] ?? [];

        if (list.length > 1) {
          selectedMilkType = milkTypes.firstWhere(
            (element) => element.id == '3',
            orElse: () => milkTypes.first,
          );
        } else {
          selectedMilkType = milkTypes.firstWhere(
            (element) => element.id == list[0].toString(),
            orElse: () => milkTypes.first,
          );
        }

        selectedState.value = AppState.indianStates.firstWhere(
          (element) => element['id'].toString() == data['state'].toString(),
          orElse: () => {},
        );

        selectedDisctrict.value = selectedState['districs'].firstWhere(
          (element) => element['id'].toString() == data['district'].toString(),
          orElse: () => <String, dynamic>{},
        );

        selectedCollectionShift = collectionShifts.firstWhere(
          (element) => element.id == data['settings']['shift'].toString(),
          orElse: () => DairySettingDataModel(id: '0', name: 'nan'),
        );
        selectedPaymentPeriod = paymentPeriods.firstWhere(
          (element) =>
              element.id == data['settings']['payment_period'].toString(),
          orElse: () => DairySettingDataModel(id: '0', name: 'nan'),
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

  Future<void> updateDairySettingsData() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';

      List milktype = [];
      if (int.parse(selectedMilkType.id) == 1 ||
          int.parse(selectedMilkType.id) == 2) {
        milktype.add(int.parse(selectedMilkType.id));
      } else {
        milktype.add(1);
        milktype.add(2);
      }
      Map params = {
        "dairy_id": dairyId,
        "dairyName": dairyNameController.text,
        "state": selectedState['id'],
        "district": selectedDisctrict['id'],
        "village": villageNameController.text,
        "taluka": talukaNameController.text,
        "pincode": pincodeController.text,
        "collection_type": selectedCollectionType.id,
        "milk_type": milktype,
        "shift": selectedCollectionShift.id,
        "payment_period": selectedPaymentPeriod.id,
      };
      Map response = await updateDairySettingUsecase(params);

      if (response['success']) {
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

  Future verifyPincode() async {
    bool isVerified = await fetchStateAndCityData(pincodeController.text);
    isVerifiedPincode.value = isVerified;
  }

  selectValues(int id, DairySettingDataModel value) {
    if (id == 1) {
      selectedCollectionType = value;
    } else if (id == 2) {
      selectedMilkType = value;
    } else if (id == 3) {
      selectedCollectionShift = value;
    } else if (id == 4) {
      selectedPaymentPeriod = value;
    }
    update();
  }

  setSettingDataGlobaly() {
    AppState.dairyCollectionShifts.add(selectedCollectionShift);
    AppState.dairyCollectionTypes.add(selectedCollectionType);
    AppState.dairyMilkTypes.add(selectedMilkType);
    AppState.dairyPaymentPeriods.add(selectedPaymentPeriod);
  }
}

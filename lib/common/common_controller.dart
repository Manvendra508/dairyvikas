import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/local_datasources/local_storage_service.dart'
    show SharedPrefsService;
import 'package:dairysathi/features/auth/registration_flow/data/model/dairy_setting_data_model.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/entities/dairy_setting_data_response_entity.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/usecases/get_dairy_setting_data_usecase.dart';
import 'package:dairysathi/features/profile_and_settings/domain/usecases/get_existing_setting_data_usecase.dart';
import 'package:get/get.dart';

import '../core/error/exceptions.dart';
import '../features/collection/domain/usecases/get_date_range_usecase.dart';
import '../features/milk_suppliers/data/model/milk_suppliers_response_model.dart';
import '../features/milk_suppliers/domain/usecases/get_all_milk_suppliers_usecase.dart';

class CommonController extends GetxController with CommonMixin {
  final GetDateRangeUsecase getDateRangeUsecase;
  final GetAllMilkSuppliersUsecase getAllMilkSuppliersUsecase;
  final GetDairySettingDataUsecase getdairySettingsData;
  final GetExistingSettingDataUsecase getExistingSettingDataUsecase;
  MilkSuppliersResponseModel milkSuppliersResponseModel =
      MilkSuppliersResponseModel.empty();
  Rx<DairySettingDataResponseEntity?> dairysSettingData = Rx(null);

  List<DairySettingDataModel> collectionTypes = [];
  List<DairySettingDataModel> milkTypes = [];
  List<DairySettingDataModel> collectionShifts = [];
  List<DairySettingDataModel> paymentPeriods = [];
  DairySettingDataModel selectedCollectionType = DairySettingDataModel.empty();
  DairySettingDataModel selectedMilkType = DairySettingDataModel.empty();
  DairySettingDataModel selectedCollectionShift = DairySettingDataModel.empty();
  DairySettingDataModel selectedPaymentPeriod = DairySettingDataModel.empty();
  // @override
  // void onInit() {
  //   firstMethod();
  //   super.onInit();
  // }

  // Future firstMethod() async {
  //   await getAllMilkSuppliers();
  // }

  CommonController(
    this.getAllMilkSuppliersUsecase,
    this.getDateRangeUsecase,
    this.getdairySettingsData,
    this.getExistingSettingDataUsecase,
  );

  Future getAllMilkSuppliers() async {
    try {
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      Map response = await getAllMilkSuppliersUsecase(dairyId);

      if (response['success']) {
        AppState.milkSuppliers.clear();
        milkSuppliersResponseModel = MilkSuppliersResponseModel.fromJson(
          response['data'],
        );

        AppState.milkSuppliers.addAll(milkSuppliersResponseModel.suppliers);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    }
  }

  Future<void> getDateRange() async {
    try {
      var response = await getDateRangeUsecase();

      if (response['success']) {
        List dates = response['data'] as List;
        AppState.dateRanges.clear();

        AppState.dateRanges.addAll(dates.reversed.toList());
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
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
        await getExistingDairySettingsData();
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

        selectedCollectionShift = collectionShifts.firstWhere(
          (element) => element.id == data['settings']['shift'].toString(),
          orElse: () => DairySettingDataModel(id: '0', name: 'nan'),
        );
        selectedPaymentPeriod = paymentPeriods.firstWhere(
          (element) =>
              element.id == data['settings']['payment_period'].toString(),
          orElse: () => DairySettingDataModel(id: '0', name: 'nan'),
        );

        setSettingDataGlobaly();
        update();
      } else {
        showAppToastMessage(dairysSettingData.value!.message, true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    }
  }

  setSettingDataGlobaly() {
    AppState.dairyCollectionShifts.add(selectedCollectionShift);
    AppState.dairyCollectionTypes.add(selectedCollectionType);
    AppState.dairyMilkTypes.add(selectedMilkType);
    AppState.dairyPaymentPeriods.add(selectedPaymentPeriod);
  }
}

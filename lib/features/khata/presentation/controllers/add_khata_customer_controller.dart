// ignore_for_file: use_build_context_synchronously

import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/features/khata/domain/usecases/delete_khatacustomer_usecase.dart';
import 'package:DairyVikas/features/khata/domain/usecases/update_khatacustomer_usecase.dart';
import 'package:DairyVikas/features/khata/presentation/controllers/all_khata_customers_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/select_bool_option_widget.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/local_datasources/local_storage_service.dart';
import '../../../../core/utils/app_navigation.dart';
import '../../../../core/utils/app_validations.dart';
import '../../domain/usecases/add_khata_customer_usecase.dart';

class AddKhataCustomerController extends GetxController with CommonMixin {
  final AddKhataCustomerUsecase _addKhataCustomerUsecase;
  final UpdateKhatacustomerUsecase _updateKhatacustomerUsecase;
  final DeleteKhatacustomerUsecase _deleteKhatacustomerUsecase;
  String validationErrorMessage = '';
  RxBool hasFieldError = false.obs;
  AppValidation appValidation = AppValidation();
  RxBool proccessing = false.obs;
  RxBool isDeleting = false.obs;
  final khataCustomerName = TextEditingController();
  final khataCustomerPhone = TextEditingController();

  AddKhataCustomerController(
    this._addKhataCustomerUsecase,
    this._updateKhatacustomerUsecase,
    this._deleteKhatacustomerUsecase,
  );

  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    await setDataForUpdate();
  }

  setDataForUpdate() {
    if (!AppState.iskhataCustomerEdit) return;
    khataCustomerName.text = AppState.currentKhataBookCustomerForUpdate.name;
    khataCustomerPhone.text = AppState.currentKhataBookCustomerForUpdate.mobile;
  }

  getContactNameORNumber() async {
    List<String> contactDetails = await pickContactWithPermission();
    if (contactDetails.isNotEmpty) {
      if (contactDetails.length == 2) {
        khataCustomerName.text = contactDetails[0];
        String phoneNumber = contactDetails[1];
        khataCustomerPhone.text = phoneNumber;
      } else if (contactDetails.length == 1) {
        khataCustomerPhone.text = contactDetails[0];
      }
    }
  }

  bool validateData() {
    final mobileError = appValidation.validatePhoneForContacts(
      khataCustomerPhone.text,
    );

    final nameError = appValidation.validateName(khataCustomerName.text);

    if (nameError != null) {
      showAppToastMessage(nameError, true);
      return false;
    }

    if (mobileError != null) {
      showAppToastMessage(mobileError, true);
      return false;
    }
    return true;
  }

  Future<void> updateKhataCustomer() async {
    if (!validateData() || proccessing.value) return;

    proccessing.value = true;
    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';
    final postData = {
      "dairy_id": dairyId,
      "name": khataCustomerName.text,
      "mobile": khataCustomerPhone.text,
      'user_id': AppState.currentKhataBookCustomerForUpdate.khatabookUserId,
    };

    try {
      var response = await _updateKhatacustomerUsecase(postData);
      if (response['success']) {
        _proccessResponse(response);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      proccessing.value = false;
    }
  }

  Future<void> removeKhataCustomer() async {
    if (isDeleting.value) return;

    isDeleting.value = true;

    try {
      var response = await _deleteKhatacustomerUsecase(
        AppState.currentKhataBookCustomerForUpdate.khatabookUserId.toString(),
      );
      if (response['success']) {
        _proccessResponse(response);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> addKhataCustomer() async {
    if (!validateData() || proccessing.value) return;

    proccessing.value = true;
    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';
    final khatCustomerData = {
      "dairy_id": dairyId,
      "name": khataCustomerName.text,
      "mobile": khataCustomerPhone.text,
    };

    try {
      var response = await _addKhataCustomerUsecase(khatCustomerData);
      if (response['success']) {
        _proccessResponse(response);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      proccessing.value = false;
    }
  }

  _proccessResponse(var response) async {
    final khataCustomers = Get.find<AllKhataCustomersController>();
    showAppToastMessage(response['message'], false);

    await khataCustomers.getAllKhataCustomers();
    AppNavigation.goBack();
  }

  showDeleteCustomerOption(BuildContext context, String message) {
    showMyBottomSheet(
      context,
      SelectBoolOptionWidget(
        message: message,
        title: 'warning',
        callback: () async {
          AppNavigation.goBack();
          await removeKhataCustomer();
        },
      ),
    );
  }
}

// lib/presentation/controllers/auth/login_controller.dart
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/core/local_datasources/secured_storage_service.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/app_validations.dart';
import 'package:DairyVikas/features/auth/login/domain/usecases/login_user_usecase.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/entities/vendor_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController with CommonMixin {
  final LoginVendorUsecase loginVendorUsecase;

  final appState = AppState();
  RxBool isLogging = false.obs;
  Rx<VendorDataEntity?> vendorData = Rx(null);
  RxBool hasFieldError = false.obs;
  String validationErrorMessage = '';
  AppValidation appValidation = AppValidation();
  RxBool showPassword = false.obs;
  final phoneController = TextEditingController();

  final passwordController = TextEditingController();
  final numberCount = 0.obs;

  LoginController(this.loginVendorUsecase);

  @override
  void onInit() {
    firstMethod();

    super.onInit();
  }

  Future firstMethod() async {
    String? deviceId = await SecureStorage.instance.getVendorDeviceid();
    String? userAgent = await SecureStorage.instance.getVendorUserAgent();
    if (deviceId == null) {
      await genrateAndSaveDeviceId();
    }

    if (userAgent == null) {
      await genrateAndSaveUserAgent();
    }
  }

  showLanguageSheet(BuildContext context, Widget child) {
    showMyBottomSheet(context, child);
  }

  showHidePassword() {
    showPassword.value = !showPassword.value;
  }

  bool validateData() {
    final mobileError = appValidation.validatePhone(phoneController.text);
    final passError = appValidation.validatePassword(passwordController.text);

    if (mobileError != null) {
      _showErrorBox(mobileError);
      return false;
    }

    if (passError != null) {
      _showErrorBox(passError);
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

  Future<void> loginVendor() async {
    if (!validateData() || isLogging.value) return;
    String deviceId = await SecureStorage.instance.getVendorDeviceid() ?? '';
    String userAgent = await SecureStorage.instance.getVendorUserAgent() ?? '';

    isLogging.value = true;

    final map = {
      "password": passwordController.text.trim(),
      "mobile": phoneController.text.trim(),
      "device_id": deviceId,
      "user_agent": userAgent,
    };

    try {
      vendorData.value = await loginVendorUsecase(map);

      if (vendorData.value == null) return;
      if (vendorData.value!.success) {
        await saveDataSensitiveData(
          accessToken: vendorData.value!.accessToken,
          refreshToken: vendorData.value!.refreshToken,
        );
        await SharedPrefsService.instance.saveDairyId(
          vendorData.value!.vendorModel.dairyId,
        );

        await SharedPrefsService.instance.saveVendor(
          vendorData.value!.vendorModel,
        );
        passwordController.clear();
        phoneController.clear();
        AppNavigation.goToDashboardPage();
      } else {
        showAppToastMessage(vendorData.value!.message, true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isLogging.value = false;
    }
  }
}

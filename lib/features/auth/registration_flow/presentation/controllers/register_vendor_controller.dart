// lib/presentation/controllers/auth/login_controller.dart
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/app_validations.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/entities/register_vendor_respose_entity.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/usecases/register_vendor_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterVendorController extends GetxController with CommonMixin {
  final RegisterVendorUsecase registerVendorUsecase;
  final AppValidation appValidation = AppValidation();
  Rx<RegisterVendorReponseEntity?> user = Rx(null);
  String validationErrorMessage = '';
  RxBool isTermsAccepted = false.obs;
  RxBool isRegistring = false.obs;
  RxBool showPassword = false.obs;
  RxBool hasFieldError = false.obs;
  final phoneController = TextEditingController();
  final nameController = TextEditingController();

  final passwordController = TextEditingController();
  final numberCount = 0.obs;
  final otpNumberCount = 0.obs;

  RegisterVendorController(this.registerVendorUsecase);

  showHidePassword() {
    showPassword.value = !showPassword.value;
  }

  @override
  void onClose() {
    phoneController.clear();
    nameController.clear();
    passwordController.clear();
    super.onClose();
  }

  bool validateData() {
    final nameError = appValidation.validateName(nameController.text);
    final mobileError = appValidation.validatePhone(phoneController.text);
    final passError = appValidation.validatePassword(passwordController.text);

    if (nameError != null) {
      _showErrorBox(nameError);
      return false;
    }

    if (mobileError != null) {
      _showErrorBox(mobileError);
      return false;
    }

    if (passError != null) {
      _showErrorBox(passError);
      return false;
    }

    if (!isTermsAccepted.value) {
      _showErrorBox('accept_terms');
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

  Future<void> registerNewVendor() async {
    if (!validateData() || isRegistring.value) return;

    isRegistring.value = true;

    final map = {
      "name": nameController.text.trim(),
      "mobile": phoneController.text.trim(),
      "password": passwordController.text.trim(),
      "terms_and_conditions": isTermsAccepted.value ? '1' : "0",
    };

    try {
      user.value = await registerVendorUsecase(map);

      if (user.value == null) return;
      if (user.value!.success) {
        AppNavigation.goToOtpVerifyPage(
          phoneController.text,
          'we_have_sent_otp',
        );
      } else {
        showAppToastMessage(user.value!.message, true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isRegistring.value = false;
    }
  }
}

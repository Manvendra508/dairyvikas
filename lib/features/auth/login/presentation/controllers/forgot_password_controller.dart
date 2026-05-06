// lib/presentation/controllers/auth/login_controller.dart
import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/error/exceptions.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/local_datasources/secured_storage_service.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/app_validations.dart';
import 'package:dairysathi/features/auth/login/domain/usecases/reset_password_usecase.dart';
import 'package:dairysathi/features/auth/login/domain/usecases/send_otp_to_registred_number_usecase.dart';
import 'package:dairysathi/features/auth/login/domain/usecases/verify_forgot_password_otp_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController with CommonMixin {
  final SendOtpForForgotPassowrdUsecase sendOtpForForgotPassowrdUsecase;
  final VerifyForgotPasswordOtpUsecase verifyForgotPasswordOtpUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;
  final appState = AppState();
  RxBool proccessing = false.obs;
  RxString buttonText = 'get_otp'.obs;
  RxBool hasFieldError = false.obs;
  RxBool showOtpFeildField = false.obs;
  RxBool showPasswordField = false.obs;
  String validationErrorMessage = '';
  AppValidation appValidation = AppValidation();
  RxBool showPassword = false.obs;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final numberCount = 0.obs;

  ForgotPasswordController(
    this.sendOtpForForgotPassowrdUsecase,
    this.verifyForgotPasswordOtpUsecase,
    this.resetPasswordUsecase,
  );

  @override
  void onInit() {
    firstMethod();

    super.onInit();
  }

  @override
  void onClose() {
    // if (_timer != null) {
    //   _timer!.cancel();
    // }

    super.onClose();
  }

  handleButtonCalls() {
    if (!showOtpFeildField.value && !showPasswordField.value) {
      sendOtpToRegisteredNumber();
    } else if (showOtpFeildField.value && !showPasswordField.value) {
      verifyOtpForRegisteredNumber();
    } else if (!showOtpFeildField.value && showPasswordField.value) {
      resetPasswordNow();
    }
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

  bool validatePhoneNumber() {
    final mobileError = appValidation.validatePhone(phoneController.text);

    if (mobileError != null) {
      _showErrorBox(mobileError);
      return false;
    }

    return true;
  }

  bool validateOtp() {
    if (otpController.text.isEmpty || otpController.text.length < 6) {
      _showErrorBox('otp_required');
      return false;
    }

    return true;
  }

  bool validatePassword() {
    final passError = appValidation.validatePassword(
      newPasswordController.text,
    );
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

  Future<void> sendOtpToRegisteredNumber() async {
    if (!validatePhoneNumber() || proccessing.value) return;

    proccessing.value = true;

    final map = {"mobile": phoneController.text.trim()};

    try {
      Map response = await sendOtpForForgotPassowrdUsecase(map);

      if (response['success']) {
        showAppToastMessage(response['message'], false);
        showOtpFeildField.value = true;
        buttonText.value = 'verify_otp';
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

  Future<void> verifyOtpForRegisteredNumber() async {
    if (!validatePhoneNumber() || !validateOtp() || proccessing.value) return;

    proccessing.value = true;

    final map = {
      "mobile": phoneController.text.trim(),
      'otp': otpController.text.trim(),
    };

    try {
      Map response = await verifyForgotPasswordOtpUsecase(map);

      if (response['success']) {
        showAppToastMessage(response['message'], false);
        showPasswordField.value = true;
        showOtpFeildField.value = false;
        buttonText.value = 'reset_password';
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

  Future<void> resetPasswordNow() async {
    if (!validatePhoneNumber() || !validatePassword() || proccessing.value) {
      return;
    }

    proccessing.value = true;

    final map = {
      "mobile": phoneController.text.trim(),
      'new_password': newPasswordController.text.trim(),
    };

    try {
      Map response = await resetPasswordUsecase(map);

      if (response['success']) {
        showAppToastMessage(
          response['message'],
          false,
          backgroundColor: AppColors.whiteColor,
          textColor: AppColors.blackColor,
        );
        AppNavigation.goBack();
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
}

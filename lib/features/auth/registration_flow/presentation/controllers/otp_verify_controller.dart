// lib/presentation/controllers/auth/login_controller.dart
import 'dart:async';

import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/core/local_datasources/secured_storage_service.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/usecases/resend_otp_usecase.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/vendor_data_entity.dart';

class OtpVerifyController extends GetxController with CommonMixin {
  final VerifyOtpUsecase verifyOtpUsecase;
  final ResendOtpUsecase resendOtpUsecase;
  final appState = AppState();
  Rx<VendorDataEntity?> vendorData = Rx(null);
  final FocusNode pinFocusNode = FocusNode();
  RxBool isMessageBoxVisible = true.obs;
  final otpController = TextEditingController();
  RxBool isVerifying = false.obs;
  RxBool isButtonDisable = true.obs;
  RxInt secondsRemaining = 30.obs;
  RxBool isTimeron = false.obs;
  Timer? _timer;
  OtpVerifyController(this.verifyOtpUsecase, this.resendOtpUsecase);

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 300), () {
      pinFocusNode.requestFocus();
    });
    startTimerForOtpResend(null);
    showHideMessageBox();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }

    otpController.clear();
    super.onClose();
  }

  showHideMessageBox() async {
    isMessageBoxVisible.value = true;
    Future.delayed(Duration(seconds: 3), () {
      isMessageBoxVisible.value = false;
    });
  }

  void startTimerForOtpResend(String? mobile) async {
    if (isTimeron.value) return;
    secondsRemaining.value = 30;
    isTimeron.value = true;
    await resendOtpOnPhoneNumber(mobile);
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
      } else {
        timer.cancel();
        isTimeron.value = false;
      }
    });
  }

  Future<void> resendOtpOnPhoneNumber(String? mobile) async {
    try {
      if (mobile == null) return;
      Map response = await resendOtpUsecase(mobile);

      if (response['success']) {
        showHideMessageBox();
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    }
  }

  Future<void> verifyOtp(String phoneNumber) async {
    if (isVerifying.value || isButtonDisable.value) return;

    isVerifying.value = true;
    String deviceId = await SecureStorage.instance.getVendorDeviceid() ?? '';
    String userAgent = await SecureStorage.instance.getVendorUserAgent() ?? '';
    final map = {
      "otp": otpController.text.trim(),
      "mobile": phoneNumber.trim(),
      "device_id": deviceId,
      "user_agent": userAgent,
    };

    try {
      vendorData.value = await verifyOtpUsecase(map);

      if (vendorData.value == null) return;
      if (vendorData.value!.success) {
        await saveDataSensitiveData(
          accessToken: vendorData.value!.accessToken,
          refreshToken: vendorData.value!.refreshToken,
        );
        //  appState.vendorId = vendorData.value!.vendorModel.id;
        await SharedPrefsService.instance.saveVendor(
          vendorData.value!.vendorModel,
        );
        AppNavigation.goToDairyCenterDetailsPage(false);
        showAppToastMessage(vendorData.value!.message, false);
      } else {
        showAppToastMessage(vendorData.value!.message, true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isVerifying.value = false;
    }
  }
}

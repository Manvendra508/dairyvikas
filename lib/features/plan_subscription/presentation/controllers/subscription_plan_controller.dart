import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/error/exceptions.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/other_services/razorpay_service.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/features/plan_subscription/data/model/subscription_plan_model.dart';
import 'package:dairysathi/features/plan_subscription/domain/usecases/verify_payment_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../domain/usecases/get_all_plans.dart';
import '../../domain/usecases/get_orderId_uecase.dart';

class SubscriptionPlanController extends GetxController with CommonMixin {
  final GetAllSubscriptionPlansUsecase _getAllPlansUsecase;
  final GetOrderidUecase _getOrderidUecase;
  final VerifyPaymentUsecase _verifyPaymentUsecase;
  RxBool hasError = false.obs;
  late RazorpayService razorpayService;
  RxBool isInitiatingPayment = false.obs;
  RxList<SubscriptionPlanModel> subscriptionPlans =
      <SubscriptionPlanModel>[].obs;

  SubscriptionPlanModel selectedPlan = SubscriptionPlanModel.empty();

  RxBool isLoading = false.obs;

  SubscriptionPlanController(
    this._getAllPlansUsecase,
    this._getOrderidUecase,
    this._verifyPaymentUsecase,
  );
  @override
  void onInit() {
    super.onInit();
    firstMethod();

    razorpayService = RazorpayService();

    razorpayService.init(
      onSuccess: handlePaymentSuccess,
      onError: handlePaymentError,
      onExternalWallet: handleExternalWallet,
    );
  }

  Future firstMethod() async {
    await getAllPlans();
  }

  Future getAllPlans() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;

      Map response = await _getAllPlansUsecase();

      if (response['success']) {
        hasError.value = false;
        subscriptionPlans.clear();

        List plansJson = response['plans'] as List;

        subscriptionPlans.assignAll(
          plansJson
              .map((item) => SubscriptionPlanModel.fromJson(item))
              .toList(),
        );
      } else {
        hasError.value = true;
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      hasError.value = true;
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<String>> getOrderIdAndKey(String planId) async {
    List<String> data = [];
    try {
      Map response = await _getOrderidUecase(planId);

      if (response['success']) {
        data.add(response['data']['order_id']);
        data.add(response['data']['key']);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      hasError.value = true;
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    }
    return data;
  }

  Future verifyPayment({
    required String paymentId,
    required String orderId,
    required String signature,
  }) async {
    try {
      Map pramas = {
        "razorpay_order_id": orderId,
        "razorpay_payment_id": paymentId,
        "razorpay_signature": signature,
      };
      Map response = await _verifyPaymentUsecase(pramas);

      if (response['success']) {
        AppState.isPaymentSuccess = true;
        AppNavigation.goToPaymentPage(true);
      } else {
        AppState.isPaymentSuccess = false;
        AppNavigation.goToPaymentPage(false);
      }
    } catch (e) {
      hasError.value = true;
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    }
    return orderId;
  }

  void startPayment(SubscriptionPlanModel plan) async {
    selectedPlan = plan;
    try {
      isInitiatingPayment.value = true;
      List<String> data = await getOrderIdAndKey(plan.id.toString());

      if (data[0].isEmpty) {
        showAppToastMessage('payment_failed', true);

        return;
      } else {
        razorpayService.openCheckout(
          orderId: data[0],
          amount: plan.price,
          name: "Dairy Sathi",
          contact: "9999999999",
          email: "test@gmail.com",
          key: data[1], // its key
        );
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    await verifyPayment(
      paymentId: response.paymentId!,
      orderId: response.orderId!,
      signature: response.signature!,
    );
    isInitiatingPayment.value = false;
  }

  void handlePaymentError(PaymentFailureResponse response) {
    AppState.isPaymentSuccess = false;
    AppNavigation.goToPaymentPage(false);

    if (kDebugMode) {
      print("Payment Failed: ${response.message}");
    }
    isInitiatingPayment.value = false;
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    if (kDebugMode) {
      print("Wallet Selected: ${response.walletName}");
    }
  }
}

import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;

  void init({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    required Function(ExternalWalletResponse) onExternalWallet,
  }) {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  void openCheckout({
    required String orderId,
    required double amount,
    required String name,
    required String contact,
    required String email,
    required String key,
  }) {
    int totalPayableAmount = (amount * 100).toInt(); // paisa

    var options = {
      'key': key,
      'amount': totalPayableAmount,
      'name': name,
      'order_id': orderId,
      'prefill': {'contact': contact, 'email': email},
      // 'theme': {'color': '#096E50'},
    };

    _razorpay.open(options);
  }
}

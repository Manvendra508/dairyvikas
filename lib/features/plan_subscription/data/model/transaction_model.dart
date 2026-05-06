import 'package:dairysathi/features/plan_subscription/data/model/payment_plan_model.dart';
import 'package:dairysathi/features/plan_subscription/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.vendorId,
    required super.planId,
    required super.razorpayOrderId,
    required super.razorpayPaymentId,
    super.razorpaySignature,
    required super.amount,
    required super.currency,
    required super.status,
    required super.gatewayStatus,
    required super.paymentMethod,
    super.bank,
    super.wallet,
    super.upiVpa,
    super.cardLast4,
    super.cardNetwork,
    required super.createdAt,
    required super.updatedAt,
    required super.paymentPlan,
  });

  /// FROM JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? 0,
      vendorId: json['vendor_id'] ?? 0,
      planId: json['plan_id'] ?? 0,
      razorpayOrderId: json['razorpay_order_id'] ?? '',
      razorpayPaymentId: json['razorpay_payment_id'] ?? '',
      razorpaySignature: json['razorpay_signature'],
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? '',
      status: json['status'] ?? '',
      gatewayStatus: json['gateway_status'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      bank: json['bank'],
      wallet: json['wallet'],
      upiVpa: json['upi_vpa'],
      cardLast4: json['card_last4'],
      cardNetwork: json['card_network'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      paymentPlan: PaymentPlanModel.fromJson(json['payment_plan'] ?? {}),
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "vendor_id": vendorId,
      "plan_id": planId,
      "razorpay_order_id": razorpayOrderId,
      "razorpay_payment_id": razorpayPaymentId,
      "razorpay_signature": razorpaySignature,
      "amount": amount,
      "currency": currency,
      "status": status,
      "gateway_status": gatewayStatus,
      "payment_method": paymentMethod,
      "bank": bank,
      "wallet": wallet,
      "upi_vpa": upiVpa,
      "card_last4": cardLast4,
      "card_network": cardNetwork,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "payment_plan": (paymentPlan as PaymentPlanModel).toJson(),
    };
  }

  /// EMPTY
  factory TransactionModel.empty() {
    return TransactionModel(
      id: 0,
      vendorId: 0,
      planId: 0,
      razorpayOrderId: '',
      razorpayPaymentId: '',
      razorpaySignature: null,
      amount: 0,
      currency: '',
      status: '',
      gatewayStatus: '',
      paymentMethod: '',
      bank: null,
      wallet: null,
      upiVpa: null,
      cardLast4: null,
      cardNetwork: null,
      createdAt: '',
      updatedAt: '',
      paymentPlan: PaymentPlanModel.empty(),
    );
  }
}

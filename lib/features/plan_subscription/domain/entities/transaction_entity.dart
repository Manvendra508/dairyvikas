class TransactionEntity {
  final int id;
  final int vendorId;
  final int planId;
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String? razorpaySignature;
  final int amount;
  final String currency;
  final String status;
  final String gatewayStatus;
  final String paymentMethod;
  final String? bank;
  final String? wallet;
  final String? upiVpa;
  final String? cardLast4;
  final String? cardNetwork;
  final String createdAt;
  final String updatedAt;
  final PaymentPlanEntity paymentPlan;

  const TransactionEntity({
    required this.id,
    required this.vendorId,
    required this.planId,
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    this.razorpaySignature,
    required this.amount,
    required this.currency,
    required this.status,
    required this.gatewayStatus,
    required this.paymentMethod,
    this.bank,
    this.wallet,
    this.upiVpa,
    this.cardLast4,
    this.cardNetwork,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentPlan,
  });
}

class PaymentPlanEntity {
  final int id;
  final String name;
  final int price;

  const PaymentPlanEntity({
    required this.id,
    required this.name,
    required this.price,
  });
}

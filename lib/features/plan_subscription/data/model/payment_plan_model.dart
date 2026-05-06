import '../../domain/entities/transaction_entity.dart';

class PaymentPlanModel extends PaymentPlanEntity {
  const PaymentPlanModel({
    required super.id,
    required super.name,
    required super.price,
  });

  factory PaymentPlanModel.fromJson(Map<String, dynamic> json) {
    return PaymentPlanModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "price": price};
  }

  factory PaymentPlanModel.empty() {
    return const PaymentPlanModel(id: 0, name: '', price: 0);
  }
}

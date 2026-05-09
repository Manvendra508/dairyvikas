import 'package:DairyVikas/features/food/domain/entity/supplier_buyer_entity.dart';

class SupplierBuyerModel extends SupplierBuyerEntity {
  SupplierBuyerModel({
    required super.name,
    required super.code,
    required super.mobile,
    required super.type,
    required super.id,
    required super.status,
  });

  /// 🔹 From JSON
  factory SupplierBuyerModel.fromJson(Map<String, dynamic> json) {
    return SupplierBuyerModel(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      mobile: json['mobile'] ?? '',
      type: json['type'] ?? '',
      id: json['id'] ?? 0,
      status: json['status'] ?? false,
    );
  }

  /// 🔹 To JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'mobile': mobile,
      'type': type,
      'id': id,
      'status': status,
    };
  }

  /// 🔹 Empty Model
  factory SupplierBuyerModel.empty() {
    return SupplierBuyerModel(
      name: '',
      code: '',
      mobile: '',
      type: '',
      id: 0,
      status: false,
    );
  }
}

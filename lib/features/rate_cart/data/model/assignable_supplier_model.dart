import 'package:get/get_rx/get_rx.dart';

import '../../domain/entities/assignalbe_supplier_entity.dart';

class AssignableSupplierModel extends AssignalbeSupplierEntity {
  AssignableSupplierModel({
    required super.isSelected,
    required super.id,
    required super.supplierName,
    required super.milkSupplierCode,
    required super.supplierMobile,
  });

  /// ---------------- FROM JSON ----------------
  factory AssignableSupplierModel.fromJson(Map<String, dynamic> json) {
    return AssignableSupplierModel(
      id: json['id'] is String
          ? int.tryParse(json['id']) ?? 0
          : json['id'] ?? 0,
      supplierName: json['supplier_name']?.toString() ?? '',
      milkSupplierCode: json['milk_supplier_code']?.toString() ?? '',
      supplierMobile: json['supplier_mobile']?.toString() ?? '',
      isSelected: false.obs,
    );
  }

  factory AssignableSupplierModel.fromJsonForBuyer(Map<String, dynamic> json) {
    return AssignableSupplierModel(
      id: json['id'] is String
          ? int.tryParse(json['id']) ?? 0
          : json['id'] ?? 0,
      supplierName: json['buyer_name']?.toString() ?? '',
      milkSupplierCode: json['milk_buyer_code']?.toString() ?? '',
      supplierMobile: json['buyer_mobile']?.toString() ?? '',
      isSelected: false.obs,
    );
  }

  /// ---------------- TO JSON ----------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplier_name': supplierName,
      'milk_supplier_code': milkSupplierCode,
      'supplier_mobile': supplierMobile,
    };
  }

  /// ---------------- EMPTY MODEL ----------------
  factory AssignableSupplierModel.empty() {
    return AssignableSupplierModel(
      id: 0,
      supplierName: '',
      milkSupplierCode: '',
      supplierMobile: '',
      isSelected: false.obs,
    );
  }
}

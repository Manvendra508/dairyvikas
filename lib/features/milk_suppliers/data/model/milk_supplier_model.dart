import 'package:DairyVikas/features/milk_suppliers/domain/entities/milk_supplier_entity.dart';

class MilkSupplierModel extends MilkSupplierEntity {
  MilkSupplierModel({
    required super.id,
    required super.dairyId,
    required super.userId,
    required super.milkSupplierCode,
    required super.milkTypeId,
    required super.status,
    required super.createdAt,
    required super.isDelete,
    required super.supplierName,
    required super.supplierMobile,
    required super.milkTypeName,
    required super.email,
  });

  /// ---------------- FROM JSON ----------------
  factory MilkSupplierModel.fromJson(Map<String, dynamic> json) {
    return MilkSupplierModel(
      id: json['id']?.toString() ?? '',
      dairyId: json['dairy_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      milkSupplierCode: json['milk_supplier_code']?.toString() ?? '',
      milkTypeId: json['milk_type_id']?.toString() ?? '',
      status: json['status'] ?? false,
      createdAt: json['createdAt']?.toString() ?? '',
      isDelete: json['is_delete'] ?? false,
      supplierName: json['supplier_name']?.toString() ?? '',
      supplierMobile: json['supplier_mobile']?.toString() ?? '',
      milkTypeName: json['milk_type_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  /// ---------------- TO JSON ----------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dairy_id': dairyId,
      'user_id': userId,
      'milk_supplier_code': milkSupplierCode,
      'milk_type_id': milkTypeId,
      'status': status,
      'createdAt': createdAt,
      'is_delete': isDelete,
      'supplier_name': supplierName,
      'supplier_mobile': supplierMobile,
      'milk_type_name': milkTypeName,
      "email": email,
    };
  }

  /// ---------------- EMPTY MODEL ----------------
  factory MilkSupplierModel.empty() {
    return MilkSupplierModel(
      id: '',
      dairyId: '',
      userId: '',
      milkSupplierCode: '',
      milkTypeId: '',
      status: false,
      createdAt: '',
      isDelete: false,
      supplierName: '',
      supplierMobile: '',
      milkTypeName: '',
      email: '',
    );
  }
}

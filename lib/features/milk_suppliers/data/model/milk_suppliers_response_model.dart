import 'package:dairysathi/features/milk_suppliers/data/model/milk_supplier_model.dart';

import '../../domain/entities/milk_supplier_response_entity.dart';

class MilkSuppliersResponseModel extends MilkSuppliersReponseEntity {
  MilkSuppliersResponseModel({
    required super.suppliers,
    required super.totalCount,
    required super.deletedCount,
    required super.activeCount,
    required super.inactiveCount,
  });

  /// ---------------- FROM JSON ----------------
  factory MilkSuppliersResponseModel.fromJson(Map<String, dynamic> json) {
    return MilkSuppliersResponseModel(
      suppliers:
          (json['suppliers'] as List<dynamic>?)
              ?.map((e) => MilkSupplierModel.fromJson(e))
              .toList() ??
          <MilkSupplierModel>[],
      totalCount: json['totalCount']?.toString() ?? '0',
      deletedCount: json['deletedCount']?.toString() ?? '0',
      activeCount: json['activeCount']?.toString() ?? '0',
      inactiveCount: json['inactiveCount']?.toString() ?? '0',
    );
  }

  /// ---------------- TO JSON ----------------
  Map<String, dynamic> toJson() {
    return {
      'suppliers': suppliers.map((e) => e.toJson()).toList(),
      'total_count': totalCount,
      'deleted_count': deletedCount,
      'active_count': activeCount,
      'inactive_count': inactiveCount,
    };
  }

  /// ---------------- EMPTY ----------------
  factory MilkSuppliersResponseModel.empty() {
    return MilkSuppliersResponseModel(
      suppliers: <MilkSupplierModel>[],
      totalCount: '0',
      deletedCount: '0',
      activeCount: '0',
      inactiveCount: '0',
    );
  }
}

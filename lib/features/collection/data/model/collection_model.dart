import '../../domain/entities/collection_entity.dart';
import 'collection_can_model.dart';

class CollectionModel extends CollectionEntity {
  CollectionModel({
    required super.collectionId,
    required super.supplierId,
    required super.collectionShiftId,
    required super.milkTypeId,
    required super.litre,
    required super.fat,
    required super.snf,
    required super.clr,
    required super.ratePerLitre,
    required super.totalAmount,
    required super.collectionDate,
    required super.collectionSupplier,
    required super.steps,
    required super.sampleCount,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      collectionId: json['collection_id'] ?? json['id'],
      supplierId: json['supplier_id'],
      collectionShiftId: json['shift_id'],
      milkTypeId: json['milk_type_id'],
      litre: json['litre'] ?? 0,
      fat: (json['fat'] as num).toDouble(),
      snf: json['snf'] == null ? 0.0 : (json['snf'] as num).toDouble(),
      clr: json['clr'] == null ? 0.0 : (json['clr'] as num).toDouble(),
      ratePerLitre: json['rate_per_litre'] == null
          ? 0.0
          : (json['rate_per_litre'] as num).toDouble(),
      totalAmount: json['total_amount'] == null
          ? 0.0
          : (json['total_amount'] as num).toDouble(),
      collectionDate: json['collection_date'],
      collectionSupplier: CollectionSupplierModel.fromJson(
        json['collection_supplier'],
      ),
      steps: (json['can_data'] as List<dynamic>? ?? [])
          .map((e) => CanStepModel.fromJson(e))
          .toList(),
      sampleCount: json['sample_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "collection_id": collectionId,
      "supplier_id": supplierId,
      "shift_id": collectionShiftId,
      "milk_type_id": milkTypeId,
      "litre": litre,
      "fat": fat,
      "snf": snf,
      "clr": clr,
      "rate_per_litre": ratePerLitre,
      "total_amount": totalAmount,
      "collection_date": collectionDate,
      "collection_supplier": (collectionSupplier).toJson(),
      "can_data": steps.map((e) => (e).toJson()).toList(),
      "sample_count": sampleCount,
    };
  }

  factory CollectionModel.empty() {
    return CollectionModel(
      collectionId: 0,
      supplierId: 0,
      collectionShiftId: 0,
      milkTypeId: 0,
      litre: 0,
      fat: 0.0,
      snf: null,
      clr: null,
      ratePerLitre: 0.0,
      totalAmount: 0.0,
      collectionDate: '',
      collectionSupplier: CollectionSupplierModel.empty(),
      steps: [],
      sampleCount: 0,
    );
  }
}

class CollectionSupplierModel extends CollectionSupplierEntity {
  const CollectionSupplierModel({
    required super.supplierName,
    required super.milkSupplierCode,
  });

  factory CollectionSupplierModel.fromJson(Map<String, dynamic> json) {
    return CollectionSupplierModel(
      supplierName: json['supplier_name'],
      milkSupplierCode: json['milk_supplier_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "supplier_name": supplierName,
      "milk_supplier_code": milkSupplierCode,
    };
  }

  factory CollectionSupplierModel.empty() {
    return const CollectionSupplierModel(
      supplierName: '',
      milkSupplierCode: '',
    );
  }
}

import 'package:dairysathi/features/invoices/domain/entities/invoice_details_collection_entity.dart';

class InvoiceDetailsCollectionModel extends InvoiceDetailsCollectionEntity {
  const InvoiceDetailsCollectionModel({
    required super.id,
    required super.supplierId,
    required super.dairyId,
    required super.shiftId,
    required super.milkTypeId,
    required super.collectionDate,
    required super.litre,
    required super.fat,
    required super.snf,
    required super.ratePerLitre,
    required super.totalAmount,
    required super.invoiceId,
    required super.createdAt,
    required super.updatedAt,
  });

  /// ✅ From JSON
  factory InvoiceDetailsCollectionModel.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailsCollectionModel(
      id: json['id'] ?? 0,
      supplierId: json['supplier_id'] ?? 0,
      dairyId: json['dairy_id'] ?? 0,
      shiftId: json['shift_id'] ?? 0,
      milkTypeId: json['milk_type_id'] ?? 0,
      collectionDate: json['collection_date'] ?? '',
      litre: (json['litre'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      snf: (json['snf'] ?? 0).toDouble(),
      ratePerLitre: (json['rate_per_litre'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      invoiceId: json['invoice_id']?.toString(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  /// ✅ To JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "supplier_id": supplierId,
      "dairy_id": dairyId,
      "shift_id": shiftId,
      "milk_type_id": milkTypeId,
      "collection_date": collectionDate,
      "litre": litre,
      "fat": fat,
      "snf": snf,
      "rate_per_litre": ratePerLitre,
      "total_amount": totalAmount,
      "invoice_id": invoiceId,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  /// ✅ Empty
  factory InvoiceDetailsCollectionModel.empty() {
    return const InvoiceDetailsCollectionModel(
      id: 0,
      supplierId: 0,
      dairyId: 0,
      shiftId: 0,
      milkTypeId: 0,
      collectionDate: '',
      litre: 0.0,
      fat: 0.0,
      snf: 0.0,
      ratePerLitre: 0.0,
      totalAmount: 0.0,
      invoiceId: null,
      createdAt: '',
      updatedAt: '',
    );
  }
}

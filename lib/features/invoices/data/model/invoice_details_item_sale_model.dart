import 'package:DairyVikas/features/invoices/domain/entities/invoice_details_item_sale_entity.dart';

class InvoiceDetailsItemSaleModel extends InvoiceDetailsItemSaleEntity {
  const InvoiceDetailsItemSaleModel({
    required super.id,
    required super.supplierId,
    required super.itemId,
    required super.itemName,
    required super.quantity,
    required super.sellingPrice,
    required super.totalAmount,
    required super.saleDate,
    required super.dairyId,
    required super.invoiceId,
    required super.createdAt,
    required super.updatedAt,
  });

  /// ✅ From JSON
  factory InvoiceDetailsItemSaleModel.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailsItemSaleModel(
      id: json['id'] ?? 0,
      supplierId: json['supplier_id'] ?? 0,
      itemId: json['item_id'] ?? 0,
      itemName: json['item_name'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      sellingPrice: (json['selling_price'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      saleDate: json['sale_date'] ?? '',
      dairyId: json['dairy_id'] ?? 0,
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
      "item_id": itemId,
      "item_name": itemName,
      "quantity": quantity,
      "selling_price": sellingPrice,
      "total_amount": totalAmount,
      "sale_date": saleDate,
      "dairy_id": dairyId,
      "invoice_id": invoiceId,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  /// ✅ Empty
  factory InvoiceDetailsItemSaleModel.empty() {
    return const InvoiceDetailsItemSaleModel(
      id: 0,
      supplierId: 0,
      itemId: 0,
      itemName: '',
      quantity: 0.0,
      sellingPrice: 0.0,
      totalAmount: 0.0,
      saleDate: '',
      dairyId: 0,
      invoiceId: null,
      createdAt: '',
      updatedAt: '',
    );
  }
}

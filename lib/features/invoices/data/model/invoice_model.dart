import '../../domain/entities/invoice_entity.dart';

class InvoiceModel extends InvoiceEntity {
  const InvoiceModel({
    required super.partyId,
    required super.partyType,
    required super.sourceRefId,
    required super.partyName,
    required super.milkCollectionAmount,
    required super.milkSaleAmount,
    required super.itemSaleAmount,
    required super.stockPurchaseAmount,
    required super.eligibleAmount,
    required super.totalAmount,
    required super.paidAmount,
    required super.pendingInvoiceAmount,
    required super.status,
    required super.invoiceId,
    required super.periodStart,
    required super.periodEnd,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      partyId: json['party_id'] ?? 0,
      partyType: json['party_type'] ?? '',
      sourceRefId: json['source_ref_id'] ?? 0,
      partyName: json['party_name'] ?? '',
      milkCollectionAmount: (json['milk_collection_amount'] ?? 0).toDouble(),
      milkSaleAmount: (json['milk_sale_amount'] ?? 0).toDouble(),
      itemSaleAmount: (json['item_sale_amount'] ?? 0).toDouble(),
      stockPurchaseAmount: (json['stock_purchase_amount'] ?? 0).toDouble(),
      eligibleAmount: (json['eligible_amount'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      paidAmount: (json['paid_amount'] ?? 0).toDouble(),
      pendingInvoiceAmount: (json['pending_invoice_amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      invoiceId: json['invoice_id'].toString(),
      periodStart: json['period_start'] ?? '',
      periodEnd: json['period_end'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "party_id": partyId,
      "party_type": partyType,
      "source_ref_id": sourceRefId,
      "party_name": partyName,
      "milk_collection_amount": milkCollectionAmount,
      "milk_sale_amount": milkSaleAmount,
      "item_sale_amount": itemSaleAmount,
      "stock_purchase_amount": stockPurchaseAmount,
      "eligible_amount": eligibleAmount,
      "total_invoiced": totalAmount,
      "total_paid": paidAmount,
      "pending_invoice_amount": pendingInvoiceAmount,
      "status": status,
    };
  }

  factory InvoiceModel.empty() {
    return InvoiceModel(
      partyId: 0,
      partyType: '',
      sourceRefId: 0,
      partyName: '',
      milkCollectionAmount: 0.0,
      milkSaleAmount: 0.0,
      itemSaleAmount: 0.0,
      stockPurchaseAmount: 0.0,
      eligibleAmount: 0.0,
      totalAmount: 0.0,
      paidAmount: 0.0,
      pendingInvoiceAmount: 0.0,
      status: '',
      invoiceId: '',
      periodStart: '',
      periodEnd: '',
    );
  }
}

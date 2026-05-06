class InvoiceDetailsItemSaleEntity {
  final int id;
  final int supplierId;
  final int itemId;
  final String itemName;
  final double quantity;
  final double sellingPrice;
  final double totalAmount;
  final String saleDate;
  final int dairyId;
  final String? invoiceId;
  final String createdAt;
  final String updatedAt;

  const InvoiceDetailsItemSaleEntity({
    required this.id,
    required this.supplierId,
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.sellingPrice,
    required this.totalAmount,
    required this.saleDate,
    required this.dairyId,
    required this.invoiceId,
    required this.createdAt,
    required this.updatedAt,
  });
}

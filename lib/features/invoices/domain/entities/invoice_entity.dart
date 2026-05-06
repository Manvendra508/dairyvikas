class InvoiceEntity {
  final String? invoiceId;
  final int partyId;
  final String partyType;
  final int sourceRefId;
  final String partyName;
  final double milkCollectionAmount;
  final double milkSaleAmount;
  final double itemSaleAmount;
  final double stockPurchaseAmount;
  final double eligibleAmount;
  final double totalAmount;
  final double paidAmount;
  final double pendingInvoiceAmount;
  final String status;
  final String periodStart;
  final String periodEnd;

  const InvoiceEntity({
    required this.partyId,
    required this.partyType,
    required this.sourceRefId,
    required this.partyName,
    required this.milkCollectionAmount,
    required this.milkSaleAmount,
    required this.itemSaleAmount,
    required this.stockPurchaseAmount,
    required this.eligibleAmount,
    required this.totalAmount,
    required this.paidAmount,
    required this.pendingInvoiceAmount,
    required this.status,
    required this.invoiceId,
    required this.periodStart,
    required this.periodEnd,
  });
}

class InvoiceDetailsCollectionEntity {
  final int id;
  final int supplierId;
  final int dairyId;
  final int shiftId;
  final int milkTypeId;
  final String collectionDate;
  final double litre;
  final double fat;
  final double snf;
  final double ratePerLitre;
  final double totalAmount;
  final String? invoiceId;
  final String createdAt;
  final String updatedAt;

  const InvoiceDetailsCollectionEntity({
    required this.id,
    required this.supplierId,
    required this.dairyId,
    required this.shiftId,
    required this.milkTypeId,
    required this.collectionDate,
    required this.litre,
    required this.fat,
    required this.snf,
    required this.ratePerLitre,
    required this.totalAmount,
    required this.invoiceId,
    required this.createdAt,
    required this.updatedAt,
  });
}

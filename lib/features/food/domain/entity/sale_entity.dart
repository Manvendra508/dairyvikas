class SaleEntity {
  final int id;
  final int dairyId;
  final int itemId;
  final int quantity;
  final double sellingPrice;
  final String saleDate;
  final int? buyerId;
  final int? supplierId;
  final String createdAt;
  final String updatedAt;
  final SaleItemDetailsEntity saleItemDetails;
  final SaleBuyerEntity? saleBuyer;
  final SaleSupplierEntity? saleSupplier;

  const SaleEntity({
    required this.id,
    required this.dairyId,
    required this.itemId,
    required this.quantity,
    required this.sellingPrice,
    required this.saleDate,
    this.buyerId,
    this.supplierId,
    required this.createdAt,
    required this.updatedAt,
    required this.saleItemDetails,
    this.saleBuyer,
    this.saleSupplier,
  });
}

class SaleItemDetailsEntity {
  final int id;
  final String itemName;

  const SaleItemDetailsEntity({required this.id, required this.itemName});
}

class SaleBuyerEntity {
  final int id;
  final String buyerName;
  final String buyerCode;

  const SaleBuyerEntity({
    required this.id,
    required this.buyerName,
    required this.buyerCode,
  });
}

class SaleSupplierEntity {
  final int id;
  final String supplierName;
  final String supplierCode;

  const SaleSupplierEntity({
    required this.id,
    required this.supplierName,
    required this.supplierCode,
  });
}

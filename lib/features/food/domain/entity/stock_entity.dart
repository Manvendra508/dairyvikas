class StockEntity {
  final int itemId;
  final String itemName;
  final String unit;
  final double sellingPrice;
  // final double purchasePrice;
  final String updatedAt;
  final int totalBought;
  final int totalSold;
  final int stockLeft;

  StockEntity({
    required this.itemId,
    required this.itemName,
    required this.unit,
    required this.sellingPrice,
    // required this.purchasePrice,
    required this.updatedAt,
    required this.totalBought,
    required this.totalSold,
    required this.stockLeft,
  });
}

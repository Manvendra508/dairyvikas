class StockHistoryEntity {
  final int stockId;
  final int itemId;
  final String itemName;
  final String purchaseDate;
  final double purchasedQuantity;
  final double remainingQuantity;
  final double purchasePrice;
  final double sellingPrice;
  final String unit;
  final int dealerId;

  const StockHistoryEntity({
    required this.stockId,
    required this.itemId,
    required this.itemName,
    required this.purchaseDate,
    required this.purchasedQuantity,
    required this.remainingQuantity,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.unit,
    required this.dealerId,
  });
}

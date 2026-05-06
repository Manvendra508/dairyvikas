import '../../domain/entity/stock_history_entity.dart';

class StockHistoryModel extends StockHistoryEntity {
  const StockHistoryModel({
    required super.stockId,
    required super.itemId,
    required super.itemName,
    required super.purchaseDate,
    required super.purchasedQuantity,
    required super.remainingQuantity,
    required super.purchasePrice,
    required super.sellingPrice,
    required super.unit,
    required super.dealerId,
  });

  /// From JSON
  factory StockHistoryModel.fromJson(Map<String, dynamic> json) {
    return StockHistoryModel(
      stockId: json['stock_id'] ?? 0,
      itemId: json['item_id'] ?? 0,
      itemName: json['item_name'] ?? '',
      purchaseDate: json['purchase_date'] ?? '',
      purchasedQuantity: (json['purchased_quantity'] ?? 0).toDouble(),
      remainingQuantity: (json['remaining_quantity'] ?? 0).toDouble(),
      purchasePrice: (json['purchase_price'] ?? 0).toDouble(),
      sellingPrice: (json['selling_price'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      dealerId: json['dealer_id'] ?? 0,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'stock_id': stockId,
      'item_id': itemId,
      'item_name': itemName,
      'purchase_date': purchaseDate,
      'purchased_quantity': purchasedQuantity,
      'remaining_quantity': remainingQuantity,
      'purchase_price': purchasePrice,
      'selling_price': sellingPrice,
      'unit': unit,
      'dealer_id': dealerId,
    };
  }

  /// Empty
  factory StockHistoryModel.empty() {
    return StockHistoryModel(
      stockId: 0,
      itemId: 0,
      itemName: '',
      purchaseDate: '',
      purchasedQuantity: 0,
      remainingQuantity: 0,
      purchasePrice: 0,
      sellingPrice: 0,
      unit: '',
      dealerId: 0,
    );
  }
}

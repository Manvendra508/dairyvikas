import 'package:DairyVikas/features/food/domain/entity/stock_entity.dart';

class StockModel extends StockEntity {
  StockModel({
    required super.itemId,
    required super.itemName,
    required super.unit,
    required super.sellingPrice,
    // required super.purchasePrice,
    required super.updatedAt,
    required super.totalBought,
    required super.totalSold,
    required super.stockLeft,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      itemId: json['item_id'] ?? 0,
      itemName: json['item_name'] ?? '',
      unit: json['unit'] ?? '',
      sellingPrice: double.parse(
        json['selling_price'] == null
            ? '0.0'
            : json['selling_price'].toString(),
      ),
      // purchasePrice: double.parse(
      //   json['purchase_price'] == null
      //       ? '0.0'
      //       : json['purchase_price'].toString(),
      // ),
      updatedAt: json['updatedAt'] ?? '',

      totalBought: json['total_bought'],
      totalSold: json['total_sold'],
      stockLeft: json['stock_left'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'item_name': itemName,
      'unit': unit,
      'selling_price': sellingPrice,
      // 'purchase_price': purchasePrice,
      'updatedAt': updatedAt,
      'total_bought': totalBought,
      'total_sold': totalSold,
      'stock_left': stockLeft,
    };
  }

  factory StockModel.empty() {
    return StockModel(
      itemId: 0,
      itemName: '',
      unit: '',
      sellingPrice: 0,
      // purchasePrice: 0,
      updatedAt: '',
      totalBought: 0,
      totalSold: 0,
      stockLeft: 0,
    );
  }
}

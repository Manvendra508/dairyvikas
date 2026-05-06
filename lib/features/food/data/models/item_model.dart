import '../../domain/entity/item_entity.dart';

class ItemModel extends ItemEntity {
  const ItemModel({
    required super.id,
    required super.itemName,
    required super.createdByVendorId,
    required super.isActive,
  });

  /// 🔁 From JSON
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] ?? 0,
      itemName: json['item_name'] ?? '',
      createdByVendorId: json['created_by_vendor_id'],
      isActive: json['is_active'] ?? false,
    );
  }

  /// 🔄 To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_name': itemName,
      'created_by_vendor_id': createdByVendorId,
      'is_active': isActive,
    };
  }

  /// 🧹 Empty Model
  factory ItemModel.empty() {
    return const ItemModel(
      id: 0,
      itemName: '',
      createdByVendorId: null,
      isActive: false,
    );
  }
}

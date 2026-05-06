class ItemEntity {
  final int id;
  final String itemName;
  final int? createdByVendorId;
  final bool isActive;

  const ItemEntity({
    required this.id,
    required this.itemName,
    required this.createdByVendorId,
    required this.isActive,
  });
}

class MilkSupplierEntity {
  final String id;
  final String dairyId;
  final String userId;
  final String milkSupplierCode;
  final String milkTypeId;
  final bool status;
  final String createdAt;
  final bool isDelete;
  final String supplierName;
  final String supplierMobile;
  final String milkTypeName;
  final String email;

  MilkSupplierEntity({
    required this.id,
    required this.dairyId,
    required this.userId,
    required this.milkSupplierCode,
    required this.milkTypeId,
    required this.status,
    required this.createdAt,
    required this.isDelete,
    required this.supplierName,
    required this.supplierMobile,
    required this.milkTypeName,
    required this.email,
  });
}

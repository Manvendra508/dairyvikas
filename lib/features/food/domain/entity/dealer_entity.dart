class DealerEntity {
  final int id;
  final int dairyId;
  final String dealerCode;
  final String mobile;
  final String dealerName;
  final String address;
  final String details;
  final bool status;
  final bool isDelete;
  final String createdAt;

  const DealerEntity({
    required this.id,
    required this.dairyId,
    required this.dealerCode,
    required this.mobile,
    required this.dealerName,
    required this.address,
    required this.details,
    required this.status,
    required this.isDelete,
    required this.createdAt,
  });
}

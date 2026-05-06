class MilkBuyerEntity {
  final int id;
  final int dairyId;
  final int userId;
  final String milkBuyerCode;
  final int milkTypeId;
  final bool status;
  final String createdAt;
  final bool isDelete;
  final String buyerName;
  final String buyerMobile;
  final String milkTypeName;
  final int cowMilkRateType;
  final int buffaloMilkRateType;
  final int? buffaloMilkRate;
  final int? cowMilkRate;

  MilkBuyerEntity({
    required this.id,
    required this.dairyId,
    required this.userId,
    required this.milkBuyerCode,
    required this.milkTypeId,
    required this.status,
    required this.createdAt,
    required this.isDelete,
    required this.buyerName,
    required this.buyerMobile,
    required this.milkTypeName,
    required this.cowMilkRateType,
    required this.buffaloMilkRateType,
    required this.buffaloMilkRate,
    required this.cowMilkRate,
  });
}

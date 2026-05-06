import '../../domain/entity/milk_buyer_entity.dart';

class MilkBuyerModel extends MilkBuyerEntity {
  MilkBuyerModel({
    required super.id,
    required super.dairyId,
    required super.userId,
    required super.milkBuyerCode,
    required super.milkTypeId,
    required super.status,
    required super.createdAt,
    required super.isDelete,
    required super.buyerName,
    required super.buyerMobile,
    required super.milkTypeName,
    required super.cowMilkRateType,
    required super.buffaloMilkRateType,
    required super.buffaloMilkRate,
    required super.cowMilkRate,
  });

  factory MilkBuyerModel.fromJson(Map<String, dynamic> json) {
    return MilkBuyerModel(
      id: json['id'],
      dairyId: json['dairy_id'],
      userId: json['user_id'],
      milkBuyerCode: json['milk_buyer_code'],
      milkTypeId: json['milk_type_id'],
      status: json['status'],
      createdAt: json['createdAt'],
      isDelete: json['is_delete'],
      buyerName: json['buyer_name'],
      buyerMobile: json['buyer_mobile'],
      milkTypeName: json['milk_type_name'],
      cowMilkRateType: json['cow_milk_Rate_type'],
      buffaloMilkRateType: json['buffalo_milk_rate_type'],
      buffaloMilkRate: json['buffalo_milk_rate'] ?? 0,
      cowMilkRate: json['cow_milk_rate'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dairy_id': dairyId,
      'user_id': userId,
      'milk_buyer_code': milkBuyerCode,
      'milk_type_id': milkTypeId,
      'status': status,
      'createdAt': createdAt,
      'is_delete': isDelete,
      'buyer_name': buyerName,
      'buyer_mobile': buyerMobile,
      'milk_type_name': milkTypeName,
    };
  }

  factory MilkBuyerModel.empty() {
    return MilkBuyerModel(
      id: 0,
      dairyId: 0,
      userId: 0,
      milkBuyerCode: '',
      milkTypeId: 0,
      status: false,
      createdAt: '',
      isDelete: false,
      buyerName: '',
      buyerMobile: '',
      milkTypeName: '',
      cowMilkRateType: 0,
      buffaloMilkRateType: 0,
      buffaloMilkRate: 0,
      cowMilkRate: 0,
    );
  }
}

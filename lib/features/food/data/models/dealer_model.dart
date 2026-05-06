import '../../domain/entity/dealer_entity.dart';

class DealerModel extends DealerEntity {
  const DealerModel({
    required super.id,
    required super.dairyId,
    required super.dealerCode,
    required super.mobile,
    required super.dealerName,
    required super.address,
    required super.details,
    required super.status,
    required super.isDelete,
    required super.createdAt,
  });

  /// 🔹 From JSON
  factory DealerModel.fromJson(Map<String, dynamic> json) {
    return DealerModel(
      id: json['id'] ?? 0,
      dairyId: json['dairy_id'] ?? 0,
      dealerCode: json['dealer_code'] ?? '',
      mobile: json['mobile'] ?? '',
      dealerName: json['dealer_name'] ?? '',
      address: json['address'] ?? '',
      details: json['details'] ?? '',
      status: json['status'] ?? false,
      isDelete: json['is_delete'] ?? false,
      createdAt: json['createdAt'],
    );
  }

  /// 🔹 To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dairy_id': dairyId,
      'dealer_code': dealerCode,
      'mobile': mobile,
      'dealer_name': dealerName,
      'address': address,
      'details': details,
      'status': status,
      'is_delete': isDelete,
      'createdAt': createdAt,
    };
  }

  /// 🔹 Empty / Default
  factory DealerModel.empty() {
    return DealerModel(
      id: 0,
      dairyId: 0,
      dealerCode: '',
      mobile: '',
      dealerName: '',
      address: '',
      details: '',
      status: false,
      isDelete: false,
      createdAt: '',
    );
  }
}

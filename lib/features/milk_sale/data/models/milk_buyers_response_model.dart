import '../../domain/entity/milk_buyers_response_entity.dart';
import 'milk_buyer_model.dart';

class MilkBuyerResponseModel extends MilkBuyerResponseEntity {
  MilkBuyerResponseModel({
    required super.success,
    required super.message,
    required super.buyers,
    required super.totalCount,
    required super.deletedCount,
    required super.activeCount,
    required super.inactiveCount,
  });

  factory MilkBuyerResponseModel.fromJson(Map<String, dynamic> json) {
    final buyersJson = json['buyers'] as List? ?? [];

    return MilkBuyerResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      buyers: buyersJson.map((e) => MilkBuyerModel.fromJson(e)).toList(),
      totalCount: json['totalCount'] ?? 0,
      deletedCount: json['deletedCount'] ?? 0,
      activeCount: json['activeCount'] ?? 0,
      inactiveCount: json['inactiveCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'buyers': buyers.map((e) => (e).toJson()).toList(),
        'totalCount': totalCount,
        'deletedCount': deletedCount,
        'activeCount': activeCount,
        'inactiveCount': inactiveCount,
      },
    };
  }

  /// 🔹 Empty method
  factory MilkBuyerResponseModel.empty() {
    return MilkBuyerResponseModel(
      success: false,
      message: '',
      buyers: [],
      totalCount: 0,
      deletedCount: 0,
      activeCount: 0,
      inactiveCount: 0,
    );
  }
}

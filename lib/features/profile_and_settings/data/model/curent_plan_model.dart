import 'dart:convert';

import '../../domain/entities/current_plan_entity.dart';

class CurrentPlanModel extends CurrentPlanEntity {
  const CurrentPlanModel({
    required super.id,
    required super.name,
    required super.price,
    required super.validityDays,
    required super.meta,
    required super.startDate,
    required super.endDate,
    required super.remainingDays,
    required super.status,
  });

  /// FROM JSON
  factory CurrentPlanModel.fromJson(Map json) {
    return CurrentPlanModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      validityDays: json['validity_days'] ?? 0,
      meta: _parseMeta(json['meta']),
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      remainingDays: json['remaining_days'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "validity_days": validityDays,
      "meta": jsonEncode(meta),
      "start_date": startDate,
      "end_date": endDate,
      "remaining_days": remainingDays,
      "status": status,
    };
  }

  /// EMPTY
  factory CurrentPlanModel.empty() {
    return const CurrentPlanModel(
      id: 0,
      name: '',
      price: 0,
      validityDays: 0,
      meta: {},
      startDate: '',
      endDate: '',
      remainingDays: 0,
      status: '',
    );
  }

  /// 🔥 Meta Parser (Important)
  static Map<String, dynamic> _parseMeta(dynamic meta) {
    if (meta == null) return {};

    if (meta is String) {
      try {
        return jsonDecode(meta);
      } catch (e) {
        return {};
      }
    }

    if (meta is Map) {
      return Map<String, dynamic>.from(meta);
    }

    return {};
  }
}

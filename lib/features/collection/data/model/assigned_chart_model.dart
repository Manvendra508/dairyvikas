import 'package:DairyVikas/features/collection/domain/entities/assigned_chart_entity.dart';

import '../../../rate_cart/data/model/rate_chart_values_model.dart';

class AssignChartModel extends AssignChartEntity {
  AssignChartModel({
    required super.id,
    required super.milkTypeId,
    required super.chartType,
    required super.name,
    required super.effectiveFrom,
    required super.rateChartCategoryId,
    required super.isEnabled,
    required super.rateChartValues,
  });

  /// ---------- FROM JSON ----------
  factory AssignChartModel.fromJson(Map<String, dynamic> json) {
    return AssignChartModel(
      id: json['id'] ?? 0,
      milkTypeId: json['milk_type_id'] ?? 0,
      chartType: json['chart_type'] ?? 0,
      name: json['name'] ?? '',
      effectiveFrom: json['effective_from'] ?? '',
      rateChartCategoryId: json['rate_chart_category_id'] ?? 0,
      isEnabled: json['is_enabled'] ?? false,
      rateChartValues: (json['rate_chart_values'] as List<dynamic>? ?? [])
          .map((e) => RateChartValuesModel.fromJson(e))
          .toList(),
    );
  }

  /// ---------- TO JSON ----------
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "milk_type_id": milkTypeId,
      "chart_type": chartType,
      "name": name,
      "effective_from": effectiveFrom,
      "rate_chart_category_id": rateChartCategoryId,
      "is_enabled": isEnabled,
      "rate_chart_values": rateChartValues.map((e) => e.toJson()).toList(),
    };
  }

  /// ---------- EMPTY ----------
  factory AssignChartModel.empty() {
    return AssignChartModel(
      id: 0,
      milkTypeId: 0,
      chartType: 0,
      name: '',
      effectiveFrom: '',
      rateChartCategoryId: 0,
      isEnabled: false,
      rateChartValues: [],
    );
  }
}

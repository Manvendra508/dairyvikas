import 'package:DairyVikas/features/rate_cart/domain/entities/rate_chart_entity.dart';

import 'rate_chart_values_model.dart';

class RateChartModel extends RateChartEntity {
  RateChartModel({
    required super.id,
    required super.vendorId,
    required super.milkTypeId,
    required super.chartType,
    required super.name,
    required super.effectiveFrom,
    required super.baseAmount,
    required super.clrIncreamentPoint,
    required super.chartFormat,
    required super.rateChartCategoryId,
    required super.isEnabled,
    required super.rateChartValues,
    required super.steps,
    required super.isAssigned,
    required super.supplierCount,
    required super.dairyCount,
    required super.buyerCount,
  });

  factory RateChartModel.fromJson(Map<String, dynamic> json) {
    return RateChartModel(
      id: json['id'] ?? 0,
      vendorId: json['vendor_id'] ?? 0,
      milkTypeId: json['milk_type_id'] ?? 0,
      chartType: json['chart_type'] ?? 0,
      name: json['name'] ?? '',
      effectiveFrom: json['effective_from'] ?? '',
      baseAmount: json['base_amount'] == null
          ? 0.0
          : double.parse(json['base_amount'].toString()),
      clrIncreamentPoint: json['clr_increament_point'] == null
          ? 1.0
          : double.parse(json['clr_increament_point'].toString()),
      chartFormat: json['chart_format'] ?? '',
      rateChartCategoryId: json['rate_chart_category_id'] ?? 0,
      isEnabled: json['is_enabled'] ?? false,
      isAssigned: json['is_assigned'] ?? 0,
      supplierCount: json['supplier_count'] ?? 0,
      buyerCount: json['buyer_count'] ?? 0,
      dairyCount: json['dairy_count'] ?? 0,
      rateChartValues: json['rate_chart_values'] == null
          ? <RateChartValuesModel>[]
          : (json['rate_chart_values'] as List)
                .map<RateChartValuesModel>(
                  (e) => RateChartValuesModel.fromJson(e),
                )
                .toList(),
      steps: json['steps'] ?? '',
    );
  }

  factory RateChartModel.empty() {
    return RateChartModel(
      id: 0,
      vendorId: 0,
      milkTypeId: 0,
      chartType: 0,
      name: '',
      effectiveFrom: '',
      baseAmount: 0.0,
      clrIncreamentPoint: 0.0,
      chartFormat: '',
      rateChartCategoryId: 0,
      isEnabled: false,
      steps: '',
      rateChartValues: <RateChartValuesModel>[],
      isAssigned: 0,
      supplierCount: 0,
      dairyCount: 0,
      buyerCount: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor_id': vendorId,
      'milk_type_id': milkTypeId,
      'chart_type': chartType,
      'name': name,
      'effective_from': effectiveFrom,
      'base_amount': baseAmount,
      'clr_increament_point': clrIncreamentPoint,
      'chart_format': chartFormat,
      'rate_chart_category_id': rateChartCategoryId,
      'is_enabled': isEnabled,
      "steps": steps,
      "is_assigned": isAssigned,
      "dairy_count": 0,
      "supplier_count": 0,
      'rate_chart_values': rateChartValues.map((e) => (e).toJson()).toList(),
      'buyer_count': 0,
    };
  }
}

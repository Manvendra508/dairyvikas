import 'package:DairyVikas/features/rate_cart/domain/entities/rate_chart_value_entity.dart';

class RateChartValuesModel extends RateChartValueEntity {
  RateChartValuesModel({
    required super.id,
    required super.rateChartId,
    required super.price,
    required super.orderIndex,
    super.bonus,
    super.fat,
    super.clr,
    super.snf,
    super.penalty,
  });

  factory RateChartValuesModel.fromJson(Map<String, dynamic> json) {
    return RateChartValuesModel(
      id: json['id'] ?? 0,
      rateChartId: json['rate_chart_id'] ?? 0,
      price: json['price'] == null
          ? 0.0
          : double.parse((json['price'].toString())),
      orderIndex: json['order_index'] ?? 0,
      bonus: json['bonus'] != null
          ? double.parse((json['bonus'].toString()))
          : null,
      fat: json['fat'] != null ? double.parse((json['fat'].toString())) : null,
      clr: json['clr'] != null ? double.parse((json['clr'].toString())) : null,
      snf: json['snf'] != null ? double.parse((json['snf'].toString())) : null,
      penalty: json['penalty'] != null
          ? double.parse((json['penalty'].toString()))
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rate_chart_id': rateChartId,
      'price': price,
      'order_index': orderIndex,
      'bonus': bonus,
      'fat': fat,
      'clr': clr,
      'snf': snf,
      'penalty': penalty,
    };
  }
}

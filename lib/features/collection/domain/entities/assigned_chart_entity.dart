import '../../../rate_cart/data/model/rate_chart_values_model.dart';

class AssignChartEntity {
  final int id;

  final int milkTypeId;
  final int chartType;
  final String name;
  final String effectiveFrom;

  final int rateChartCategoryId;
  final bool isEnabled;

  final List<RateChartValuesModel> rateChartValues;

  AssignChartEntity({
    required this.id,

    required this.milkTypeId,
    required this.chartType,
    required this.name,
    required this.effectiveFrom,

    required this.rateChartCategoryId,
    required this.isEnabled,
    required this.rateChartValues,
  });
}

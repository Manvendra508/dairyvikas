import '../../data/model/rate_chart_values_model.dart'
    show RateChartValuesModel;

class RateChartEntity {
  final int id;
  final int vendorId;
  final int milkTypeId;
  final int chartType;
  final String name;
  final String effectiveFrom;
  final double baseAmount;
  final double clrIncreamentPoint;
  final String chartFormat;
  final int rateChartCategoryId;
  final bool isEnabled;
  final int supplierCount;
  final int buyerCount;
  final int isAssigned;
  final int dairyCount;
  final String steps;
  final List<RateChartValuesModel> rateChartValues;

  RateChartEntity({
    required this.id,
    required this.vendorId,
    required this.milkTypeId,
    required this.chartType,
    required this.name,
    required this.effectiveFrom,
    required this.baseAmount,
    required this.clrIncreamentPoint,
    required this.chartFormat,
    required this.rateChartCategoryId,
    required this.isEnabled,
    required this.rateChartValues,
    required this.steps,
    required this.isAssigned,
    required this.supplierCount,
    required this.dairyCount,
    required this.buyerCount,
  });
}

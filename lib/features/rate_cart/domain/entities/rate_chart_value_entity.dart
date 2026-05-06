class RateChartValueEntity {
  final int id;
  final int rateChartId;
  double? fat;
  double? clr;
  double? snf;
  double? bonus;
  double? penalty;
  final double price;
  final int orderIndex;
  RateChartValueEntity({
    required this.id,
    required this.rateChartId,
    this.fat,
    this.clr,
    this.snf,
    this.bonus,
    this.penalty,
    required this.price,
    required this.orderIndex,
  });
}

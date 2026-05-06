class AssignmentEntity {
  final int? dairyId;
  final int? supplierId;
  final int? buyerId;
  final int rateChartId;

  const AssignmentEntity({
    required this.dairyId,
    required this.supplierId,
    required this.rateChartId,
    required this.buyerId,
  });

  factory AssignmentEntity.empty() {
    return const AssignmentEntity(
      dairyId: null,
      supplierId: null,
      rateChartId: 0,
      buyerId: null,
    );
  }
}

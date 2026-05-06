class CurrentPlanEntity {
  final int id;
  final String name;
  final double price;
  final int validityDays;
  final Map<String, dynamic> meta;
  final String startDate;
  final String endDate;
  final int remainingDays;
  final String status;

  const CurrentPlanEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.validityDays,
    required this.meta,
    required this.startDate,
    required this.endDate,
    required this.remainingDays,
    required this.status,
  });

  factory CurrentPlanEntity.empty() {
    return const CurrentPlanEntity(
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
}

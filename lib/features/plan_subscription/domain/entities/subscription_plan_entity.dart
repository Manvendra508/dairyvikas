class SubscriptionPlanEntity {
  final int id;
  final String name;
  final Map<String, String> description;
  final int validityDays;
  final double price;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, String> metaData;
  final bool isBestValue;

  SubscriptionPlanEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.validityDays,
    required this.price,
    required this.metaData,
    required this.isActive,
    required this.isBestValue,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 🔥 Empty factory
  factory SubscriptionPlanEntity.empty() {
    return SubscriptionPlanEntity(
      id: 0,
      name: '',
      description: {},
      validityDays: 0,
      price: 0.0,
      metaData: {},
      isActive: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isBestValue: false,
    );
  }
}

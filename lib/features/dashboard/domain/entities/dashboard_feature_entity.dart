class DashboardFeatureEntity {
  final String id;
  final String featureName;
  final String icon;
  final bool isActive;

  DashboardFeatureEntity({
    required this.featureName,
    required this.icon,
    required this.isActive,
    required this.id,
  });
}

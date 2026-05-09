import 'package:DairyVikas/features/dashboard/data/model/dashboard_feature_model.dart';

class DashboardSectionEntity {
  final String id;
  final String featureCategory;
  final List<DashboardFeatureModel> features;

  DashboardSectionEntity({
    required this.featureCategory,
    required this.features,
    required this.id,
  });
}

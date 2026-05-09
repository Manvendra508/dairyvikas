import 'package:DairyVikas/features/dashboard/domain/entities/dashboard_feature_entity.dart';

class DashboardFeatureModel extends DashboardFeatureEntity {
  DashboardFeatureModel({
    required super.featureName,
    required super.icon,
    required super.isActive,
    required super.id,
  });

  factory DashboardFeatureModel.fromJson(Map<String, dynamic> json) {
    return DashboardFeatureModel(
      featureName: json['feature_name'].toString(),
      icon: json['icon'].toString(),
      id: json['id'].toString(),
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "feature_name": featureName,
      "icon": icon,
      "id": id.toString(),
      "is_active": isActive,
    };
  }
}

import 'package:dairysathi/features/dashboard/domain/entities/dashboard_section_entity.dart';

import 'dashboard_feature_model.dart';

class DashbaordSectionModel extends DashboardSectionEntity {
  DashbaordSectionModel({
    required super.featureCategory,
    required super.features,
    required super.id,
  });

  factory DashbaordSectionModel.fromJson(Map<String, dynamic> json) {
    return DashbaordSectionModel(
      featureCategory: json['section_category'] ?? '',

      id: json['id'].toString(),
      features: (json['sections'] as List<dynamic>? ?? [])
          .map((e) => DashboardFeatureModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section_category': featureCategory,
      'id': id,
      'sections': features.map((e) => e.toJson()).toList(),
    };
  }
}

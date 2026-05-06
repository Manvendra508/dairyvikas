import 'package:dairysathi/features/auth/registration_flow/data/model/dairy_model.dart';
import 'package:dairysathi/features/dashboard/data/model/dashbaord_section_model.dart';
import 'package:dairysathi/features/dashboard/domain/entities/dashboard_data_entity.dart';

class DashboardDataModel extends DashboardDataEntity {
  DashboardDataModel({
    required super.sections,
    required super.daysLeftInFreeTrial,
    required super.dairy,
  });
  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      daysLeftInFreeTrial: json['daysleft'].toString(),
      dairy: json['dairy_data'] == null
          ? DairyModel.empty()
          : DairyModel.fromJson(json['dairy_data']),

      sections: (json['featuresByCategory'] as List<dynamic>? ?? [])
          .map((e) => DashbaordSectionModel.fromJson(e))
          .toList(),
    );
  }

  factory DashboardDataModel.empty() {
    return DashboardDataModel(
      sections: [],
      daysLeftInFreeTrial: '0',
      dairy: DairyModel.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daysleft': daysLeftInFreeTrial,
      'featuresByCategoryMapped': sections.map((e) => e.toJson()).toList(),
      "dairy_data": dairy == null
          ? DairyModel.empty().toJson()
          : dairy!.toJson(),
    };
  }
}

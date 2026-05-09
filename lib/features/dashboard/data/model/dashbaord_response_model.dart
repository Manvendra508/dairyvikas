import 'package:DairyVikas/features/dashboard/data/model/dashboard_data_model.dart';
import 'package:DairyVikas/features/dashboard/domain/entities/dashboard_response_entity.dart';

class DashbaordResponseModel extends DashboardResponseEntity {
  DashbaordResponseModel({
    required super.success,
    required super.message,
    required super.dashboardDataModel,
  });

  factory DashbaordResponseModel.fromJson(Map<String, dynamic> json) {
    return DashbaordResponseModel(
      success: json['success'],
      message: json['message'],
      dashboardDataModel: DashboardDataModel.fromJson(json['data']),
    );
  }

  factory DashbaordResponseModel.empty() {
    return DashbaordResponseModel(
      success: false,
      message: '',
      dashboardDataModel: DashboardDataModel.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "messaage": message,
      "data": dashboardDataModel.toJson(),
    };
  }
}

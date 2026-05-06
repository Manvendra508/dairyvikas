import 'package:dairysathi/features/dashboard/data/model/dashboard_data_model.dart';

class DashboardResponseEntity {
  final bool success;
  final String message;
  final DashboardDataModel dashboardDataModel;

  DashboardResponseEntity({
    required this.success,
    required this.message,
    required this.dashboardDataModel,
  });
}

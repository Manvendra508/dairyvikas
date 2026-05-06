import 'package:dairysathi/features/dashboard/domain/entities/dashboard_response_entity.dart';

abstract class DashboardDataRepo {
  Future<DashboardResponseEntity> fetchDashboardData(String dairyId);
}

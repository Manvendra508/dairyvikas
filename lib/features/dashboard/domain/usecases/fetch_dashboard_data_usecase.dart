import 'package:dairysathi/features/dashboard/domain/entities/dashboard_response_entity.dart';
import 'package:dairysathi/features/dashboard/domain/repository/dashboard_data_repo.dart';

class FetchDashboardDataUsecase {
  final DashboardDataRepo dashboardDataRepo;

  FetchDashboardDataUsecase(this.dashboardDataRepo);

  Future<DashboardResponseEntity> call(String dairyId) {
    return dashboardDataRepo.fetchDashboardData(dairyId);
  }
}

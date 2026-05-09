import 'package:DairyVikas/features/dashboard/data/model/dashbaord_response_model.dart';
import 'package:DairyVikas/features/dashboard/domain/repository/dashboard_data_repo.dart';

class FetchDashboardDataUsecase {
  final DashboardDataRepo dashboardDataRepo;

  FetchDashboardDataUsecase(this.dashboardDataRepo);

  Future<DashbaordResponseModel> call(String dairyId) {
    return dashboardDataRepo.fetchDashboardData(dairyId);
  }
}

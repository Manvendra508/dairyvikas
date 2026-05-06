import 'package:dairysathi/features/dashboard/data/datasources/dashboard_data_ds.dart';
import 'package:dairysathi/features/dashboard/domain/entities/dashboard_response_entity.dart';
import 'package:dairysathi/features/dashboard/domain/repository/dashboard_data_repo.dart';

class DashboardDataRepoImpl implements DashboardDataRepo {
  final DashboardRemoteDataSource dashboardRemoteDataSource;

  DashboardDataRepoImpl(this.dashboardRemoteDataSource);
  @override
  Future<DashboardResponseEntity> fetchDashboardData(String dairyId) {
    return dashboardRemoteDataSource.getDashboardData(dairyId);
  }
}

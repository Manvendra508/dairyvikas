import 'package:DairyVikas/features/dashboard/data/datasources/dashboard_data_ds.dart';
import 'package:DairyVikas/features/dashboard/data/model/dashbaord_response_model.dart'
    show DashbaordResponseModel;
import 'package:DairyVikas/features/dashboard/domain/repository/dashboard_data_repo.dart';

class DashboardDataRepoImpl implements DashboardDataRepo {
  final DashboardRemoteDataSource dashboardRemoteDataSource;

  DashboardDataRepoImpl(this.dashboardRemoteDataSource);
  @override
  Future<DashbaordResponseModel> fetchDashboardData(String dairyId) {
    return dashboardRemoteDataSource.getDashboardData(dairyId);
  }
}

import '../../data/model/dashbaord_response_model.dart';

abstract class DashboardDataRepo {
  Future<DashbaordResponseModel> fetchDashboardData(String dairyId);
}

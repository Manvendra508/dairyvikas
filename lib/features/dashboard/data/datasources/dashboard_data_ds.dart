import 'package:DairyVikas/core/network/api_endpoints.dart';
import 'package:DairyVikas/features/dashboard/data/model/dashbaord_response_model.dart';
import 'package:dio/dio.dart';

class DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSource(this.dio);

  Future<DashbaordResponseModel> getDashboardData(String dairyId) async {
    final response = await dio.get(
      ApiEndpoints.dashboardData,
      data: {'dairy_id': dairyId},
    );
    return DashbaordResponseModel.fromJson(response.data);
  }
}

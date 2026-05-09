import 'package:DairyVikas/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';

class AppSettingDs {
  final Dio dio;

  AppSettingDs(this.dio);

  Future<Map> getExistingDairysettings(String dairyId) async {
    final response = await dio.get(
      '${ApiEndpoints.getExistingDairySetting}?dairy_id=$dairyId',
    );
    return response.data;
  }

  Future<Map> getCurrentPlan() async {
    final response = await dio.get(ApiEndpoints.getCurrentPlan);
    return response.data;
  }

  Future<Map> updateVendorName(String name) async {
    final response = await dio.post(
      ApiEndpoints.updateVendorName,
      data: {"name": name},
    );
    return response.data;
  }

  Future<Map> updateDairySetting(Map params) async {
    final response = await dio.post(
      ApiEndpoints.updateDairySetting,
      data: params,
    );
    return response.data;
  }
}

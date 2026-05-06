import 'dart:convert';

import 'package:dairysathi/core/network/api_endpoints.dart';
import 'package:dio/dio.dart' as fd;
import 'package:dio/dio.dart';

class RateChartDataSource {
  final Dio dio;

  RateChartDataSource(this.dio);

  Future<Map> addChart(Map chartData) async {
    final response = await dio.post(
      ApiEndpoints.addNewRateChart,
      data: jsonEncode(chartData),
    );
    return response.data;
  }

  Future<Map> updateChart(Map chartData) async {
    final response = await dio.post(
      ApiEndpoints.updateNewRateChart,
      data: jsonEncode(chartData),
    );
    return response.data;
  }

  Future<Map> getAllRateCharts() async {
    final response = await dio.get(ApiEndpoints.getAllRateCharts);
    return response.data;
  }

  Future<Map> getRateChartDetails(String chartId) async {
    final response = await dio.get(
      '${ApiEndpoints.getRateChartsDetails}?chart_id=$chartId',
    );
    return response.data;
  }

  Future<Map> assignChartToDairy(Map params) async {
    final response = await dio.post(
      ApiEndpoints.assignRateChartsToDairy,
      data: params,
    );
    return response.data;
  }

  Future<Map> deleteRateChart(String chartId) async {
    final response = await dio.delete(
      '${ApiEndpoints.deleteRateChart}/$chartId',
    );
    return response.data;
  }

  Future<Map> uploadExcel(fd.FormData formdata) async {
    final response = await dio.post(
      ApiEndpoints.uploadExcel,
      data: formdata,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    return response.data;
  }

  Future<Map> getAllAssignableSuppliers(
    String chartId,
    String customerType,
  ) async {
    final response = await dio.get(
      '${ApiEndpoints.getAllAssignableSuppliers}?chart_id=$chartId&target=$customerType',
    );
    return response.data;
  }

  Future<Map> assignChartToSuppliers(Map params) async {
    final response = await dio.post(
      ApiEndpoints.assignRateChartsToDairy,
      data: params,
    );
    return response.data;
  }

  Future<Map> unassignChartToDairy(Map params) async {
    final response = await dio.post(
      ApiEndpoints.unassignRateChart,
      data: params,
    );
    return response.data;
  }

  Future<Map> unassignChartToSuppliers(Map params) async {
    final response = await dio.post(
      ApiEndpoints.unassignRateChart,
      data: params,
    );
    return response.data;
  }

  Future<Map> changeStatusOfRateChart(Map params) async {
    final response = await dio.post(
      ApiEndpoints.changeRatechartStatus,
      data: params,
    );
    return response.data;
  }
}

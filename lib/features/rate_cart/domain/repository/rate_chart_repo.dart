import 'package:dio/dio.dart';

abstract class RateChartRepo {
  Future<Map> addChart(Map chartData);
  Future<Map> updateChart(Map chartData);
  Future<Map> getAllRateCharts();
  Future<Map> getChartDetails(String chartId);
  Future<Map> assignChartToDairy(Map params);
  Future<Map> assignChartToSuppliers(Map params);
  Future<Map> deleteRateChart(String chartId);
  Future<Map> uploadExcel(FormData formdata);
  Future<Map> getAllAssignableSuppliers(String chartId, String customerType);
  Future<Map> unassignChartToDairy(Map params);
  Future<Map> unassignChartToSupppliers(Map params);
  Future<Map> changeStatusOfRateChart(Map params);
}

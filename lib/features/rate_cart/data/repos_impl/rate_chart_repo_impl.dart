import 'package:DairyVikas/features/rate_cart/data/datasources/rate_chart_ds.dart';
import 'package:DairyVikas/features/rate_cart/domain/repository/rate_chart_repo.dart';
import 'package:dio/dio.dart' as fd;

class RateChartRepoImpl implements RateChartRepo {
  final RateChartDataSource rateChartDataSource;

  RateChartRepoImpl(this.rateChartDataSource);
  @override
  Future<Map> addChart(Map chartData) {
    return rateChartDataSource.addChart(chartData);
  }

  @override
  Future<Map> updateChart(Map chartData) {
    return rateChartDataSource.updateChart(chartData);
  }

  @override
  Future<Map> getAllRateCharts() async {
    return rateChartDataSource.getAllRateCharts();
  }

  @override
  Future<Map> getChartDetails(String chartId) {
    return rateChartDataSource.getRateChartDetails(chartId);
  }

  @override
  Future<Map> assignChartToDairy(Map params) async {
    return rateChartDataSource.assignChartToDairy(params);
  }

  @override
  Future<Map> deleteRateChart(String chartId) {
    return rateChartDataSource.deleteRateChart(chartId);
  }

  @override
  Future<Map> uploadExcel(fd.FormData formdata) async {
    return rateChartDataSource.uploadExcel(formdata);
  }

  @override
  Future<Map> getAllAssignableSuppliers(
    String chartId,
    String customerType,
  ) async {
    return rateChartDataSource.getAllAssignableSuppliers(chartId, customerType);
  }

  @override
  Future<Map> assignChartToSuppliers(Map params) {
    return rateChartDataSource.assignChartToSuppliers(params);
  }

  @override
  Future<Map> unassignChartToDairy(Map params) {
    return rateChartDataSource.unassignChartToDairy(params);
  }

  @override
  Future<Map> unassignChartToSupppliers(Map params) {
    return rateChartDataSource.unassignChartToSuppliers(params);
  }

  @override
  Future<Map> changeStatusOfRateChart(Map params) {
    return rateChartDataSource.changeStatusOfRateChart(params);
  }
}

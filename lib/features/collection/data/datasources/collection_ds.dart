import 'package:dairysathi/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';

class CollectionDataSource {
  final Dio dio;

  CollectionDataSource(this.dio);

  Future<Map> getAllAssignedRatecharts() async {
    final response = await dio.get(ApiEndpoints.getAllAssignedRateCharts);
    return response.data;
  }

  Future<Map> addNewCollection(Map params) async {
    final response = await dio.post(ApiEndpoints.addCollection, data: params);
    return response.data;
  }

  Future<Map> deleteCollection(String collectionId) async {
    final response = await dio.delete(
      '${ApiEndpoints.deleteCollection}/$collectionId',
    );
    return response.data;
  }

  Future<Map> updateCollection(Map params) async {
    final response = await dio.post(
      ApiEndpoints.updateCollection,
      data: params,
    );
    return response.data;
  }

  Future<Map> getAllCollection(String dairyid, String date) async {
    final response = await dio.get(
      '${ApiEndpoints.getAllCollection}?dairy_id=$dairyid&date=$date',
    );
    return response.data;
  }

  Future<Map> getSupplierCollectionForAdustment(
    String supplierId,
    String startDate,
    String endDate,
  ) async {
    final response = await dio.get(
      '${ApiEndpoints.getCollectionsForAdjustment}?supplier_id=$supplierId&startDate=$startDate&endDate=$endDate',
    );
    return response.data;
  }

  Future<Map> getDateRange() async {
    final response = await dio.get(ApiEndpoints.getDateRange);
    return response.data;
  }
}

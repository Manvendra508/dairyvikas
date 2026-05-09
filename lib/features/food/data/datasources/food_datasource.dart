import 'package:DairyVikas/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';

class FoodDatasource {
  final Dio dio;

  FoodDatasource(this.dio);

  // Future<Map> getAllAssignedRatecharts() async {
  //   final response = await dio.get(ApiEndpoints.getAllAssignedRateCharts);
  //   return response.data;
  // }

  Future<Map> addFoodDealer(Map params) async {
    final response = await dio.post(
      ApiEndpoints.addNewFoodDealer,
      data: params,
    );
    return response.data;
  }

  Future<Map> updateFoodDealer(Map params) async {
    final response = await dio.post(
      ApiEndpoints.updateFoodDealer,
      data: params,
    );
    return response.data;
  }

  Future<Map> getFoodDealers(String dairyid) async {
    final response = await dio.get(
      '${ApiEndpoints.getFoodDealers}?dairy_id=$dairyid',
    );
    return response.data;
  }

  Future<Map> getAllItems() async {
    final response = await dio.get(ApiEndpoints.getAllItems);
    return response.data;
  }

  Future<Map> addNewItem(String itemName) async {
    final response = await dio.post(
      ApiEndpoints.addNewItem,
      data: {"item_name": itemName},
    );
    return response.data;
  }

  Future<Map> updateItem(String itemName, int itemId) async {
    final response = await dio.post(
      ApiEndpoints.updateItem,
      data: {"item_id": itemId, "item_name": itemName},
    );
    return response.data;
  }

  Future<Map> addFoodStock(Map params) async {
    final response = await dio.post(ApiEndpoints.addNewStock, data: params);
    return response.data;
  }

  Future<Map> updateFoodStock(Map params) async {
    final response = await dio.post(ApiEndpoints.updateStock, data: params);
    return response.data;
  }

  Future<Map> getFoodStock(String dairyid) async {
    final response = await dio.get(
      '${ApiEndpoints.getAllStock}?dairy_id=$dairyid',
    );
    return response.data;
  }

  Future<Map> addFoodSale(Map params) async {
    final response = await dio.post(ApiEndpoints.addFoodSale, data: params);
    return response.data;
  }

  Future<Map> getStockHistory(
    String dairyId,
    String startDate,
    String endDate,
    String itemId,
  ) async {
    final response = await dio.get(
      '${ApiEndpoints.getStockHistory}?dairy_id=$dairyId&start_date=$startDate&end_date=$endDate&item_id=$itemId',
    );
    return response.data;
  }

  Future<Map> getFoodSales(Map params) async {
    final response = await dio.get(
      '${ApiEndpoints.foodSales}?dairy_id=${params['dairy_id']}&start_date=${params['start_date']}&end_date=${params['end_date']}&limit=${params['limit']}',
    );
    return response.data;
  }

  Future<Map> updateFoodSale(Map params) async {
    final response = await dio.post(ApiEndpoints.updateFoodSale, data: params);
    return response.data;
  }

  Future<Map> getUnits() async {
    final response = await dio.get(ApiEndpoints.getUnits);
    return response.data;
  }
}

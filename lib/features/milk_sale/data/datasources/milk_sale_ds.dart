import 'dart:convert';

import 'package:DairyVikas/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';

class MilkSaleDataSource {
  final Dio dio;

  MilkSaleDataSource(this.dio);

  Future<Map> addMilkBuyer(Map milkBuyerData) async {
    final response = await dio.post(
      ApiEndpoints.addNewMilkBuyers,
      data: jsonEncode(milkBuyerData),
    );
    return response.data;
  }

  Future<Map> updateMilkBuyer(Map milkBuyerData) async {
    final response = await dio.post(
      ApiEndpoints.updateMilkBuyer,
      data: jsonEncode(milkBuyerData),
    );
    return response.data;
  }

  Future<Map> getAllMilkBuyers(String dairyId) async {
    final response = await dio.get(
      '${ApiEndpoints.getAllMilkBuyers}?dairy_id=$dairyId',
    );
    return response.data;
  }

  Future<Map> deleteMilkBuyer(String milkBuyerId) async {
    final response = await dio.delete(
      '${ApiEndpoints.deleteMilkBuyers}/$milkBuyerId',
    );
    return response.data;
  }

  Future<Map> updateBuyerStatus(Map milkBuyerData) async {
    final response = await dio.post(
      ApiEndpoints.updateBuyerStatus,
      data: jsonEncode(milkBuyerData),
    );
    return response.data;
  }

  Future<Map> addMilkSale(Map params) async {
    final response = await dio.post(ApiEndpoints.addMilkSale, data: params);
    return response.data;
  }

  Future<Map> getAllMilkSale(String dairyId, String date) async {
    final response = await dio.get(
      '${ApiEndpoints.getAllMilkSale}?dairy_id=$dairyId&date=$date',
    );
    return response.data;
  }

  Future<Map> updateMilkSale(Map params) async {
    final response = await dio.post(ApiEndpoints.updateMilkSale, data: params);
    return response.data;
  }
}

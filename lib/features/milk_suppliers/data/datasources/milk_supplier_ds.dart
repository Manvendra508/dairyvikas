import 'dart:convert';

import 'package:dairysathi/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';

class MilkSupplierDataSource {
  final Dio dio;

  MilkSupplierDataSource(this.dio);

  Future<Map> addMilkSupplier(Map milkSupplierData) async {
    final response = await dio.post(
      ApiEndpoints.addNewMilkSupplier,
      data: jsonEncode(milkSupplierData),
    );
    return response.data;
  }

  Future<Map> updateMilkSupplier(Map milkSupplierData) async {
    final response = await dio.post(
      ApiEndpoints.updateMilkSupplier,
      data: jsonEncode(milkSupplierData),
    );
    return response.data;
  }

  Future<Map> getAllMilkSupliers(String dairyId) async {
    final response = await dio.get(
      '${ApiEndpoints.getAllMilkSupliers}?dairy_id=$dairyId',
    );
    return response.data;
  }

  Future<Map> deleteMilkSupliers(String milkSupplierId) async {
    final response = await dio.delete(
      '${ApiEndpoints.deleteMilkSupliers}/$milkSupplierId',
    );
    return response.data;
  }

  Future<Map> updateSupplierStatus(Map milkSupplierData) async {
    final response = await dio.post(
      ApiEndpoints.updateSupplierStatus,
      data: jsonEncode(milkSupplierData),
    );
    return response.data;
  }
}

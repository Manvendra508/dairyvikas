import 'package:dairysathi/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';

class KhataDatasource {
  final Dio dio;

  KhataDatasource(this.dio);

  Future<Map> addKhataCustomer(Map params) async {
    final response = await dio.post(
      ApiEndpoints.addKhataBookCustomer,
      data: params,
    );
    return response.data;
  }

  Future<Map> updateKhataCustomer(Map params) async {
    final response = await dio.post(
      ApiEndpoints.updateKhataBookCustomer,
      data: params,
    );
    return response.data;
  }

  Future<Map> getAllKhataBookCustomers(String dairyId) async {
    final response = await dio.get(
      '${ApiEndpoints.getKhataBookUsers}?dairy_id=$dairyId',
    );
    return response.data;
  }

  Future<Map> deleteKhataCustomer(String userId) async {
    final response = await dio.delete(
      '${ApiEndpoints.deleteKhataCustomer}/$userId',
    );
    return response.data;
  }

  // entries....

  Future<Map> addEntry(Map params) async {
    final response = await dio.post(
      ApiEndpoints.addKhatabookEntry,
      data: params,
    );
    return response.data;
  }

  Future<Map> updateEntry(Map params) async {
    final response = await dio.post(
      ApiEndpoints.updateKhatabookEntry,
      data: params,
    );
    return response.data;
  }

  Future<Map> getAllEntriesByCustomerId(String userId) async {
    final response = await dio.get(
      '${ApiEndpoints.getKhatabookEntriesByUser}?khatabook_user_id=$userId',
    );
    return response.data;
  }

  Future<Map> deleteEntry(String enrtryId) async {
    final response = await dio.delete(
      '${ApiEndpoints.deleteKhatabookEntry}/$enrtryId',
    );
    return response.data;
  }
}

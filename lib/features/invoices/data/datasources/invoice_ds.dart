import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';

class InvoiceDs {
  final Dio dio;

  InvoiceDs(this.dio);

  Future<Map> getAllInVoices(Map params) async {
    final response = await dio.get(
      ApiEndpoints.getInvoiceDashboard,
      data: params,
    );
    return response.data;
  }

  Future<Map> genrateInvoice(Map params) async {
    final response = await dio.post(ApiEndpoints.generateInvoice, data: params);
    return response.data;
  }

  Future<Map> markPaidInvoice(Map params) async {
    final response = await dio.post(ApiEndpoints.markPaid, data: params);
    return response.data;
  }

  Future<Map> markUnPaidInvoice(Map params) async {
    final response = await dio.post(ApiEndpoints.markUnPaid, data: params);
    return response.data;
  }

  Future<Map> getInvoiceDetails(Map params) async {
    final response = await dio.post(
      ApiEndpoints.getInvoiceDetails,
      data: params,
    );
    return response.data;
  }

  Future<Map> deleteInvoice(String invoiceId) async {
    final response = await dio.delete(
      '${ApiEndpoints.deleteInvoice}/$invoiceId',
    );
    return response.data;
  }
  // Future<Map> updateFoodDealer(Map params) async {
  //   final response = await dio.post(
  //     ApiEndpoints.updateFoodDealer,
  //     data: params,
  //   );
  //   return response.data;
  // }

  // Future<Map> getFoodDealers(String dairyid) async {
  //   final response = await dio.get(
  //     '${ApiEndpoints.getFoodDealers}?dairy_id=$dairyid',
  //   );
  //   return response.data;
  // }
}

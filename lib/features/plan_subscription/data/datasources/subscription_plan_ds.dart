import 'package:dairysathi/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';

class SubscriptionPlanDs {
  final Dio dio;

  SubscriptionPlanDs(this.dio);

  Future<Map> getAllSubscriptionPlan() async {
    final response = await dio.get(ApiEndpoints.getSubscriptionPlans);
    return response.data;
  }

  Future<Map> getOrderId(String planId) async {
    final response = await dio.post(
      ApiEndpoints.createOrderId,
      data: {"planId": planId},
    );
    return response.data;
  }

  Future<Map> verifyPayment(Map params) async {
    final response = await dio.post(ApiEndpoints.verifyPayment, data: params);
    return response.data;
  }

  Future<Map> getTransactionHistory() async {
    final response = await dio.get(ApiEndpoints.transactionHistory);
    return response.data;
  }
}

abstract class SubscriptionPlanRepo {
  Future<Map> getAllPlans();
  Future<Map> getTransactionHistory();
  Future<Map> getOrderId(String planId);
  Future<Map> verifyPayment(Map params);
}

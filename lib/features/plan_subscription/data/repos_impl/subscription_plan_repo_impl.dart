import 'package:DairyVikas/features/plan_subscription/domain/repository/subscription_plan_repo.dart';

import '../datasources/subscription_plan_ds.dart';

class SubscriptionPlanRepoImpl implements SubscriptionPlanRepo {
  final SubscriptionPlanDs subscriptionPlanDs;

  SubscriptionPlanRepoImpl(this.subscriptionPlanDs);

  @override
  Future<Map> getAllPlans() async {
    return await subscriptionPlanDs.getAllSubscriptionPlan();
  }

  @override
  Future<Map> getOrderId(String planId) async {
    return await subscriptionPlanDs.getOrderId(planId);
  }

  @override
  Future<Map> verifyPayment(Map params) async {
    return await subscriptionPlanDs.verifyPayment(params);
  }

  @override
  Future<Map<dynamic, dynamic>> getTransactionHistory() async {
    return await subscriptionPlanDs.getTransactionHistory();
  }
}

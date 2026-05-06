import 'package:dairysathi/features/plan_subscription/domain/repository/subscription_plan_repo.dart';

class GetOrderidUecase {
  final SubscriptionPlanRepo subscriptionPlanRepo;

  GetOrderidUecase(this.subscriptionPlanRepo);

  Future<Map> call(String planId) {
    return subscriptionPlanRepo.getOrderId(planId);
  }
}

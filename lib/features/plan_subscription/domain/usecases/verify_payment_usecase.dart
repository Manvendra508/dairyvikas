import 'package:dairysathi/features/plan_subscription/domain/repository/subscription_plan_repo.dart';

class VerifyPaymentUsecase {
  final SubscriptionPlanRepo subscriptionPlanRepo;

  VerifyPaymentUsecase(this.subscriptionPlanRepo);

  Future<Map> call(Map params) {
    return subscriptionPlanRepo.verifyPayment(params);
  }
}

import 'package:DairyVikas/features/plan_subscription/domain/repository/subscription_plan_repo.dart';

class GetAllSubscriptionPlansUsecase {
  final SubscriptionPlanRepo subscriptionPlanRepo;

  GetAllSubscriptionPlansUsecase(this.subscriptionPlanRepo);

  Future<Map> call() {
    return subscriptionPlanRepo.getAllPlans();
  }
}

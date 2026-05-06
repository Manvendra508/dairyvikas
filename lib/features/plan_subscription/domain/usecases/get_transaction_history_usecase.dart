import 'package:dairysathi/features/plan_subscription/domain/repository/subscription_plan_repo.dart';

class GetTransactionHistoryUsecase {
  final SubscriptionPlanRepo subscriptionPlanRepo;

  GetTransactionHistoryUsecase(this.subscriptionPlanRepo);

  Future<Map> call() {
    return subscriptionPlanRepo.getTransactionHistory();
  }
}

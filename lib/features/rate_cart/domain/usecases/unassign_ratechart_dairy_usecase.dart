import 'package:dairysathi/features/rate_cart/domain/repository/rate_chart_repo.dart';

class UnassignRatechartDairyUsecase {
  final RateChartRepo rateChartRepo;

  UnassignRatechartDairyUsecase(this.rateChartRepo);

  Future<Map> call(Map params) {
    return rateChartRepo.unassignChartToDairy(params);
  }
}

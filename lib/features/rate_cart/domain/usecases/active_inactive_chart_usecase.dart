import 'package:DairyVikas/features/rate_cart/domain/repository/rate_chart_repo.dart';

class ActiveInactiveChartUsecase {
  final RateChartRepo rateChartRepo;

  ActiveInactiveChartUsecase(this.rateChartRepo);

  Future<Map> call(Map params) {
    return rateChartRepo.changeStatusOfRateChart(params);
  }
}

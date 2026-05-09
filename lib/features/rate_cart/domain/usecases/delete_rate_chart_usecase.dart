import 'package:DairyVikas/features/rate_cart/domain/repository/rate_chart_repo.dart';

class DeleteRatechartUsecase {
  final RateChartRepo rateChartRepo;

  DeleteRatechartUsecase(this.rateChartRepo);

  Future<Map> call(String chartId) {
    return rateChartRepo.deleteRateChart(chartId);
  }
}

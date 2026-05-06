import 'package:dairysathi/features/rate_cart/domain/repository/rate_chart_repo.dart';

class UpdateRateChartUsecase {
  final RateChartRepo rateChartRepo;

  UpdateRateChartUsecase(this.rateChartRepo);

  Future<Map> call(Map chartData) {
    return rateChartRepo.updateChart(chartData);
  }
}

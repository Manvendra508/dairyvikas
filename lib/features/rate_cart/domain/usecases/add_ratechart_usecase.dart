import 'package:dairysathi/features/rate_cart/domain/repository/rate_chart_repo.dart';

class AddRatechartUsecase {
  final RateChartRepo rateChartRepo;

  AddRatechartUsecase(this.rateChartRepo);

  Future<Map> call(Map chartData) {
    return rateChartRepo.addChart(chartData);
  }
}

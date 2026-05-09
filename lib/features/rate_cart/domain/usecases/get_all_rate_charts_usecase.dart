import 'package:DairyVikas/features/rate_cart/domain/repository/rate_chart_repo.dart';

class GetAllRateChartsUsecase {
  final RateChartRepo rateChartRepo;

  GetAllRateChartsUsecase(this.rateChartRepo);

  Future<Map> call() {
    return rateChartRepo.getAllRateCharts();
  }
}

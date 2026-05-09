import 'package:DairyVikas/features/rate_cart/domain/repository/rate_chart_repo.dart';

class RateChartDetailsUsecase {
  final RateChartRepo rateChartRepo;

  RateChartDetailsUsecase(this.rateChartRepo);

  Future<Map> call(String chartId) {
    return rateChartRepo.getChartDetails(chartId);
  }
}

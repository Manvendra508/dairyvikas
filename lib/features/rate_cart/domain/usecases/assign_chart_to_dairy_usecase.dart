import 'package:dairysathi/features/rate_cart/domain/repository/rate_chart_repo.dart';

class AssignChartToDairyUsecase {
  final RateChartRepo rateChartRepo;

  AssignChartToDairyUsecase(this.rateChartRepo);

  Future<Map> call(Map params) {
    return rateChartRepo.assignChartToDairy(params);
  }
}

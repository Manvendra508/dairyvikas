import 'package:dairysathi/features/rate_cart/domain/repository/rate_chart_repo.dart';

class AssignChartToSuppliersUsecase {
  final RateChartRepo rateChartRepo;

  AssignChartToSuppliersUsecase(this.rateChartRepo);

  Future<Map> call(Map params) {
    return rateChartRepo.assignChartToDairy(params);
  }
}

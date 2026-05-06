import 'package:dairysathi/features/rate_cart/domain/repository/rate_chart_repo.dart';

class UnassignChartToSuppliersUsecase {
  final RateChartRepo rateChartRepo;

  UnassignChartToSuppliersUsecase(this.rateChartRepo);

  Future<Map> call(Map params) {
    return rateChartRepo.unassignChartToSupppliers(params);
  }
}

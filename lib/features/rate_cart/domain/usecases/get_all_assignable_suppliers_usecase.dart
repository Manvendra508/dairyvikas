import 'package:DairyVikas/features/rate_cart/domain/repository/rate_chart_repo.dart';

class GetAllAssignableSuppliersUsecase {
  final RateChartRepo rateChartRepo;

  GetAllAssignableSuppliersUsecase(this.rateChartRepo);

  Future<Map> call(String chartId, String customerType) {
    return rateChartRepo.getAllAssignableSuppliers(chartId, customerType);
  }
}

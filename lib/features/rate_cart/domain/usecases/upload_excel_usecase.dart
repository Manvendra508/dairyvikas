import 'package:dairysathi/features/rate_cart/domain/repository/rate_chart_repo.dart';
import 'package:dio/dio.dart';

class UploadExcelUsecase {
  final RateChartRepo rateChartRepo;

  UploadExcelUsecase(this.rateChartRepo);

  Future<Map> call(FormData formdata) {
    return rateChartRepo.uploadExcel(formdata);
  }
}

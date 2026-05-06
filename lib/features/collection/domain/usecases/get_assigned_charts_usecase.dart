import 'package:dairysathi/features/collection/domain/repository/collection_repo.dart';

class GetAllssignedChartsUsecase {
  final CollectionRepo collectionRepo;

  GetAllssignedChartsUsecase(this.collectionRepo);

  Future<Map> call() {
    return collectionRepo.getAllAssignedRateCharts();
  }
}

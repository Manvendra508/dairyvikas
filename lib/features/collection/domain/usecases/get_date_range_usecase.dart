import 'package:dairysathi/features/collection/domain/repository/collection_repo.dart';

class GetDateRangeUsecase {
  final CollectionRepo collectionRepo;

  GetDateRangeUsecase(this.collectionRepo);

  Future<Map> call() {
    return collectionRepo.getDateRange();
  }
}

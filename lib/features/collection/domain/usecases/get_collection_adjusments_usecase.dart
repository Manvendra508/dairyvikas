import 'package:DairyVikas/features/collection/domain/repository/collection_repo.dart';

class GetCollectionAdjusmentsUsecase {
  final CollectionRepo collectionRepo;

  GetCollectionAdjusmentsUsecase(this.collectionRepo);

  Future<Map> call(String supplierId, String startDate, String endDate) {
    return collectionRepo.getSupplierCollectionForAdustment(
      supplierId,
      startDate,
      endDate,
    );
  }
}

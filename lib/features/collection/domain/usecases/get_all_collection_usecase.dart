import 'package:DairyVikas/features/collection/domain/repository/collection_repo.dart';


class GetAllCollectionUsecase {
  final CollectionRepo collectionRepo;

  GetAllCollectionUsecase(this.collectionRepo);

  Future<Map> call(String dairyId, String date) {
    return collectionRepo.getAllCollection(dairyId, date);
  }
}

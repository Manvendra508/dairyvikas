import 'package:DairyVikas/features/collection/domain/repository/collection_repo.dart';

class DeleteCollectionUsecase {
  final CollectionRepo collectionRepo;

  DeleteCollectionUsecase(this.collectionRepo);

  Future<Map> call(String collectionId) {
    return collectionRepo.deleteCollection(collectionId);
  }
}

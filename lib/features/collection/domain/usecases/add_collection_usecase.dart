import 'package:DairyVikas/features/collection/domain/repository/collection_repo.dart';

class AddCollectionUsecase {
  final CollectionRepo collectionRepo;

  AddCollectionUsecase(this.collectionRepo);

  Future<Map> call(Map params) {
    return collectionRepo.addNewCollection(params);
  }
}

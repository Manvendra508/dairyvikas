import 'package:dairysathi/features/collection/domain/repository/collection_repo.dart';

class UpdateCollectionUsecase {
  final CollectionRepo collectionRepo;

  UpdateCollectionUsecase(this.collectionRepo);

  Future<Map> call(Map params) {
    return collectionRepo.updateCollection(params);
  }
}

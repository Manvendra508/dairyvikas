import 'package:dairysathi/features/collection/data/datasources/collection_ds.dart';
import 'package:dairysathi/features/collection/domain/repository/collection_repo.dart';

class CollectionRepoImpl implements CollectionRepo {
  final CollectionDataSource collectionDataSource;

  CollectionRepoImpl(this.collectionDataSource);
  @override
  Future<Map> getAllAssignedRateCharts() {
    return collectionDataSource.getAllAssignedRatecharts();
  }

  @override
  Future<Map> addNewCollection(Map params) async {
    return collectionDataSource.addNewCollection(params);
  }

  @override
  Future<Map> getAllCollection(String dairyId, String date) {
    return collectionDataSource.getAllCollection(dairyId, date);
  }

  @override
  Future<Map> getSupplierCollectionForAdustment(
    String supplierId,
    String startDate,
    String endDate,
  ) {
    return collectionDataSource.getSupplierCollectionForAdustment(
      supplierId,
      startDate,
      endDate,
    );
  }

  @override
  Future<Map> getDateRange() {
    return collectionDataSource.getDateRange();
  }

  @override
  Future<Map> updateCollection(Map params) async {
    return collectionDataSource.updateCollection(params);
  }

  @override
  Future<Map> deleteCollection(String collectionId) {
    return collectionDataSource.deleteCollection(collectionId);
  }
}

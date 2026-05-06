abstract class CollectionRepo {
  Future<Map> getAllAssignedRateCharts();
  Future<Map> addNewCollection(Map params);
  Future<Map> updateCollection(Map params);
  Future<Map> getAllCollection(String dairyId, String date);
  Future<Map> deleteCollection(String collectionId);
  Future<Map> getSupplierCollectionForAdustment(
    String supplierId,
    String startDate,
    String endDate,
  );

  Future<Map> getDateRange();
}

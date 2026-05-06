abstract class KhataRepo {
  Future<Map> addKhataCustomer(Map params);
  Future<Map> updateKhataCustomer(Map params);
  Future<Map> getAllKhataBookCustomers(String dairyId);
  Future<Map> deleteKhataCustomer(String userId);

  // entries...
  Future<Map> addEntry(Map params);
  Future<Map> updateEntry(Map params);
  Future<Map> getAllEnteriesOfCustomer(String userId);
  Future<Map> deleteEntry(String userId);
}

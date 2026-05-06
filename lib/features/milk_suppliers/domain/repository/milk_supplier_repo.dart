abstract class MilkSupplierRepo {
  Future<Map> addMilkSupplier(Map milkSupplierData);
  Future<Map> updateMilkSupplier(Map milkSupplierData);
  Future<Map> getAllMilkSupliers(String dairyId);
  Future<Map> deleteMilkSupliers(String supplierId);
  Future<Map> updateSupplierStatus(Map milkSupplierData);
}

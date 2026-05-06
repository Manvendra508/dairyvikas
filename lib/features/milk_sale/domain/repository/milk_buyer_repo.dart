abstract class MilkSaleRepo {
  Future<Map> addMilkBuyer(Map milkBuyerData);
  Future<Map> updateMilkBuyer(Map milkBuyerData);
  Future<Map> getAllMilkBuyers(String dairyId);
  Future<Map> deleteMilkBuyer(String buyerId);
  Future<Map> updateBuyerStatus(Map milkBuyerData);
  Future<Map> addMilkSale(Map params);
  Future<Map> updateMilkSale(Map params);
  Future<Map> getAllMilkSale(String dairyId, String date);
}

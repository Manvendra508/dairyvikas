abstract class FoodRepo {
  // dealers metthods
  Future<Map> addFoodDealer(Map params);
  Future<Map> updateFoodDealer(Map params);
  Future<Map> getFoodDealers(String dairyId);
  Future<Map> getAllItems();
  Future<Map> addNewItem(String itemName);
  Future<Map> updateItem(String itemName, int itemId);

  Future<Map> addFoodStock(Map params);

  Future<Map> updateFoodStock(Map params);
  Future<Map> getFoodStock(String dairyId);

  Future<Map> addFoodSale(Map params);
  Future<Map> updateFoodSale(Map params);
  Future<Map> getStockHistory(
    String dairyId,
    String startDate,
    String endDate,
    String itemId,
  );

  Future<Map> getFoodSales(Map params);
  Future<Map> getUnits();
}

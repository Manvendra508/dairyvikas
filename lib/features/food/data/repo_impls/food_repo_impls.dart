import 'package:dairysathi/features/food/data/datasources/food_datasource.dart';
import 'package:dairysathi/features/food/domain/repository/food_repo.dart';

class FoodRepoImpls implements FoodRepo {
  final FoodDatasource foodDatasource;

  FoodRepoImpls(this.foodDatasource);

  @override
  Future<Map> addFoodDealer(Map params) async {
    return await foodDatasource.addFoodDealer(params);
  }

  @override
  Future<Map> getFoodDealers(String dairyId) async {
    return await foodDatasource.getFoodDealers(dairyId);
  }

  @override
  Future<Map> updateFoodDealer(Map params) async {
    return await foodDatasource.updateFoodDealer(params);
  }

  @override
  Future<Map> getAllItems() async {
    return await foodDatasource.getAllItems();
  }

  @override
  Future<Map> updateItem(String itemName, int itemId) async {
    return await foodDatasource.updateItem(itemName, itemId);
  }

  @override
  Future<Map> addNewItem(String itemName) async {
    return await foodDatasource.addNewItem(itemName);
  }

  @override
  Future<Map> addFoodStock(Map params) async {
    return await foodDatasource.addFoodStock(params);
  }

  @override
  Future<Map> updateFoodStock(Map params) async {
    return await foodDatasource.updateFoodStock(params);
  }

  @override
  Future<Map> getFoodStock(String dairyId) async {
    return await foodDatasource.getFoodStock(dairyId);
  }

  @override
  Future<Map> addFoodSale(Map params) async {
    return await foodDatasource.addFoodSale(params);
  }

  @override
  Future<Map> getStockHistory(
    String dairyId,
    String startDate,
    String endDate,
    String itemId,
  ) async {
    return await foodDatasource.getStockHistory(
      dairyId,
      startDate,
      endDate,
      itemId,
    );
  }

  @override
  Future<Map> getFoodSales(Map params) async {
    return await foodDatasource.getFoodSales(params);
  }

  @override
  Future<Map> updateFoodSale(Map params) async {
    return await foodDatasource.updateFoodSale(params);
  }

  @override
  Future<Map> getUnits() async {
    return await foodDatasource.getUnits();
  }
}

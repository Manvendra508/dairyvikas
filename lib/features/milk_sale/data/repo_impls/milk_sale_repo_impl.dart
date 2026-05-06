import 'package:dairysathi/features/milk_sale/data/datasources/milk_sale_ds.dart';
import 'package:dairysathi/features/milk_sale/domain/repository/milk_buyer_repo.dart';

class MilkBuyerRepoImpl implements MilkSaleRepo {
  final MilkSaleDataSource milkBuyerDataSource;

  MilkBuyerRepoImpl(this.milkBuyerDataSource);
  @override
  Future<Map> addMilkBuyer(Map milkBuyerData) {
    return milkBuyerDataSource.addMilkBuyer(milkBuyerData);
  }

  @override
  Future<Map> updateMilkBuyer(Map milkBuyerData) {
    return milkBuyerDataSource.updateMilkBuyer(milkBuyerData);
  }

  @override
  Future<Map> getAllMilkBuyers(String dairyId) async {
    return milkBuyerDataSource.getAllMilkBuyers(dairyId);
  }

  @override
  Future<Map> deleteMilkBuyer(String buyerId) async {
    return milkBuyerDataSource.deleteMilkBuyer(buyerId);
  }

  @override
  Future<Map> updateBuyerStatus(Map milkBuyerData) {
    return milkBuyerDataSource.updateBuyerStatus(milkBuyerData);
  }

  @override
  Future<Map> addMilkSale(Map params) {
    return milkBuyerDataSource.addMilkSale(params);
  }

  @override
  Future<Map> getAllMilkSale(String dairyId, String date) {
    return milkBuyerDataSource.getAllMilkSale(dairyId, date);
  }

  @override
  Future<Map> updateMilkSale(Map params) {
    return milkBuyerDataSource.updateMilkSale(params);
  }
}

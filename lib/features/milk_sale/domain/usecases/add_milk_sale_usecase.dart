import 'package:DairyVikas/features/milk_sale/domain/repository/milk_buyer_repo.dart';

class AddMilkSaleUsecase {
  final MilkSaleRepo milkSaleRepo;

  AddMilkSaleUsecase(this.milkSaleRepo);

  Future<Map> call(Map params) {
    return milkSaleRepo.addMilkSale(params);
  }
}

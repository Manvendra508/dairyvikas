import 'package:DairyVikas/features/milk_sale/domain/repository/milk_buyer_repo.dart';

class AddMilkBuyerUsecase {
  final MilkSaleRepo milkBuyerRepo;

  AddMilkBuyerUsecase(this.milkBuyerRepo);

  Future<Map> call(Map buyerData) {
    return milkBuyerRepo.addMilkBuyer(buyerData);
  }
}

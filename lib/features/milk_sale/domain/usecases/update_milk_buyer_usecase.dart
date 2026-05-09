import 'package:DairyVikas/features/milk_sale/domain/repository/milk_buyer_repo.dart';

class UpdateMilkBuyerUsecase {
  final MilkSaleRepo milkBuyerRepo;

  UpdateMilkBuyerUsecase(this.milkBuyerRepo);

  Future<Map> call(Map buyerData) {
    return milkBuyerRepo.updateMilkBuyer(buyerData);
  }
}

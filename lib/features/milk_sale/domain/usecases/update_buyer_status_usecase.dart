import 'package:DairyVikas/features/milk_sale/domain/repository/milk_buyer_repo.dart';

class UpdateMilkBuyerStatusUsecase {
  final MilkSaleRepo milkBuyerRepo;

  UpdateMilkBuyerStatusUsecase(this.milkBuyerRepo);

  Future<Map> call(Map buyerData) {
    return milkBuyerRepo.updateBuyerStatus(buyerData);
  }
}

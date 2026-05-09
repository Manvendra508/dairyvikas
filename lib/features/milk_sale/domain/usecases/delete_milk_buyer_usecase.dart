import 'package:DairyVikas/features/milk_sale/domain/repository/milk_buyer_repo.dart';

class DeleteMilkBuyerUsecase {
  final MilkSaleRepo milkBuyerRepo;

  DeleteMilkBuyerUsecase(this.milkBuyerRepo);

  Future<Map> call(String buyerId) {
    return milkBuyerRepo.deleteMilkBuyer(buyerId);
  }
}

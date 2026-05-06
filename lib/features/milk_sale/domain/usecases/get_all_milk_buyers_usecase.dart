import 'package:dairysathi/features/milk_sale/domain/repository/milk_buyer_repo.dart';

class GetAllMilkBuyersUsecase {
  final MilkSaleRepo milkSaleRepo;

  GetAllMilkBuyersUsecase(this.milkSaleRepo);

  Future<Map> call(String dairyId) {
    return milkSaleRepo.getAllMilkBuyers(dairyId);
  }
}

import 'package:DairyVikas/features/milk_sale/domain/repository/milk_buyer_repo.dart';

class UpdateMilkSaleUsecase {
  final MilkSaleRepo milkSaleRepo;

  UpdateMilkSaleUsecase(this.milkSaleRepo);

  Future<Map> call(Map params) {
    return milkSaleRepo.updateMilkSale(params);
  }
}

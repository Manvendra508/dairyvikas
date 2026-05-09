import 'package:DairyVikas/features/milk_sale/domain/repository/milk_buyer_repo.dart';

class GetAllMilksalesUsecase {
  final MilkSaleRepo milkSaleRepo;

  GetAllMilksalesUsecase(this.milkSaleRepo);

  Future<Map> call(String dairyId, String date) {
    return milkSaleRepo.getAllMilkSale(dairyId, date);
  }
}

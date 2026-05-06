import 'package:dairysathi/features/food/domain/repository/food_repo.dart';

class UpdateSaleUsecase {
  final FoodRepo foodRepo;

  UpdateSaleUsecase(this.foodRepo);

  Future<Map> call(Map params) {
    return foodRepo.updateFoodSale(params);
  }
}

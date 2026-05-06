import 'package:dairysathi/features/food/domain/repository/food_repo.dart';

class GetFoodStockUsecase {
  final FoodRepo foodRepo;

  GetFoodStockUsecase(this.foodRepo);

  Future<Map> call(String dairyId) {
    return foodRepo.getFoodStock(dairyId);
  }
}

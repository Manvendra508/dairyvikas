import 'package:dairysathi/features/food/domain/repository/food_repo.dart';

class UpdateFoodStockUsecase {
  final FoodRepo foodRepo;

  UpdateFoodStockUsecase(this.foodRepo);

  Future<Map> call(Map params) {
    return foodRepo.updateFoodStock(params);
  }
}

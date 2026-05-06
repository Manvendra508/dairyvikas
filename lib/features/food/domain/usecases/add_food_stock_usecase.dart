import 'package:dairysathi/features/food/domain/repository/food_repo.dart';

class AddFoodStockUsecase {
  final FoodRepo foodRepo;

  AddFoodStockUsecase(this.foodRepo);

  Future<Map> call(Map params) {
    return foodRepo.addFoodStock(params);
  }
}

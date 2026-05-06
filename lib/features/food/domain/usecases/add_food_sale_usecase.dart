import 'package:dairysathi/features/food/domain/repository/food_repo.dart';

class AddFoodSaleUsecase {
  final FoodRepo foodRepo;

  AddFoodSaleUsecase(this.foodRepo);

  Future<Map> call(Map params) {
    return foodRepo.addFoodSale(params);
  }
}

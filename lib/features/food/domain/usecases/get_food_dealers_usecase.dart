import 'package:dairysathi/features/food/domain/repository/food_repo.dart';

class GetFoodDealersUsecase {
  final FoodRepo foodRepo;

  GetFoodDealersUsecase(this.foodRepo);

  Future<Map> call(String dairyId) {
    return foodRepo.getFoodDealers(dairyId);
  }
}

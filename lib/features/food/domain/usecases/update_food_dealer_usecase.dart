import 'package:DairyVikas/features/food/domain/repository/food_repo.dart';

class UpdateFoodDealerUsecase {
  final FoodRepo foodRepo;

  UpdateFoodDealerUsecase(this.foodRepo);

  Future<Map> call(Map params) {
    return foodRepo.updateFoodDealer(params);
  }
}

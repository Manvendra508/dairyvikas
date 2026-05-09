import 'package:DairyVikas/features/food/domain/repository/food_repo.dart';

class AddFoodDealerUsecase {
  final FoodRepo foodRepo;

  AddFoodDealerUsecase(this.foodRepo);

  Future<Map> call(Map params) {
    return foodRepo.addFoodDealer(params);
  }
}

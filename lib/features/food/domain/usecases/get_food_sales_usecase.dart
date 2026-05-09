import 'package:DairyVikas/features/food/domain/repository/food_repo.dart';

class GetFoodSalesUsecase {
  final FoodRepo foodRepo;

  GetFoodSalesUsecase(this.foodRepo);

  Future<Map> call(Map params) {
    return foodRepo.getFoodSales(params);
  }
}

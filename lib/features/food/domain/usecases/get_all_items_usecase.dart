import 'package:DairyVikas/features/food/domain/repository/food_repo.dart';

class GetAllItemsUsecase {
  final FoodRepo foodRepo;

  GetAllItemsUsecase(this.foodRepo);

  Future<Map> call() {
    return foodRepo.getAllItems();
  }
}

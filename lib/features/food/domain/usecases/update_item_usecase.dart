import 'package:dairysathi/features/food/domain/repository/food_repo.dart';

class UpdateItemUsecase {
  final FoodRepo foodRepo;

  UpdateItemUsecase(this.foodRepo);

  Future<Map> call(String itemName, int itemId) {
    return foodRepo.updateItem(itemName, itemId);
  }
}

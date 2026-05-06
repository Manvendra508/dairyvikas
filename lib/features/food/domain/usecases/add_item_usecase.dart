import 'package:dairysathi/features/food/domain/repository/food_repo.dart';

class AddItemUsecase {
  final FoodRepo foodRepo;

  AddItemUsecase(this.foodRepo);

  Future<Map> call(String itemName) {
    return foodRepo.addNewItem(itemName);
  }
}

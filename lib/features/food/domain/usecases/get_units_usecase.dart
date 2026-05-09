import 'package:DairyVikas/features/food/domain/repository/food_repo.dart';

class GetUnitsUsecase {
  final FoodRepo foodRepo;

  GetUnitsUsecase(this.foodRepo);

  Future<Map> call() {
    return foodRepo.getUnits();
  }
}

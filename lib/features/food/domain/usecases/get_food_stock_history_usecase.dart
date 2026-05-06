import 'package:dairysathi/features/food/domain/repository/food_repo.dart';

class GetFoodStockHistoryUsecase {
  final FoodRepo foodRepo;

  GetFoodStockHistoryUsecase(this.foodRepo);

  Future<Map> call(
    String dairyId,
    String startDate,
    String endDate,
    String itemId,
  ) {
    return foodRepo.getStockHistory(dairyId, startDate, endDate, itemId);
  }
}

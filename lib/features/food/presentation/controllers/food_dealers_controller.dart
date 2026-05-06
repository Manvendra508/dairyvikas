import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/error/exceptions.dart';
import 'package:dairysathi/core/local_datasources/local_storage_service.dart';
import 'package:dairysathi/features/food/data/models/dealer_model.dart';
import 'package:dairysathi/features/food/domain/usecases/get_food_dealers_usecase.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class FoodDealersController extends GetxController with CommonMixin {
  final GetFoodDealersUsecase _getFoodDealersUsecase;

  RxBool hasError = false.obs;

  RxList<DealerModel> dealers = <DealerModel>[].obs;
  RxBool isLoading = false.obs;
  List<DealerModel> filteredDealers = <DealerModel>[];

  TextEditingController searchController = TextEditingController();

  FoodDealersController(this._getFoodDealersUsecase);
  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    await getAllFoodDealers();
  }

  Future getAllFoodDealers() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      Map response = await _getFoodDealersUsecase(dairyId);

      if (response['success']) {
        hasError.value = false;
        dealers.clear();
        List dealersJson = response['data'] as List;

        dealers.addAll(
          dealersJson.map((dealerJson) => DealerModel.fromJson(dealerJson)),
        );

        filteredDealers.assignAll(dealers);
      } else {
        hasError.value = true;
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      hasError.value = true;
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      isLoading.value = false;
    }
  }

  searchDealer(String searchTerm) {
    filteredDealers.assignAll(
      dealers.where(
        (dealer) =>
            dealer.dealerName.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ) ||
            dealer.dealerCode.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ),
      ),
    );
    update();
  }
}

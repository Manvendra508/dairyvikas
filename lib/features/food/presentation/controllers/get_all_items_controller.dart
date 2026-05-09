import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/features/food/data/models/item_model.dart';
import 'package:DairyVikas/features/food/domain/usecases/add_item_usecase.dart';
import 'package:DairyVikas/features/food/domain/usecases/get_all_items_usecase.dart';
import 'package:DairyVikas/features/food/domain/usecases/update_item_usecase.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AllItemsController extends GetxController with CommonMixin {
  final GetAllItemsUsecase _getAllItemsUsecase;
  final AddItemUsecase _addItemUsecase;
  final UpdateItemUsecase _updateItemUsecase;

  RxBool hasError = false.obs;

  RxList<ItemModel> items = <ItemModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool proccessing = false.obs;
  List<ItemModel> filteredItems = <ItemModel>[];

  TextEditingController searchController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  AllItemsController(
    this._getAllItemsUsecase,
    this._addItemUsecase,
    this._updateItemUsecase,
  );
  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    await getAllItems();
  }

  Future getAllItems() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;

      Map response = await _getAllItemsUsecase();

      if (response['success']) {
        hasError.value = false;
        items.clear();
        List itemJson = response['data']['items'] as List;

        items.addAll(itemJson.map((tj) => ItemModel.fromJson(tj)));

        filteredItems.assignAll(items);
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

  Future addNewItem() async {
    try {
      if (proccessing.value) return;
      proccessing.value = true;

      Map response = await _addItemUsecase(itemNameController.text);

      if (response['success']) {
        showAppToastMessage(response['message'], false);
        AppNavigation.goBack();
        await getAllItems();
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      proccessing.value = false;
    }
  }

  Future updateItem(String itemName, int itemId) async {
    try {
      if (proccessing.value) return;
      proccessing.value = true;

      Map response = await _updateItemUsecase(itemNameController.text, itemId);

      if (response['success']) {
        showAppToastMessage(response['message'], false);
        itemNameController
            .clear(); // this is because if the user add new item after
        // updating some item the previous  value will not show in textform field
        AppNavigation.goBack();
        await getAllItems();
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      proccessing.value = false;
    }
  }

  searchItem(String searchTerm) {
    filteredItems.assignAll(
      items.where(
        (item) =>
            item.itemName.toLowerCase().startsWith(searchTerm.toLowerCase()),
      ),
    );
    update();
  }
}

import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/features/milk_suppliers/domain/usecases/delete_milk_supplier_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/select_bool_option_widget.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_navigation.dart';
import 'get_milk_suppliers_controller.dart';

class MilkSupplierDetailsController extends GetxController with CommonMixin {
  final DeleteMilkSupplierUsecase deleteMilkSupplierUsecase;
  String validationErrorMessage = '';
  RxBool isDeleting = false.obs;

  // final supplierCode = TextEditingController();
  // final supplierFullName = TextEditingController();
  // final supplierEnglishName = TextEditingController();
  // final supplierMobileNumber = TextEditingController();
  // final supplierEmail = TextEditingController();
  RxMap<String, dynamic> selectedMilkType = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> milkTypes = <Map<String, dynamic>>[
    {"id": '1', "value": "Cow"},
    {"id": '2', "value": "Buffalo"},
  ].obs;

  MilkSupplierDetailsController(this.deleteMilkSupplierUsecase);

  Future<void> deleteMilkSupplier(String supplierId) async {
    if (isDeleting.value) return;

    isDeleting.value = true;

    try {
      var response = await deleteMilkSupplierUsecase(supplierId);
      if (response['success']) {
        final allMilkSuppliersController =
            Get.find<AllMilkSuppliersController>();
        showAppToastMessage(response['message'], false);

        await allMilkSuppliersController.getAllMilkSuppliers();

        AppNavigation.goBack();
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isDeleting.value = false;
    }
  }

  showDeleteSupplierOption(
    BuildContext context,
    String supplierId,
    String supplierName,
  ) {
    showMyBottomSheet(
      context,
      SelectBoolOptionWidget(
        message: 'remove_supplier_warning_message'.trParams({
          'name': supplierName,
        }),
        title: 'warning',
        callback: () async {
          AppNavigation.goBack();
          await deleteMilkSupplier(supplierId);
        },
      ),
    );
  }
}

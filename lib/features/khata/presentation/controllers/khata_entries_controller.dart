import 'package:dairysathi/features/khata/data/models/khata_entry_model.dart';
import 'package:dairysathi/features/khata/domain/usecases/add_entry_usecase.dart';
import 'package:dairysathi/features/khata/domain/usecases/delete_entry_usecase.dart';
import 'package:dairysathi/features/khata/domain/usecases/get_entries_by_user_usecase.dart';
import 'package:dairysathi/features/khata/domain/usecases/update_entry_usecase.dart';
import 'package:dairysathi/features/khata/presentation/controllers/all_khata_customers_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/common_mixin.dart';
import '../../../../common/common_widget/select_bool_option_widget.dart'
    show SelectBoolOptionWidget;
import '../../../../core/error/exceptions.dart';
import '../../../../core/local_datasources/app_state.dart';
import '../../../../core/utils/app_navigation.dart';

class KhataEntriesController extends GetxController with CommonMixin {
  final GetEntriesByUserUsecase _getEntriesByUserUsecase;
  final AddEntryUsecase _addEntryUsecase;
  final UpdateEntryUsecase _updateEntryUsecase;
  final DeleteEntryUsecase _deleteEntryUsecase;

  final entryAmountController = TextEditingController();
  final noteController = TextEditingController();
  RxBool hasError = false.obs;
  RxString curentDate = ''.obs;
  RxBool isLoading = false.obs;
  RxBool proccessing = false.obs;
  double totalAmount = 0.0;

  RxList<KhataEntryModel> customerKhataEntries = <KhataEntryModel>[].obs;
  RxList<KhataEntryModel> filteredCustomerKhataEntries =
      <KhataEntryModel>[].obs;

  KhataEntriesController(
    this._getEntriesByUserUsecase,
    this._addEntryUsecase,
    this._updateEntryUsecase,
    this._deleteEntryUsecase,
  );

  @override
  void onInit() {
    _firstMethod();
    super.onInit();
  }

  _firstMethod() async {
    curentDate.value = formatDateforApi(DateTime.now());
    await getAllEntriesByCustomerId();
  }

  pickDateForFilter(BuildContext context) async {
    curentDate.value =
        await pickDate(
          context: context,
          initialDate: curentDate.value.isNotEmpty
              ? DateTime.tryParse(curentDate.value)
              : DateTime.now(),
        ) ??
        formatDateforApi(DateTime.now());
  }

  Future getAllEntriesByCustomerId() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;

      Map response = await _getEntriesByUserUsecase(
        AppState.currentKhataBookCustomerForUpdate.khatabookUserId.toString(),
      );

      if (response['success']) {
        hasError.value = false;
        customerKhataEntries.clear();

        List khatabookUsersJson = response['data'] as List;

        customerKhataEntries.assignAll(
          khatabookUsersJson
              .map((item) => KhataEntryModel.fromJson(item))
              .toList(),
        );
        customerKhataEntries.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        double totalCredit = getTotalByType(customerKhataEntries, "credit");
        double totalDebit = getTotalByType(customerKhataEntries, "debit");
        totalAmount = totalCredit - totalDebit;

        filteredCustomerKhataEntries.assignAll(customerKhataEntries);
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

  double getTotalByType(List<KhataEntryModel> entries, String type) {
    return entries
        .where((e) => e.type == type)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  bool validateData() {
    if (entryAmountController.text.isEmpty) {
      showAppToastMessage('please_enter_amount', true);
      return false;
    } else {
      double? amount = double.tryParse(entryAmountController.text);

      if (amount == null || amount <= 0) {
        showAppToastMessage("enter_valid_amount", true);
        return false;
      }
    }
    return true;
  }

  Future<void> updateKhataEntry(KhataEntryModel entry) async {
    if (!validateData() || proccessing.value) return;

    proccessing.value = true;

    final entryData = {
      "entry_id": entry.id,
      "type": entry.type,
      "note": noteController.text.trim(),
      "amount": double.parse(entryAmountController.text),
    };

    try {
      var response = await _updateEntryUsecase(entryData);
      if (response['success']) {
        _proccessResponse(response);
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

  Future<void> removeEntry(String entryId) async {
    if (proccessing.value) return;

    proccessing.value = true;

    try {
      var response = await _deleteEntryUsecase(entryId);
      if (response['success']) {
        _proccessResponse(response);
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

  _clearForm() {
    entryAmountController.clear();
    noteController.clear();
  }

  Future<void> addKhataEntry(String type) async {
    if (!validateData() || proccessing.value) return;

    proccessing.value = true;

    final entryData = {
      "khatabook_user_id":
          AppState.currentKhataBookCustomerForUpdate.khatabookUserId,
      "type": type,
      "note": noteController.text.trim(),
      "amount": int.parse(entryAmountController.text),
    };

    try {
      var response = await _addEntryUsecase(entryData);
      if (response['success']) {
        _clearForm();
        _proccessResponse(response);
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

  _proccessResponse(var response) async {
    final allCustomersController = Get.find<AllKhataCustomersController>();
    showAppToastMessage(response['message'], false);
    AppNavigation.goBack();
    await getAllEntriesByCustomerId();
    await allCustomersController.getAllKhataCustomers();
  }

  showDeleteEntryOption(BuildContext context, String message, String entryId) {
    showMyBottomSheet(
      context,
      SelectBoolOptionWidget(
        message: message,
        title: 'warning',
        callback: () async {
          await removeEntry(entryId);
        },
      ),
    );
  }

  String timeAgo(String isoDate) {
    final DateTime dateTime = DateTime.parse(isoDate).toLocal();
    final Duration diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} sec ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()} weeks ago';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()} months ago';
    } else {
      return '${(diff.inDays / 365).floor()} years ago';
    }
  }
}

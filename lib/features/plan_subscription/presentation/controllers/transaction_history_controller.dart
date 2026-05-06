import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/error/exceptions.dart';
import 'package:dairysathi/features/plan_subscription/data/model/transaction_model.dart';
import 'package:dairysathi/features/plan_subscription/domain/usecases/get_transaction_history_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionHistoryController extends GetxController with CommonMixin {
  final GetTransactionHistoryUsecase transactionHistoryUsecase;
  RxInt currentStatusFilterIndex = 0.obs;
  RxBool hasError = false.obs;
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> statusFilters = <Map<String, dynamic>>[
    {"id": '0', "title": 'all'},
    {"id": '1', "title": 'success'},
    {"id": '2', "title": 'failed'},
    {"id": '3', "title": 'pending'},
  ].obs;
  RxString selectedStatus = '0'.obs;

  RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  RxList<TransactionModel> filtredTransactions = <TransactionModel>[].obs;

  TransactionHistoryController({required this.transactionHistoryUsecase});

  @override
  void onInit() {
    super.onInit();
    getAllTransactionHistory();
  }

  selectStatus(int index) {
    currentStatusFilterIndex.value = index;
    selectedStatus.value = statusFilters[index]['id'];

    filterTransactions();
  }

  Future getAllTransactionHistory() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;

      Map response = await transactionHistoryUsecase();

      if (response['success']) {
        hasError.value = false;

        List transactionJsonList = response['data']['transactions'] as List;

        transactions.assignAll(
          transactionJsonList
              .map((item) => TransactionModel.fromJson(item))
              .toList(),
        );
        filtredTransactions.assignAll(transactions);
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

  Color transactionColor(String status) {
    if (status == 'success') {
      return AppColors.darkgreenColor;
    } else if (status == 'pending') {
      return AppColors.warning;
    } else {
      return AppColors.redColor;
    }
  }

  filterTransactions() {
    if (selectedStatus.value == '0') {
      filtredTransactions.assignAll(transactions);
    } else if (selectedStatus.value == '1') {
      filtredTransactions.assignAll(
        transactions.where((tr) => tr.status == 'success').toList(),
      );
    } else if (selectedStatus.value == '2') {
      filtredTransactions.assignAll(
        transactions.where((tr) => tr.status == 'failed').toList(),
      );
    } else if (selectedStatus.value == '3') {
      filtredTransactions.assignAll(
        transactions.where((tr) => tr.status == 'pending').toList(),
      );
    }
  }
}

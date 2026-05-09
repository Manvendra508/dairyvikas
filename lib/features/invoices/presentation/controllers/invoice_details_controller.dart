import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/features/invoices/data/model/invoice_details_collection_model.dart';
import 'package:DairyVikas/features/invoices/data/model/invoice_details_item_sale_model.dart';
import 'package:DairyVikas/features/invoices/domain/usecases/delete_invoice_usecase.dart';
import 'package:DairyVikas/features/invoices/domain/usecases/get_invoice_details_usecase.dart';
import 'package:DairyVikas/features/invoices/presentation/controllers/all_invoice_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/select_bool_option_widget.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_navigation.dart';

class InvoiceDetailsController extends GetxController with CommonMixin {
  final DeleteInvoiceUsecase deleteInvoiceUsecase;
  final GetInvoiceDetailsUsecase getInvoiceDetailsUsecase;
  RxBool hasError = false.obs;
  RxBool isLoading = true.obs;
  RxBool isShowFullDataOpen = false.obs;
  List<List<InvoiceDetailsCollectionModel>> invoiceDetailsCollections =
      <List<InvoiceDetailsCollectionModel>>[].obs;
  int totalCollectionAmount = 0;
  int totalItemSaleAmount = 0;
  int totalItemDeductionAmount = 0;
  int finalAmount = 0;
  List<InvoiceDetailsItemSaleModel> itemSaleList =
      <InvoiceDetailsItemSaleModel>[].obs;

  InvoiceDetailsController(
    this.deleteInvoiceUsecase,
    this.getInvoiceDetailsUsecase,
  );

  @override
  void onInit() {
    getInvoiceDetails();
    super.onInit();
  }

  Future<void> deleteInvoice() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      var response = await deleteInvoiceUsecase(
        AppState.currentInvoiceForUpdate.invoiceId ?? '',
      );
      if (response['success']) {
        final allInvoiceController = Get.find<AllInvoiceController>();
        await allInvoiceController.getAllInvoices();
        AppNavigation.goBack();
        showAppToastMessage(response['message'], false);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getInvoiceDetails() async {
    try {
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      Map params = {
        "dairyId": dairyId,
        "partyId": AppState.currentInvoiceForUpdate.partyId,
        "startDate": AppState.currentInvoiceForUpdate.periodStart,
        "invoiceId": AppState.currentInvoiceForUpdate.invoiceId,
        "endDate": AppState.currentInvoiceForUpdate.periodEnd,
      };

      var response = await getInvoiceDetailsUsecase(params);
      if (response['success']) {
        hasError.value = false;
        List invoiceDetailsCollectionJson =
            response['data']['transactions']['milk_collections'] as List;

        List invoiceDetailsItemSaleJson =
            response['data']['transactions']['item_sales'] as List;

        final allData = invoiceDetailsCollectionJson
            .map((e) => InvoiceDetailsCollectionModel.fromJson(e))
            .toList();

        Map<String, List<InvoiceDetailsCollectionModel>> groupedMap = {};

        for (var item in allData) {
          final date = item.collectionDate;

          groupedMap.putIfAbsent(date, () => []);
          groupedMap[date]!.add(item);
        }

        //  final sortedKeys = groupedMap.keys.toList()
        //           ..sort((a, b) => b.compareTo(a));

        //         final groupedList = sortedKeys.map((key) => groupedMap[key]!).toList();
        invoiceDetailsCollections.assignAll(groupedMap.values.toList());

        // item sale list

        itemSaleList.assignAll(
          invoiceDetailsItemSaleJson
              .map((e) => InvoiceDetailsItemSaleModel.fromJson(e))
              .toList(),
        );

        totalCollectionAmount = double.parse(
          response['data']['summary']['milk_collection'].toString(),
        ).toInt();
        totalItemSaleAmount = double.parse(
          response['data']['summary']['item_sale'].toString(),
        ).toInt();

        finalAmount = double.parse(
          response['data']['summary']['final_total'].toString(),
        ).toInt();
      } else {
        hasError.value = true;
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isLoading.value = false;
    }
  }

  showDeleteInvoiceOption(BuildContext context) {
    showMyBottomSheet(
      context,
      SelectBoolOptionWidget(
        message: 'delete_invoice',
        title: 'warning',
        callback: () async {
          AppNavigation.goBack();
          await deleteInvoice();
        },
      ),
    );
  }
}

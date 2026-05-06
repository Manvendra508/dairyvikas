import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/error/exceptions.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart' show AppState;
import 'package:dairysathi/core/local_datasources/local_storage_service.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/features/invoices/data/model/invoice_model.dart';
import 'package:dairysathi/features/invoices/domain/usecases/genrate_invoice_usecase.dart';
import 'package:dairysathi/features/invoices/domain/usecases/get_all_invoices_usecase.dart';
import 'package:dairysathi/features/invoices/domain/usecases/mark_paid_invoice_usecase.dart';
import 'package:dairysathi/features/invoices/domain/usecases/mark_unpaid_invoice.dart';
import 'package:dairysathi/features/milk_suppliers/data/model/milk_suppliers_response_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AllInvoiceController extends GetxController with CommonMixin {
  final GetAllInvoicesUsecase _getAllInvoicesUsecase;
  final GenrateInvoiceUsecase _genrateInvoiceUsecase;
  final MarkPaidInvoiceUsecase _markPaidInvoiceUsecase;
  final MarkUnpaidInvoiceUseCase _markUnpaidInvoice;
  RxBool hasError = false.obs;
  RxInt currentStatusFilterIndex = 0.obs;
  RxList<InvoiceModel> allInvoices = <InvoiceModel>[].obs;
  RxBool isLoading = false.obs;
  List<InvoiceModel> filteredInvoicesList = <InvoiceModel>[];
  MilkSuppliersResponseModel milkSuppliersResponseModel =
      MilkSuppliersResponseModel.empty();

  RxMap selectedDateRange = {}.obs;
  RxInt currentDateRangeIndex = 0.obs;
  RxString selectedStatus = '0'.obs;
  TextEditingController searchController = TextEditingController();
  RxList<Map<String, dynamic>> statusFilters = <Map<String, dynamic>>[
    {"id": '0', "title": 'all'},
    {"id": '1', "title": 'paid'},
    {"id": '2', "title": 'pending'},
    {"id": '3', "title": 'invoice_genrate'},
  ].obs;

  String invociePendingStatusKey = 'Pending Invoice';

  String invoiceGenratedStatusKey = 'Invoice Generated';
  String invoicePaidStatusKey = 'Paid';
  AllInvoiceController(
    this._getAllInvoicesUsecase,
    this._genrateInvoiceUsecase,
    this._markPaidInvoiceUsecase,
    this._markUnpaidInvoice,
  );
  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    if (AppState.dateRanges.isNotEmpty) {
      selectedDateRange.addAll(AppState.dateRanges[0]);
    }
    await getAllInvoices();
  }

  selectDateRange(int index) async {
    currentDateRangeIndex.value = index;
    selectedDateRange.value = AppState.dateRanges[currentDateRangeIndex.value];
    AppNavigation.goBack();
    await getAllInvoices();
  }

  Future getAllInvoices() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';

      Map params = {
        "dairyId": dairyId,
        "startDate": selectedDateRange['start'],

        "endDate": selectedDateRange['end'],
      };
      Map response = await _getAllInvoicesUsecase(params);

      if (response['success']) {
        hasError.value = false;
        allInvoices.clear();
        List invoiceJsonList = response['data'] as List;

        allInvoices.addAll(
          invoiceJsonList.map((e) => InvoiceModel.fromJson(e)).toList(),
        );

        filteredInvoicesList.assignAll(allInvoices);
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

  Future<void> genrateInvoice(InvoiceModel invoice) async {
    if (isLoading.value) return;

    isLoading.value = true;

    final params = {
      "sourceId": invoice.sourceRefId,
      "partyType": invoice.partyType,
      "periodStart": selectedDateRange['start'],
      "periodEnd": selectedDateRange['end'],
    };
    try {
      var response = await _genrateInvoiceUsecase(params);
      if (response['success']) {
        isLoading.value =
            false; // because if we dont set false to it , then below function will  not call
        await getAllInvoices();

        showAppToastMessage(response['message'], false);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markPaidInvoice(InvoiceModel invoice) async {
    if (isLoading.value) return;

    isLoading.value = true;
    String paymentDate = formatDateforApi(DateTime.now());
    final params = {
      "invoiceId": invoice.invoiceId,
      "amount": invoice.totalAmount,
      "paymentDate": paymentDate,
      "paymentMode": "UPI",
    };
    try {
      var response = await _markPaidInvoiceUsecase(params);
      if (response['success']) {
        isLoading.value =
            false; // because if we dont set false to it , then below function will  not call
        await getAllInvoices();

        showAppToastMessage(response['message'], false);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markUnPaidInvoice(InvoiceModel invoice) async {
    if (isLoading.value) return;

    isLoading.value = true;

    final params = {"invoiceId": invoice.invoiceId};
    try {
      var response = await _markUnpaidInvoice(params);
      if (response['success']) {
        isLoading.value =
            false; // because if we dont set false to it , then below function will  not call
        await getAllInvoices();

        showAppToastMessage(response['message'], false);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isLoading.value = false;
    }
  }

  selectStatus(int index) {
    currentStatusFilterIndex.value = index;
    selectedStatus.value = statusFilters[index]['id'];
    filterInvoice();
  }

  filterInvoice() {
    if (selectedStatus.value == '0') {
      filteredInvoicesList.assignAll(allInvoices);
    } else if (selectedStatus.value == '1') {
      filteredInvoicesList.assignAll(
        allInvoices
            .where((invoice) => invoice.status == invoicePaidStatusKey)
            .toList(),
      );
    } else if (selectedStatus.value == '2') {
      filteredInvoicesList.assignAll(
        allInvoices
            .where((invoice) => invoice.status == invociePendingStatusKey)
            .toList(),
      );
    } else if (selectedStatus.value == '2') {
      filteredInvoicesList.assignAll(
        allInvoices
            .where((invoice) => invoice.status == invoiceGenratedStatusKey)
            .toList(),
      );
    }

    update();
  }

  searchInvoice(String searchTerm) {
    filteredInvoicesList.assignAll(
      allInvoices.where(
        (invoice) =>
            invoice.partyName.toLowerCase().startsWith(
              searchTerm.toLowerCase(),
            ) ||
            invoice.eligibleAmount.toString().startsWith(
              searchTerm.toLowerCase(),
            ),
      ),
    );
    update();
  }

  String getInvoiceStatus(String key) {
    if (key == invoiceGenratedStatusKey) {
      return 'invoice_genrate';
    } else if (key == invociePendingStatusKey) {
      return 'pending';
    } else {
      return 'paid';
    }
  }

  Color getInvoiceStatusColor(String key) {
    if (key == invoiceGenratedStatusKey) {
      return AppColors.blue;
    } else if (key == invociePendingStatusKey) {
      return AppColors.warning;
    } else {
      return AppColors.themeColor.withOpacity(0.8);
    }
  }

  // String getInvoiceAmount(InvoiceModel invoice) {
  //   if (invoice.status == invoiceGenratedStatusKey) {
  //     return invoice.totalAmount.toString();
  //   } else if (invoice.status == invociePendingStatusKey) {
  //     return invoice.eligibleAmount.toString();
  //   } else {
  //     return invoice.paidAmount.toString();
  //   }
  // }

  String getInvoiceAmount(InvoiceModel invoice) {
    double amount;

    if (invoice.status == invoiceGenratedStatusKey) {
      amount = invoice.totalAmount;
    } else if (invoice.status == invociePendingStatusKey) {
      amount = invoice.eligibleAmount;
    } else {
      amount = invoice.paidAmount;
    }

    return _formatAmount(amount);
  }

  String _formatAmount(double amount) {
    if (amount < 0) {
      return "${amount.abs().toStringAsFixed(2)}"; // or "(-₹xx)"
    } else {
      return "${amount.toStringAsFixed(2)}";
    }
  }

  String getButtonDynamicText(InvoiceModel invoice) {
    if (invoice.partyType == "buyer") {
      return "mark_receive";
    }

    if (invoice.partyType == "dealer") {
      return "mark_paid";
    }

    if (invoice.partyType == "supplier") {
      double total;

      if (invoice.status == invoiceGenratedStatusKey) {
        total = invoice.totalAmount;
      } else if (invoice.status == invociePendingStatusKey) {
        total = invoice.eligibleAmount;
      } else {
        total = invoice.paidAmount;
      }
      if (total > 0) {
        return "mark_paid";
      } else {
        return "mark_receive";
      }
    }

    return "";
  }
}

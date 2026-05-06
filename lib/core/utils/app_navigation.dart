import 'package:dairysathi/app/routes/app_router.dart';
import 'package:dairysathi/app/routes/route_names.dart';
import 'package:dairysathi/features/milk_suppliers/data/model/milk_supplier_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/rate_cart/data/model/rate_chart_model.dart';

class AppNavigation {
  AppNavigation._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter get _router => AppRouter.router;

  static void goToLogin() {
    _router.push(RouteNames.login);
  }

  static void goToLoginAndRemoveAll() {
    _router.go(RouteNames.login);
  }

  static void goToForgotPasswordPage() {
    _router.push(RouteNames.forgotPassword);
  }

  static void goToPersonalDetailsPage() {
    _router.push(RouteNames.personalDetails);
  }

  static void goToDairyCenterDetailsPage(bool isFromDashboard) {
    _router.push(
      RouteNames.dairyCenterDetails,
      extra: {"isFromDashboard": isFromDashboard},
    );
  }

  static void goToDairyCenterSettingsPage() {
    _router.push(RouteNames.dairyCenterSettings);
  }

  static void goToDashboardPage() {
    _router.go(RouteNames.dashboard);
  }

  static void goToOtpVerifyPage(String phone, String otpSentMsg) {
    _router.push(
      RouteNames.verifyOtp,
      extra: {"phone": phone, 'message': otpSentMsg},
    );
  }

  static void goToAddRateChartPage() {
    _router.push(RouteNames.addRateChart);
  }

  static void goToAllRateChartsPage() {
    _router.push(RouteNames.allRateCharts);
  }

  static void goToRateChartDetailsPage(RateChartModel rateChart) {
    _router.push(RouteNames.rateChartDetails, extra: {"rate_chart": rateChart});
  }

  static void goToEditRateChartPage(RateChartModel rateChart) {
    _router.push(RouteNames.editRateChart, extra: {"rate_chart": rateChart});
  }

  static void goToAllMilkSuppliersPage() {
    _router.push(RouteNames.milkSuppliers);
  }

  static void goToAddMilkSupplierPage() {
    _router.push(RouteNames.addMilkSupplier);
  }

  static void goToMilkSupplierDetailsPage(MilkSupplierModel supplier) {
    _router.push(RouteNames.milkSupplierDetails, extra: {"supplier": supplier});
  }

  static void goToAssignedChartsSuppliersPage() {
    _router.push(RouteNames.assignedChartSuppliers);
  }

  static void goToAddNewCollectionPage(bool isfromCollectionList) {
    _router.push(
      RouteNames.addCollection,
      extra: {"isfromCollectionList": isfromCollectionList},
    );
  }

  static void goToAllCollectionsPage() {
    _router.push(RouteNames.allCollection);
  }

  static void goToAdjustCollectionPage() {
    _router.push(RouteNames.adjustCollection);
  }

  static void goToCustomerPdfSheetPage() {
    _router.push(RouteNames.customerPdfSheet);
  }

  static void goToAllMilkSalePage() {
    _router.push(RouteNames.allMilkSales);
  }

  static void goToAddMilkSalePage() {
    _router.push(RouteNames.addMilkSale);
  }

  static void goToMilkBuyersPage() {
    _router.push(RouteNames.milkBuyers);
  }

  static void goToAddMilkBuyerPage() {
    _router.push(RouteNames.addMilkBuyer);
  }

  static void goToAddDealerPage() {
    _router.push(RouteNames.addDealer);
  }

  static void goToAllDealerPage() {
    _router.push(RouteNames.foodDealers);
  }

  static void goToFoodStocksPage() {
    _router.push(RouteNames.foodStocks);
  }

  static void goToAddFoodStockPage(bool isFromStockListing) {
    _router.push(
      RouteNames.addFoodStock,
      extra: {'isFromStockListing': isFromStockListing},
    );
  }

  static void goToAddFoodSalePage() {
    _router.push(RouteNames.addFoodSale);
  }

  static Future<T?> goToItemListPage<T>() {
    return _router.push<T>(RouteNames.allItems);
  }

  static void goToFoodSalesPage() {
    _router.push(RouteNames.foodSales);
  }

  static void goToFoodStockHistoryPage() {
    _router.push(RouteNames.foodStockHistory);
  }

  static void goToNoticePostsPage() {
    _router.push(RouteNames.noticePosts);
  }

  static void goToAddNoticePostPage() {
    _router.push(RouteNames.addPost);
  }

  static void goToAllHisaabPage() {
    _router.push(RouteNames.allKhataCustomers);
  }

  static void goToAddKhataCustomerPage() {
    _router.push(RouteNames.addKhataCustomer);
  }

  static void goToAddKhataEntriesPage() {
    _router.push(RouteNames.khataEntries);
  }

  static void goToAllInvoicesPage() {
    _router.push(RouteNames.allInvoices);
  }

  static void goToSubscriptionPlanPage() {
    _router.push(RouteNames.plans);
  }

  static void goToInvoiceDetailsPage(bool showRemoveButton) {
    _router.push(
      RouteNames.invoiceDetails,
      extra: {"showRemoveButton": showRemoveButton},
    );
  }

  static void goToPaymentPage(bool isPaymentSuccess) {
    _router.push(
      RouteNames.payment,
      extra: {"isPaymentSuccess": isPaymentSuccess},
    );
  }

  static void goToScanDevicesPage() {
    _router.push(RouteNames.scanDevices);
  }

  static void goToProfilePage() {
    _router.push(RouteNames.profile);
  }

  static void goToDairySettingsPage() {
    _router.push(RouteNames.settings);
  }

  static void goToSearchInAppPage() {
    _router.push(RouteNames.searchInApp);
  }

  static void goToTransactionHistoryPage() {
    _router.push(RouteNames.transactionHistory);
  }

  static void goBack<T extends Object?>([T? result]) {
    _router.pop(result);
  }
}

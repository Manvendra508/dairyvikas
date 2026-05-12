// lib/core/router/app_router.dart

import 'package:DairyVikas/features/auth/login/presentation/controllers/forgot_password_controller.dart';
import 'package:DairyVikas/features/auth/login/presentation/pages/forgot_password_page.dart';
import 'package:DairyVikas/features/auth/login/presentation/pages/login_page.dart';
import 'package:DairyVikas/features/auth/registration_flow/presentation/pages/dairy_center_details_page.dart';
import 'package:DairyVikas/features/auth/registration_flow/presentation/pages/dairy_center_settings.dart';
import 'package:DairyVikas/features/auth/registration_flow/presentation/pages/otp_verify_page.dart';
import 'package:DairyVikas/features/auth/registration_flow/presentation/pages/register_vendor_page.dart';
import 'package:DairyVikas/features/collection/data/model/collection_model.dart';
import 'package:DairyVikas/features/collection/presentation/controllers/add_collection_controller.dart';
import 'package:DairyVikas/features/collection/presentation/controllers/adjust_collection_controller.dart';
import 'package:DairyVikas/features/collection/presentation/controllers/all_collection_controller.dart';
import 'package:DairyVikas/features/collection/presentation/pages/add_collection_page.dart';
import 'package:DairyVikas/features/collection/presentation/pages/adjusment_collection.dart';
import 'package:DairyVikas/features/collection/presentation/pages/customer_pdf_sheet.dart';
import 'package:DairyVikas/features/dashboard/presentation/controllers/search_in_app_controller.dart';
import 'package:DairyVikas/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:DairyVikas/features/dashboard/presentation/pages/search_in_app_page.dart';
import 'package:DairyVikas/features/food/data/models/dealer_model.dart';
import 'package:DairyVikas/features/food/data/models/sale_model.dart';
import 'package:DairyVikas/features/food/data/models/stock_history_model.dart';
import 'package:DairyVikas/features/food/presentation/controllers/add_food_dealer_controller.dart';
import 'package:DairyVikas/features/food/presentation/controllers/add_food_sale_controller.dart';
import 'package:DairyVikas/features/food/presentation/controllers/add_food_stock_controller.dart';
import 'package:DairyVikas/features/food/presentation/controllers/food_sales_controller.dart';
import 'package:DairyVikas/features/food/presentation/controllers/food_stock_controller.dart';
import 'package:DairyVikas/features/food/presentation/controllers/food_stock_history_controller.dart';
import 'package:DairyVikas/features/food/presentation/controllers/get_all_items_controller.dart';
import 'package:DairyVikas/features/food/presentation/pages/add_food_dealer_page.dart';
import 'package:DairyVikas/features/food/presentation/pages/add_food_sale_page.dart';
import 'package:DairyVikas/features/food/presentation/pages/add_food_stock_page.dart';
import 'package:DairyVikas/features/food/presentation/pages/all_items_page.dart';
import 'package:DairyVikas/features/food/presentation/pages/food_dealers_page.dart';
import 'package:DairyVikas/features/food/presentation/pages/food_sales_page.dart';
import 'package:DairyVikas/features/food/presentation/pages/food_stock_history_page.dart';
import 'package:DairyVikas/features/food/presentation/pages/food_stock_page.dart';
import 'package:DairyVikas/features/invoices/presentation/controllers/all_invoice_controller.dart';
import 'package:DairyVikas/features/invoices/presentation/controllers/invoice_details_controller.dart';
import 'package:DairyVikas/features/invoices/presentation/pages/all_invoices_page.dart';
import 'package:DairyVikas/features/invoices/presentation/pages/invoice_details_page.dart';
import 'package:DairyVikas/features/khata/presentation/controllers/add_khata_customer_controller.dart';
import 'package:DairyVikas/features/khata/presentation/controllers/all_khata_customers_controller.dart';
import 'package:DairyVikas/features/khata/presentation/pages/add_khata_customer.dart';
import 'package:DairyVikas/features/khata/presentation/pages/all_khata_customers.dart';
import 'package:DairyVikas/features/milk_sale/data/models/milk_buyer_model.dart';
import 'package:DairyVikas/features/milk_sale/data/models/milk_sale_model.dart';
import 'package:DairyVikas/features/milk_sale/presentation/controllers/add_milk_buyer_controller.dart';
import 'package:DairyVikas/features/milk_sale/presentation/controllers/add_milksale_controller.dart';
import 'package:DairyVikas/features/milk_sale/presentation/controllers/all_milk_sales_controller.dart';
import 'package:DairyVikas/features/milk_sale/presentation/pages/add_milk_buyer_page.dart';
import 'package:DairyVikas/features/milk_sale/presentation/pages/add_milksale_page.dart';
import 'package:DairyVikas/features/milk_sale/presentation/pages/all_milk_sales.dart';
import 'package:DairyVikas/features/milk_sale/presentation/pages/milk_buyers_page.dart';
import 'package:DairyVikas/features/milk_suppliers/data/model/milk_supplier_model.dart';
import 'package:DairyVikas/features/milk_suppliers/presentation/controllers/add_supplier_controller.dart';
import 'package:DairyVikas/features/milk_suppliers/presentation/controllers/get_milk_suppliers_controller.dart';
import 'package:DairyVikas/features/milk_suppliers/presentation/pages/add_new_milk_supplier.dart';
import 'package:DairyVikas/features/milk_suppliers/presentation/pages/milk_supplier_details_page.dart';
import 'package:DairyVikas/features/milk_suppliers/presentation/pages/milk_suppliers_page.dart';
import 'package:DairyVikas/features/notice_board/data/models/notice_post_model.dart';
import 'package:DairyVikas/features/notice_board/presentation/controllers/add_notice_post_controller.dart';
import 'package:DairyVikas/features/notice_board/presentation/pages/add_notice_post_page.dart';
import 'package:DairyVikas/features/notice_board/presentation/pages/notice_posts_page.dart';
import 'package:DairyVikas/features/plan_subscription/presentation/controllers/payment_cotnroller.dart';
import 'package:DairyVikas/features/plan_subscription/presentation/controllers/subscription_plan_controller.dart';
import 'package:DairyVikas/features/plan_subscription/presentation/controllers/transaction_history_controller.dart';
import 'package:DairyVikas/features/plan_subscription/presentation/pages/payment_page.dart';
import 'package:DairyVikas/features/plan_subscription/presentation/pages/subscription_plans_page.dart';
import 'package:DairyVikas/features/plan_subscription/presentation/pages/transaction_history.dart';
import 'package:DairyVikas/features/printing/presentation/controllers/scan_devices_controller.dart';
import 'package:DairyVikas/features/profile_and_settings/presentation/controllers/app_settings_controller.dart';
import 'package:DairyVikas/features/profile_and_settings/presentation/controllers/profile_controller.dart';
import 'package:DairyVikas/features/profile_and_settings/presentation/controllers/refer_and_earn_controller.dart';
import 'package:DairyVikas/features/profile_and_settings/presentation/pages/app_setting_page.dart'
    show AppSettingPage;
import 'package:DairyVikas/features/profile_and_settings/presentation/pages/profile_page.dart';
import 'package:DairyVikas/features/profile_and_settings/presentation/pages/refer_and_earn.dart';
import 'package:DairyVikas/features/rate_cart/presentation/controllers/add_rate_chart_controller.dart';
import 'package:DairyVikas/features/rate_cart/presentation/controllers/all_rate_charts_controllers.dart';
import 'package:DairyVikas/features/rate_cart/presentation/controllers/assign_chart_to_suppliers_controller.dart';
import 'package:DairyVikas/features/rate_cart/presentation/pages/add_rate_chart_page.dart';
import 'package:DairyVikas/features/rate_cart/presentation/pages/all_rate_charts_page.dart';
import 'package:DairyVikas/features/rate_cart/presentation/pages/assigned_chart_to_suppliers.dart';
import 'package:DairyVikas/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../core/local_datasources/app_state.dart';
import '../../features/auth/registration_flow/presentation/controllers/otp_verify_controller.dart'
    show OtpVerifyController;
import '../../features/auth/registration_flow/presentation/controllers/register_vendor_controller.dart';
import '../../features/collection/presentation/pages/all_collection_page.dart';
import '../../features/food/presentation/controllers/food_dealers_controller.dart';
import '../../features/khata/data/models/khatabook_user_model.dart';
import '../../features/khata/presentation/controllers/khata_entries_controller.dart';
import '../../features/khata/presentation/pages/khata_entries_page.dart';
import '../../features/printing/presentation/pages/scan_devices.dart';
import '../../features/rate_cart/data/model/rate_chart_model.dart';
import '../../features/rate_cart/presentation/controllers/rate_chart_details_controller.dart';
import '../../features/rate_cart/presentation/pages/rate_chart_details_page.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: LoginPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        onExit: (context, state) {
          Get.delete<ForgotPasswordController>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: ForgotPasswordPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.personalDetails,
        onExit: (context, state) {
          final controller = Get.find<RegisterVendorController>();
          controller.nameController.clear();
          controller.passwordController.clear();
          controller.phoneController.clear();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: RegisterVendorPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.verifyOtp,
        onExit: (context, state) {
          final controller = Get.find<OtpVerifyController>();
          controller.otpController.clear();
          return true;
        },
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          final phone = data?["phone"] ?? '';
          final message = data?["message"] ?? '';

          return CustomTransitionPage(
            key: state.pageKey,
            child: OtpVerifyPage(phoneNumber: phone, message: message),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: RouteNames.dairyCenterDetails,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          final isFromDashboard = data?["isFromDashboard"] ?? false;
          return CustomTransitionPage(
            key: state.pageKey,
            child: DairyCenterDetailsPage(isFromDashboard: isFromDashboard),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: RouteNames.dairyCenterSettings,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: DairyCenterSettingsPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.dashboard,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: DashboardPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.addRateChart,
        onExit: (context, state) {
          Get.delete<AddRateChartController>();
          AppState.isRateChartEdit = false;
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AddRateChartPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: RouteNames.allRateCharts,
        onExit: (context, state) {
          Get.delete<AllRateChartsController>();

          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AllRateChartsPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: RouteNames.rateChartDetails,
        onExit: (context, state) {
          Get.delete<RateChartDetailsController>();

          return true;
        },
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          final rateChart = data?["rate_chart"] as RateChartModel;
          return CustomTransitionPage(
            key: state.pageKey,
            child: RateChartDetailsPage(rateChart: rateChart),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.milkSuppliers,
        onExit: (context, state) {
          Get.delete<AllMilkSuppliersController>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AllMilkSuppliersPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: RouteNames.addMilkSupplier,
        onExit: (context, state) {
          Get.delete<AddMilkSupplierController>();

          AppState.isSupplierEdit = false;
          AppState.currentSupplierForUpdate = MilkSupplierModel.empty();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AddNewMilkSupplier(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: RouteNames.milkSupplierDetails,
        onExit: (context, state) {
          return true;
        },
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          final supplier = data?["supplier"] as MilkSupplierModel;
          return CustomTransitionPage(
            key: state.pageKey,
            child: MilkSupplierDetails(milkSupplier: supplier),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.assignedChartSuppliers,
        onExit: (context, state) {
          Get.delete<AssignChartToSuppliersController>();
          AppState.chartIdForassignablesupplierScreen = '';
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AssignedChartToSuppliers(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.addCollection,
        onExit: (context, state) {
          Get.delete<AddNewCollectionController>();
          AppState.isCollectionEdit = false;
          AppState.currentCollectionforUpdate = CollectionModel.empty();
          return true;
        },
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          final isfromCollectionList = data?["isfromCollectionList"];
          return CustomTransitionPage(
            key: state.pageKey,
            child: AddNewCollection(isfromCollectionList: isfromCollectionList),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.allCollection,
        onExit: (context, state) {
          Get.delete<AllCollectionController>();

          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AllCollectionPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.adjustCollection,
        onExit: (context, state) {
          Get.delete<AdjustCollectionController>();

          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AdjustCollectionPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.customerPdfSheet,
        onExit: (context, state) {
          Get.delete<AdjustCollectionController>();

          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: CustomerPdfSheet(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.allMilkSales,
        onExit: (context, state) {
          Get.delete<AllMilkSalesControllers>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AllMilkSalesPages(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.addMilkSale,
        onExit: (context, state) {
          Get.delete<AddMilksaleController>();
          AppState.currentMilkSaleforUpdate = MilkSaleModel.empty();
          AppState.isMilkSaleEdit = false;
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AddMilksalePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.milkBuyers,
        onExit: (context, state) {
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: MilkBuyersPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.addMilkBuyer,
        onExit: (context, state) {
          Get.delete<AddMilkBuyerController>();
          AppState.currentBuyerForUpdate = MilkBuyerModel.empty();
          AppState.isMilkBuyerEdit = false;
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AddMilkBuyerPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.addDealer,
        onExit: (context, state) {
          Get.delete<AddFoodDealerController>();
          AppState.currentDealerForUpdate = DealerModel.empty();
          AppState.isDealerEdit = false;
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AddFoodDealerPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.foodDealers,
        onExit: (context, state) {
          Get.delete<FoodDealersController>();

          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: FoodDealersPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.foodStocks,
        onExit: (context, state) {
          Get.delete<FoodStockController>();

          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: FoodStockPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.addFoodStock,
        onExit: (context, state) {
          Get.delete<AddFoodStockController>();
          AppState.currentStockHistoryItem = StockHistoryModel.empty();
          AppState.currentStockItem = StockHistoryModel.empty();
          AppState.isFoodStockEdit = false;
          return true;
        },
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          final isFromStockListing = data?["isFromStockListing"];
          return CustomTransitionPage(
            key: state.pageKey,
            child: AddFoodStockPage(isFromStockListing: isFromStockListing),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.addFoodSale,
        onExit: (context, state) {
          Get.delete<AddFoodSaleController>();
          AppState.isFoodSaleEdit = false;
          AppState.currentFoodSale = SaleModel.empty();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AddFoodSalePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.allItems,
        onExit: (context, state) {
          Get.delete<AllItemsController>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AllItemsPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.foodSales,
        onExit: (context, state) {
          Get.delete<FoodSalesController>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: FoodSalesPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.foodStockHistory,
        onExit: (context, state) {
          Get.delete<FoodStockHistoryController>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: FoodStockHistoryPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.noticePosts,
        onExit: (context, state) {
          Get.delete<FoodStockHistoryController>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: NoticePostsPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.addPost,
        onExit: (context, state) {
          Get.delete<AddNoticePostController>();
          AppState.isNoticePostEdit = false;
          AppState.currentNoticePostForUpdate = NoticeModel.empty();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AddNoticePostPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.allKhataCustomers,
        onExit: (context, state) {
          Get.delete<AllKhataCustomersController>();

          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AllKhataCustomers(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: RouteNames.addKhataCustomer,
        onExit: (context, state) {
          Get.delete<AddKhataCustomerController>();
          AppState.iskhataCustomerEdit = false;

          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AddKhataCustomer(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.khataEntries,
        onExit: (context, state) {
          Get.delete<KhataEntriesController>();
          AppState.currentKhataBookCustomerForUpdate =
              KhatabookUserModel.empty();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: KhataEntriesPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: RouteNames.allInvoices,
        onExit: (context, state) {
          Get.delete<AllInvoiceController>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AllInvoicesPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.invoiceDetails,
        onExit: (context, state) {
          Get.delete<InvoiceDetailsController>();
          return true;
        },
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          final showRemoveButton = data?["showRemoveButton"] ?? false;

          return CustomTransitionPage(
            key: state.pageKey,
            child: InvoiceDetailsPage(showRemoveButton: showRemoveButton),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.plans,
        onExit: (context, state) {
          Get.delete<SubscriptionPlanController>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: SubscriptionPlansPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.payment,

        onExit: (context, state) {
          Get.delete<PaymentCotnroller>();
          return true;
        },
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          final isPaymentSuccess = data?["isPaymentSuccess"] ?? false;

          return CustomTransitionPage(
            key: state.pageKey,
            child: PaymentPage(isPaymentSuccess: isPaymentSuccess),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.scanDevices,

        onExit: (context, state) {
          Get.delete<ScanDevicesController>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: ScanDevices(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.profile,

        onExit: (context, state) {
          Get.delete<ProfileController>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: ProfilePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: RouteNames.settings,

        onExit: (context, state) {
          Get.delete<AppSettingController>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: AppSettingPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.searchInApp,

        onExit: (context, state) {
          Get.delete<SearchInAppController>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: SearchInAppPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: RouteNames.transactionHistory,

        onExit: (context, state) {
          Get.delete<TransactionHistoryController>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: TransactionHistory(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: RouteNames.referAndEarn,

        onExit: (context, state) {
          Get.delete<ReferAndEarnController>();
          return true;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: ReferAndEarnPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
    ],
  );
}

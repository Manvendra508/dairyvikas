// lib/injection.dart
import 'package:dairysathi/common/common_controller.dart';
import 'package:dairysathi/core/local_datasources/secured_storage_service.dart';
import 'package:dairysathi/features/auth/login/data/datasources/login_vendor_ds.dart';
import 'package:dairysathi/features/auth/login/data/repos_impl/login_vendor_repo_impl.dart';
import 'package:dairysathi/features/auth/login/domain/repository/login_vendor_repo.dart';
import 'package:dairysathi/features/auth/login/domain/usecases/login_user_usecase.dart';
import 'package:dairysathi/features/auth/login/domain/usecases/reset_password_usecase.dart';
import 'package:dairysathi/features/auth/login/domain/usecases/send_otp_to_registred_number_usecase.dart';
import 'package:dairysathi/features/auth/login/domain/usecases/verify_forgot_password_otp_usecase.dart';
import 'package:dairysathi/features/auth/login/presentation/controllers/forgot_password_controller.dart';
import 'package:dairysathi/features/auth/login/presentation/controllers/login_controller.dart';
import 'package:dairysathi/features/auth/registration_flow/data/datasources/register_vendor_ds.dart';
import 'package:dairysathi/features/auth/registration_flow/data/repos_impl/register_vendor_impl.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/repository/register_vendor_repo.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/usecases/add_dairy_details_usecase.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/usecases/get_dairy_setting_data_usecase.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/usecases/register_vendor_usecase.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/usecases/resend_otp_usecase.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/usecases/verify_otp_usecase.dart';
import 'package:dairysathi/features/auth/registration_flow/presentation/controllers/dairy_center_details_controller.dart';
import 'package:dairysathi/features/auth/registration_flow/presentation/controllers/dairy_center_settings_controller.dart';
import 'package:dairysathi/features/auth/registration_flow/presentation/controllers/otp_verify_controller.dart';
import 'package:dairysathi/features/auth/registration_flow/presentation/controllers/register_vendor_controller.dart';
import 'package:dairysathi/features/collection/data/datasources/collection_ds.dart';
import 'package:dairysathi/features/collection/data/repos_impl/collection_repo_impl.dart';
import 'package:dairysathi/features/collection/domain/repository/collection_repo.dart';
import 'package:dairysathi/features/collection/domain/usecases/delete_collection_usecase.dart';
import 'package:dairysathi/features/collection/domain/usecases/get_all_collection_usecase.dart';
import 'package:dairysathi/features/collection/domain/usecases/get_assigned_charts_usecase.dart';
import 'package:dairysathi/features/collection/domain/usecases/get_collection_adjusments_usecase.dart';
import 'package:dairysathi/features/collection/domain/usecases/get_date_range_usecase.dart';
import 'package:dairysathi/features/collection/domain/usecases/update_collection_usecase.dart';
import 'package:dairysathi/features/collection/domain/usecases/update_milk_sale_usecase.dart';
import 'package:dairysathi/features/collection/presentation/controllers/add_collection_controller.dart';
import 'package:dairysathi/features/collection/presentation/controllers/adjust_collection_controller.dart';
import 'package:dairysathi/features/collection/presentation/controllers/all_collection_controller.dart';
import 'package:dairysathi/features/collection/presentation/controllers/customer_pdf_sheet_controller.dart';
import 'package:dairysathi/features/dashboard/data/datasources/dashboard_data_ds.dart';
import 'package:dairysathi/features/dashboard/data/repos_impl/dashboard_data_repo_impl.dart';
import 'package:dairysathi/features/dashboard/domain/repository/dashboard_data_repo.dart';
import 'package:dairysathi/features/dashboard/domain/usecases/fetch_dashboard_data_usecase.dart';
import 'package:dairysathi/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:dairysathi/features/dashboard/presentation/controllers/search_in_app_controller.dart';
import 'package:dairysathi/features/food/data/datasources/food_datasource.dart';
import 'package:dairysathi/features/food/data/repo_impls/food_repo_impls.dart';
import 'package:dairysathi/features/food/domain/repository/food_repo.dart';
import 'package:dairysathi/features/food/domain/usecases/add_food_dealer_usecase.dart';
import 'package:dairysathi/features/food/domain/usecases/add_food_sale_usecase.dart';
import 'package:dairysathi/features/food/domain/usecases/add_food_stock_usecase.dart';
import 'package:dairysathi/features/food/domain/usecases/get_food_dealers_usecase.dart';
import 'package:dairysathi/features/food/domain/usecases/get_food_sales_usecase.dart'
    show GetFoodSalesUsecase;
import 'package:dairysathi/features/food/domain/usecases/get_units_usecase.dart';
import 'package:dairysathi/features/food/domain/usecases/update_food_dealer_usecase.dart';
import 'package:dairysathi/features/food/domain/usecases/update_food_stock_usecase.dart';
import 'package:dairysathi/features/food/domain/usecases/update_sale_usecase.dart';
import 'package:dairysathi/features/food/presentation/controllers/add_food_dealer_controller.dart';
import 'package:dairysathi/features/food/presentation/controllers/add_food_sale_controller.dart';
import 'package:dairysathi/features/food/presentation/controllers/add_food_stock_controller.dart';
import 'package:dairysathi/features/food/presentation/controllers/food_dealers_controller.dart';
import 'package:dairysathi/features/food/presentation/controllers/food_sales_controller.dart';
import 'package:dairysathi/features/food/presentation/controllers/food_stock_controller.dart';
import 'package:dairysathi/features/food/presentation/controllers/food_stock_history_controller.dart';
import 'package:dairysathi/features/food/presentation/controllers/get_all_items_controller.dart';
import 'package:dairysathi/features/invoices/data/datasources/invoice_ds.dart';
import 'package:dairysathi/features/invoices/data/repos_impl/invoice_repo_impl.dart';
import 'package:dairysathi/features/invoices/domain/repository/invoice_repo.dart';
import 'package:dairysathi/features/invoices/domain/usecases/delete_invoice_usecase.dart';
import 'package:dairysathi/features/invoices/domain/usecases/genrate_invoice_usecase.dart';
import 'package:dairysathi/features/invoices/domain/usecases/get_all_invoices_usecase.dart';
import 'package:dairysathi/features/invoices/domain/usecases/get_invoice_details_usecase.dart';
import 'package:dairysathi/features/invoices/domain/usecases/mark_paid_invoice_usecase.dart';
import 'package:dairysathi/features/invoices/domain/usecases/mark_unpaid_invoice.dart';
import 'package:dairysathi/features/invoices/presentation/controllers/all_invoice_controller.dart';
import 'package:dairysathi/features/invoices/presentation/controllers/invoice_details_controller.dart';
import 'package:dairysathi/features/khata/data/datasources/khata_datasource.dart';
import 'package:dairysathi/features/khata/domain/repository/khata_repo.dart';
import 'package:dairysathi/features/khata/presentation/controllers/add_khata_customer_controller.dart';
import 'package:dairysathi/features/khata/presentation/controllers/all_khata_customers_controller.dart';
import 'package:dairysathi/features/khata/presentation/controllers/khata_entries_controller.dart';
import 'package:dairysathi/features/milk_sale/data/datasources/milk_sale_ds.dart';
import 'package:dairysathi/features/milk_sale/data/repo_impls/milk_sale_repo_impl.dart';
import 'package:dairysathi/features/milk_sale/domain/repository/milk_buyer_repo.dart';
import 'package:dairysathi/features/milk_sale/domain/usecases/add_milk_sale_usecase.dart';
import 'package:dairysathi/features/milk_sale/domain/usecases/delete_milk_buyer_usecase.dart';
import 'package:dairysathi/features/milk_sale/domain/usecases/get_all_milk_buyers_usecase.dart';
import 'package:dairysathi/features/milk_sale/domain/usecases/get_all_milksales_usecase.dart';
import 'package:dairysathi/features/milk_sale/domain/usecases/update_buyer_status_usecase.dart';
import 'package:dairysathi/features/milk_sale/domain/usecases/update_milk_buyer_usecase.dart';
import 'package:dairysathi/features/milk_sale/presentation/controllers/add_milk_buyer_controller.dart';
import 'package:dairysathi/features/milk_sale/presentation/controllers/add_milksale_controller.dart';
import 'package:dairysathi/features/milk_sale/presentation/controllers/milk_buyers_controller.dart';
import 'package:dairysathi/features/milk_suppliers/data/datasources/milk_supplier_ds.dart';
import 'package:dairysathi/features/milk_suppliers/data/repos_impl/milk_supplier_repo_impl.dart';
import 'package:dairysathi/features/milk_suppliers/domain/repository/milk_supplier_repo.dart';
import 'package:dairysathi/features/milk_suppliers/domain/usecases/add_milk_supplier_usecase.dart';
import 'package:dairysathi/features/milk_suppliers/domain/usecases/delete_milk_supplier_usecase.dart';
import 'package:dairysathi/features/milk_suppliers/domain/usecases/get_all_milk_suppliers_usecase.dart';
import 'package:dairysathi/features/milk_suppliers/domain/usecases/update_milk_suppliers_usecase.dart';
import 'package:dairysathi/features/milk_suppliers/domain/usecases/update_supplier_status_usecase.dart';
import 'package:dairysathi/features/milk_suppliers/presentation/controllers/add_supplier_controller.dart';
import 'package:dairysathi/features/milk_suppliers/presentation/controllers/get_milk_suppliers_controller.dart';
import 'package:dairysathi/features/notice_board/data/datasources/notice_ds.dart';
import 'package:dairysathi/features/notice_board/data/repo_impls/notice_board_repo_impl.dart';
import 'package:dairysathi/features/notice_board/domain/repository/notice_board_repo.dart';
import 'package:dairysathi/features/notice_board/domain/usecases/delete_notice_post_usecase.dart';
import 'package:dairysathi/features/notice_board/domain/usecases/get_notices_posts_usecase.dart';
import 'package:dairysathi/features/notice_board/domain/usecases/update_notice_usecase.dart';
import 'package:dairysathi/features/notice_board/presentation/controllers/add_notice_post_controller.dart';
import 'package:dairysathi/features/notice_board/presentation/controllers/notice_posts_controller.dart';
import 'package:dairysathi/features/plan_subscription/data/datasources/subscription_plan_ds.dart';
import 'package:dairysathi/features/plan_subscription/data/repos_impl/subscription_plan_repo_impl.dart';
import 'package:dairysathi/features/plan_subscription/domain/repository/subscription_plan_repo.dart';
import 'package:dairysathi/features/plan_subscription/presentation/controllers/payment_cotnroller.dart';
import 'package:dairysathi/features/plan_subscription/presentation/controllers/subscription_plan_controller.dart';
import 'package:dairysathi/features/plan_subscription/presentation/controllers/transaction_history_controller.dart';
import 'package:dairysathi/features/printing/presentation/controllers/scan_devices_controller.dart';
import 'package:dairysathi/features/profile_and_settings/data/datasources/app_setting_ds.dart';
import 'package:dairysathi/features/profile_and_settings/domain/repository/app_setting_repo.dart'
    show AppSettingRepo;
import 'package:dairysathi/features/profile_and_settings/domain/usecases/get_current_plan_usecase.dart';
import 'package:dairysathi/features/profile_and_settings/domain/usecases/update_dairy_name_usecase.dart';
import 'package:dairysathi/features/profile_and_settings/domain/usecases/update_dairy_setting_usecase.dart';
import 'package:dairysathi/features/profile_and_settings/presentation/controllers/app_settings_controller.dart';
import 'package:dairysathi/features/profile_and_settings/presentation/controllers/profile_controller.dart';
import 'package:dairysathi/features/rate_cart/data/datasources/rate_chart_ds.dart';
import 'package:dairysathi/features/rate_cart/data/repos_impl/rate_chart_repo_impl.dart';
import 'package:dairysathi/features/rate_cart/domain/repository/rate_chart_repo.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/aasign_chart_to_suppliers_usecase.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/active_inactive_chart_usecase.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/add_ratechart_usecase.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/assign_chart_to_dairy_usecase.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/delete_rate_chart_usecase.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/get_all_assignable_suppliers_usecase.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/get_all_rate_charts_usecase.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/rate_chart_details_usecase.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/unassign_chart_to_suppliers_usecase.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/unassign_ratechart_dairy_usecase.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/update_rate_chart_usecase.dart';
import 'package:dairysathi/features/rate_cart/domain/usecases/upload_excel_usecase.dart';
import 'package:dairysathi/features/rate_cart/presentation/controllers/add_rate_chart_controller.dart';
import 'package:dairysathi/features/rate_cart/presentation/controllers/all_rate_charts_controllers.dart';
import 'package:dairysathi/features/rate_cart/presentation/controllers/assign_chart_to_suppliers_controller.dart';
import 'package:dairysathi/features/rate_cart/presentation/controllers/rate_chart_common_function.dart';
import 'package:dairysathi/features/rate_cart/presentation/controllers/rate_chart_details_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../core/local_datasources/local_storage_service.dart';
import '../../core/network/dio_client.dart';
import '../../features/collection/domain/usecases/add_collection_usecase.dart';
import '../../features/food/domain/usecases/add_item_usecase.dart';
import '../../features/food/domain/usecases/get_all_items_usecase.dart';
import '../../features/food/domain/usecases/get_food_stock_history_usecase.dart';
import '../../features/food/domain/usecases/get_food_stock_usecase.dart';
import '../../features/food/domain/usecases/update_item_usecase.dart';
import '../../features/khata/data/repo_impls/khata_repo_impl.dart';
import '../../features/khata/domain/usecases/add_entry_usecase.dart';
import '../../features/khata/domain/usecases/add_khata_customer_usecase.dart';
import '../../features/khata/domain/usecases/delete_entry_usecase.dart';
import '../../features/khata/domain/usecases/delete_khatacustomer_usecase.dart';
import '../../features/khata/domain/usecases/get_entries_by_user_usecase.dart';
import '../../features/khata/domain/usecases/get_khatabook_customers.dart';
import '../../features/khata/domain/usecases/update_entry_usecase.dart';
import '../../features/khata/domain/usecases/update_khatacustomer_usecase.dart';
import '../../features/milk_sale/domain/usecases/add_milk_buyer_usecase.dart';
import '../../features/milk_sale/presentation/controllers/all_milk_sales_controller.dart';
import '../../features/milk_suppliers/presentation/controllers/milk_supplier_details_controller.dart';
import '../../features/notice_board/domain/usecases/add_notice_post_usecase.dart';
import '../../features/plan_subscription/domain/usecases/get_all_plans.dart';
import '../../features/plan_subscription/domain/usecases/get_orderId_uecase.dart';
import '../../features/plan_subscription/domain/usecases/get_transaction_history_usecase.dart';
import '../../features/plan_subscription/domain/usecases/verify_payment_usecase.dart';
import '../../features/profile_and_settings/data/repos_impl/app_setting_repo_impl.dart';
import '../../features/profile_and_settings/domain/usecases/get_existing_setting_data_usecase.dart';

class Injection {
  static Future<void> init() async {
    final local = SharedPrefsService.instance;
    final secureStorage = SecureStorage.instance;
    await secureStorage.init();
    await local.init();

    Get.put<SharedPrefsService>(local, permanent: true);

    Get.lazyPut<Dio>(() => DioClient().dio);

    //----------------------------------data layer--------------------------------------
    Get.lazyPut(() => RegisterVendorRemoteDataSource(Get.find<Dio>()));
    Get.lazyPut(() => DashboardRemoteDataSource(Get.find<Dio>()));
    Get.lazyPut(() => LoginVendorRemoteDataSource(Get.find<Dio>()));
    Get.lazyPut(() => RateChartDataSource(Get.find<Dio>()));
    Get.lazyPut(() => MilkSupplierDataSource(Get.find<Dio>()));
    Get.lazyPut(() => CollectionDataSource(Get.find<Dio>()));
    Get.lazyPut(() => MilkSaleDataSource(Get.find<Dio>()));
    Get.lazyPut(() => FoodDatasource(Get.find<Dio>()));
    Get.lazyPut(() => NoticeDataSource(Get.find<Dio>()));
    Get.lazyPut(() => KhataDatasource(Get.find<Dio>()));
    Get.lazyPut(() => InvoiceDs(Get.find<Dio>()));
    Get.lazyPut(() => SubscriptionPlanDs(Get.find<Dio>()));
    Get.lazyPut(() => AppSettingDs(Get.find<Dio>()));
    Get.lazyPut<RegisterVendorRepo>(
      () => RegisterVendorImpl(Get.find<RegisterVendorRemoteDataSource>()),
    );
    Get.lazyPut<LoginVendorRepo>(
      () => LoginVendorRepoImpl(Get.find<LoginVendorRemoteDataSource>()),
    );
    Get.lazyPut<DashboardDataRepo>(
      () => DashboardDataRepoImpl(Get.find<DashboardRemoteDataSource>()),
    );

    Get.lazyPut<RateChartRepo>(
      () => RateChartRepoImpl(Get.find<RateChartDataSource>()),
    );

    Get.lazyPut<MilkSupplierRepo>(
      () => MilkSupplierRepoImpl(Get.find<MilkSupplierDataSource>()),
    );

    Get.lazyPut<CollectionRepo>(
      () => CollectionRepoImpl(Get.find<CollectionDataSource>()),
    );

    Get.lazyPut<MilkSaleRepo>(
      () => MilkBuyerRepoImpl(Get.find<MilkSaleDataSource>()),
    );

    Get.lazyPut<FoodRepo>(() => FoodRepoImpls(Get.find<FoodDatasource>()));

    Get.lazyPut<NoticeBoardRepo>(
      () => NoticeBoardRepoImpl(Get.find<NoticeDataSource>()),
    );
    Get.lazyPut<KhataRepo>(() => KhataRepoImpl(Get.find<KhataDatasource>()));
    Get.lazyPut<InvoiceRepo>(() => InvoiceRepoImpl(Get.find<InvoiceDs>()));
    Get.lazyPut<SubscriptionPlanRepo>(
      () => SubscriptionPlanRepoImpl(Get.find<SubscriptionPlanDs>()),
    );
    Get.lazyPut<AppSettingRepo>(
      () => AppSettingRepoImpl(Get.find<AppSettingDs>()),
    );

    // --------------------------------domain layer---------------------------------------
    Get.lazyPut<RegisterVendorUsecase>(
      () => RegisterVendorUsecase(Get.find<RegisterVendorRepo>()),
    );
    Get.lazyPut<VerifyOtpUsecase>(
      () => VerifyOtpUsecase(Get.find<RegisterVendorRepo>()),
    );

    Get.lazyPut<ResendOtpUsecase>(
      () => ResendOtpUsecase(Get.find<RegisterVendorRepo>()),
    );
    Get.lazyPut<AddDairyDetailsUsecase>(
      () => AddDairyDetailsUsecase(Get.find<RegisterVendorRepo>()),
    );
    Get.lazyPut<GetDairySettingDataUsecase>(
      () => GetDairySettingDataUsecase(Get.find<RegisterVendorRepo>()),
    );
    Get.lazyPut<LoginVendorUsecase>(
      () => LoginVendorUsecase(Get.find<LoginVendorRepo>()),
    );
    Get.lazyPut<ResetPasswordUsecase>(
      () => ResetPasswordUsecase(Get.find<LoginVendorRepo>()),
    );

    Get.lazyPut<SendOtpForForgotPassowrdUsecase>(
      () => SendOtpForForgotPassowrdUsecase(Get.find<LoginVendorRepo>()),
    );

    Get.lazyPut<VerifyForgotPasswordOtpUsecase>(
      () => VerifyForgotPasswordOtpUsecase(Get.find<LoginVendorRepo>()),
    );
    Get.lazyPut<FetchDashboardDataUsecase>(
      () => FetchDashboardDataUsecase(Get.find<DashboardDataRepo>()),
    );

    Get.lazyPut<AddRatechartUsecase>(
      () => AddRatechartUsecase(Get.find<RateChartRepo>()),
    );

    Get.lazyPut<GetAllRateChartsUsecase>(
      () => GetAllRateChartsUsecase(Get.find<RateChartRepo>()),
    );
    Get.lazyPut<UpdateRateChartUsecase>(
      () => UpdateRateChartUsecase(Get.find<RateChartRepo>()),
    );
    Get.lazyPut<AddMilkSupplierUsecase>(
      () => AddMilkSupplierUsecase(Get.find<MilkSupplierRepo>()),
    );

    Get.lazyPut<GetAllMilkSuppliersUsecase>(
      () => GetAllMilkSuppliersUsecase(Get.find<MilkSupplierRepo>()),
    );

    Get.lazyPut<UpdateMilkSuppliersUsecase>(
      () => UpdateMilkSuppliersUsecase(Get.find<MilkSupplierRepo>()),
    );
    Get.lazyPut<DeleteMilkSupplierUsecase>(
      () => DeleteMilkSupplierUsecase(Get.find<MilkSupplierRepo>()),
    );

    Get.lazyPut<UpdateSupplierStatusUsecase>(
      () => UpdateSupplierStatusUsecase(Get.find<MilkSupplierRepo>()),
    );
    Get.lazyPut<RateChartDetailsUsecase>(
      () => RateChartDetailsUsecase(Get.find<RateChartRepo>()),
    );

    Get.lazyPut<AssignChartToDairyUsecase>(
      () => AssignChartToDairyUsecase(Get.find<RateChartRepo>()),
    );
    Get.lazyPut<DeleteRatechartUsecase>(
      () => DeleteRatechartUsecase(Get.find<RateChartRepo>()),
    );
    Get.lazyPut<UploadExcelUsecase>(
      () => UploadExcelUsecase(Get.find<RateChartRepo>()),
    );

    Get.lazyPut<GetAllAssignableSuppliersUsecase>(
      () => GetAllAssignableSuppliersUsecase(Get.find<RateChartRepo>()),
    );

    Get.lazyPut<AssignChartToSuppliersUsecase>(
      () => AssignChartToSuppliersUsecase(Get.find<RateChartRepo>()),
    );

    Get.lazyPut<UnassignRatechartDairyUsecase>(
      () => UnassignRatechartDairyUsecase(Get.find<RateChartRepo>()),
    );
    Get.lazyPut<UnassignChartToSuppliersUsecase>(
      () => UnassignChartToSuppliersUsecase(Get.find<RateChartRepo>()),
    );

    Get.lazyPut<ActiveInactiveChartUsecase>(
      () => ActiveInactiveChartUsecase(Get.find<RateChartRepo>()),
    );

    Get.lazyPut<GetAllssignedChartsUsecase>(
      () => GetAllssignedChartsUsecase(Get.find<CollectionRepo>()),
    );
    Get.lazyPut<AddCollectionUsecase>(
      () => AddCollectionUsecase(Get.find<CollectionRepo>()),
    );
    Get.lazyPut<UpdateCollectionUsecase>(
      () => UpdateCollectionUsecase(Get.find<CollectionRepo>()),
    );

    Get.lazyPut<GetAllCollectionUsecase>(
      () => GetAllCollectionUsecase(Get.find<CollectionRepo>()),
    );

    Get.lazyPut<GetCollectionAdjusmentsUsecase>(
      () => GetCollectionAdjusmentsUsecase(Get.find<CollectionRepo>()),
    );
    Get.lazyPut<GetDateRangeUsecase>(
      () => GetDateRangeUsecase(Get.find<CollectionRepo>()),
    );
    Get.lazyPut<DeleteCollectionUsecase>(
      () => DeleteCollectionUsecase(Get.find<CollectionRepo>()),
    );

    Get.lazyPut<AddMilkBuyerUsecase>(
      () => AddMilkBuyerUsecase(Get.find<MilkSaleRepo>()),
    );

    Get.lazyPut<GetAllMilkBuyersUsecase>(
      () => GetAllMilkBuyersUsecase(Get.find<MilkSaleRepo>()),
    );

    Get.lazyPut<UpdateMilkBuyerStatusUsecase>(
      () => UpdateMilkBuyerStatusUsecase(Get.find<MilkSaleRepo>()),
    );

    Get.lazyPut<UpdateMilkBuyerUsecase>(
      () => UpdateMilkBuyerUsecase(Get.find<MilkSaleRepo>()),
    );

    Get.lazyPut<DeleteMilkBuyerUsecase>(
      () => DeleteMilkBuyerUsecase(Get.find<MilkSaleRepo>()),
    );

    Get.lazyPut<AddMilkSaleUsecase>(
      () => AddMilkSaleUsecase(Get.find<MilkSaleRepo>()),
    );

    Get.lazyPut<GetAllMilksalesUsecase>(
      () => GetAllMilksalesUsecase(Get.find<MilkSaleRepo>()),
    );

    Get.lazyPut<UpdateMilkSaleUsecase>(
      () => UpdateMilkSaleUsecase(Get.find<MilkSaleRepo>()),
    );

    Get.lazyPut<AddFoodDealerUsecase>(
      () => AddFoodDealerUsecase(Get.find<FoodRepo>()),
    );
    Get.lazyPut<UpdateFoodDealerUsecase>(
      () => UpdateFoodDealerUsecase(Get.find<FoodRepo>()),
    );
    Get.lazyPut<GetFoodDealersUsecase>(
      () => GetFoodDealersUsecase(Get.find<FoodRepo>()),
    );
    Get.lazyPut<GetAllItemsUsecase>(
      () => GetAllItemsUsecase(Get.find<FoodRepo>()),
    );

    Get.lazyPut<AddItemUsecase>(() => AddItemUsecase(Get.find<FoodRepo>()));
    Get.lazyPut<UpdateItemUsecase>(
      () => UpdateItemUsecase(Get.find<FoodRepo>()),
    );

    Get.lazyPut<AddFoodStockUsecase>(
      () => AddFoodStockUsecase(Get.find<FoodRepo>()),
    );

    Get.lazyPut<GetFoodStockUsecase>(
      () => GetFoodStockUsecase(Get.find<FoodRepo>()),
    );

    Get.lazyPut<AddFoodSaleUsecase>(
      () => AddFoodSaleUsecase(Get.find<FoodRepo>()),
    );

    Get.lazyPut<GetFoodStockHistoryUsecase>(
      () => GetFoodStockHistoryUsecase(Get.find<FoodRepo>()),
    );

    Get.lazyPut<UpdateFoodStockUsecase>(
      () => UpdateFoodStockUsecase(Get.find<FoodRepo>()),
    );

    Get.lazyPut<GetFoodSalesUsecase>(
      () => GetFoodSalesUsecase(Get.find<FoodRepo>()),
    );

    Get.lazyPut<UpdateSaleUsecase>(
      () => UpdateSaleUsecase(Get.find<FoodRepo>()),
    );

    Get.lazyPut<GetUnitsUsecase>(() => GetUnitsUsecase(Get.find<FoodRepo>()));
    Get.lazyPut<AddNoticePostUsecase>(
      () => AddNoticePostUsecase(Get.find<NoticeBoardRepo>()),
    );
    Get.lazyPut<UpdateNoticeUsecase>(
      () => UpdateNoticeUsecase(Get.find<NoticeBoardRepo>()),
    );
    Get.lazyPut<GetNoticesPostsUsecase>(
      () => GetNoticesPostsUsecase(Get.find<NoticeBoardRepo>()),
    );
    Get.lazyPut<DeleteNoticePostUsecase>(
      () => DeleteNoticePostUsecase(Get.find<NoticeBoardRepo>()),
    );

    Get.lazyPut<AddKhataCustomerUsecase>(
      () => AddKhataCustomerUsecase(Get.find<KhataRepo>()),
    );
    Get.lazyPut<UpdateKhatacustomerUsecase>(
      () => UpdateKhatacustomerUsecase(Get.find<KhataRepo>()),
    );
    Get.lazyPut<DeleteKhatacustomerUsecase>(
      () => DeleteKhatacustomerUsecase(Get.find<KhataRepo>()),
    );
    Get.lazyPut<GetKhatabookCustomersUseCase>(
      () => GetKhatabookCustomersUseCase(Get.find<KhataRepo>()),
    );
    Get.lazyPut<GetEntriesByUserUsecase>(
      () => GetEntriesByUserUsecase(Get.find<KhataRepo>()),
    );
    Get.lazyPut<AddEntryUsecase>(() => AddEntryUsecase(Get.find<KhataRepo>()));
    Get.lazyPut<UpdateEntryUsecase>(
      () => UpdateEntryUsecase(Get.find<KhataRepo>()),
    );
    Get.lazyPut<DeleteEntryUsecase>(
      () => DeleteEntryUsecase(Get.find<KhataRepo>()),
    );
    Get.lazyPut<GetAllInvoicesUsecase>(
      () => GetAllInvoicesUsecase(Get.find<InvoiceRepo>()),
    );

    Get.lazyPut<GenrateInvoiceUsecase>(
      () => GenrateInvoiceUsecase(Get.find<InvoiceRepo>()),
    );
    Get.lazyPut<DeleteInvoiceUsecase>(
      () => DeleteInvoiceUsecase(Get.find<InvoiceRepo>()),
    );

    Get.lazyPut<GetInvoiceDetailsUsecase>(
      () => GetInvoiceDetailsUsecase(Get.find<InvoiceRepo>()),
    );

    Get.lazyPut<MarkPaidInvoiceUsecase>(
      () => MarkPaidInvoiceUsecase(Get.find<InvoiceRepo>()),
    );
    Get.lazyPut<MarkUnpaidInvoiceUseCase>(
      () => MarkUnpaidInvoiceUseCase(Get.find<InvoiceRepo>()),
    );
    Get.lazyPut<GetAllSubscriptionPlansUsecase>(
      () => GetAllSubscriptionPlansUsecase(Get.find<SubscriptionPlanRepo>()),
    );
    Get.lazyPut<GetOrderidUecase>(
      () => GetOrderidUecase(Get.find<SubscriptionPlanRepo>()),
    );
    Get.lazyPut<VerifyPaymentUsecase>(
      () => VerifyPaymentUsecase(Get.find<SubscriptionPlanRepo>()),
    );
    Get.lazyPut<GetTransactionHistoryUsecase>(
      () => GetTransactionHistoryUsecase(Get.find<SubscriptionPlanRepo>()),
    );
    Get.lazyPut<GetExistingSettingDataUsecase>(
      () => GetExistingSettingDataUsecase(Get.find<AppSettingRepo>()),
    );

    Get.lazyPut<UpdateDairySettingUsecase>(
      () => UpdateDairySettingUsecase(Get.find<AppSettingRepo>()),
    );
    Get.lazyPut<UpdateVendorNameUsecase>(
      () => UpdateVendorNameUsecase(Get.find<AppSettingRepo>()),
    );
    Get.lazyPut<GetCurrentPlanUsecase>(
      () => GetCurrentPlanUsecase(Get.find<AppSettingRepo>()),
    );

    // -----------------------------------Controllers (auto available for GetView)-------------------------------------
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<LoginVendorUsecase>()),
      fenix: true,
    );

    Get.lazyPut<CommonController>(
      () => CommonController(
        Get.find<GetAllMilkSuppliersUsecase>(),
        Get.find<GetDateRangeUsecase>(),
        Get.find<GetDairySettingDataUsecase>(),
        Get.find<GetExistingSettingDataUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(
        Get.find<SendOtpForForgotPassowrdUsecase>(),
        Get.find<VerifyForgotPasswordOtpUsecase>(),
        Get.find<ResetPasswordUsecase>(),
      ),
      fenix: true,
    );
    Get.lazyPut<RegisterVendorController>(
      () => RegisterVendorController(Get.find<RegisterVendorUsecase>()),
      fenix: true,
    );
    Get.lazyPut<DairyCenterDetailsController>(
      () => DairyCenterDetailsController(),
      fenix: true,
    );
    Get.lazyPut<DairyCenterSettingsController>(
      () => DairyCenterSettingsController(
        Get.find<AddDairyDetailsUsecase>(),
        Get.find<GetDairySettingDataUsecase>(),
      ),
      fenix: true,
    );
    Get.lazyPut<DashboardController>(
      () => DashboardController(Get.find<FetchDashboardDataUsecase>()),
      fenix: true,
    );
    Get.lazyPut<OtpVerifyController>(
      () => OtpVerifyController(
        Get.find<VerifyOtpUsecase>(),
        Get.find<ResendOtpUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AddRateChartController>(
      () => AddRateChartController(
        Get.find<AddRatechartUsecase>(),
        Get.find<GetDairySettingDataUsecase>(),
        Get.find<UpdateRateChartUsecase>(),
        Get.find<UploadExcelUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<RateChartCommonFunctionController>(
      () => RateChartCommonFunctionController(),
      fenix: true,
    );
    Get.lazyPut<AllRateChartsController>(
      () => AllRateChartsController(
        Get.find<GetAllRateChartsUsecase>(),
        Get.find<AssignChartToDairyUsecase>(),
        Get.find<UnassignRatechartDairyUsecase>(),
      ),
      fenix: true,
    );
    Get.lazyPut<RateChartDetailsController>(
      () => RateChartDetailsController(
        Get.find<GetAllRateChartsUsecase>(),
        Get.find<RateChartDetailsUsecase>(),
        Get.find<DeleteRatechartUsecase>(),
        Get.find<ActiveInactiveChartUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AllMilkSuppliersController>(
      () => AllMilkSuppliersController(
        Get.find<GetAllMilkSuppliersUsecase>(),
        Get.find<UpdateSupplierStatusUsecase>(),
      ),
      fenix: true,
    );
    Get.lazyPut<AddMilkSupplierController>(
      () => AddMilkSupplierController(
        Get.find<AddMilkSupplierUsecase>(),
        Get.find<UpdateMilkSuppliersUsecase>(),
      ),
      fenix: true,
    );
    Get.lazyPut<MilkSupplierDetailsController>(
      () =>
          MilkSupplierDetailsController(Get.find<DeleteMilkSupplierUsecase>()),
      fenix: true,
    );

    Get.lazyPut<AssignChartToSuppliersController>(
      () => AssignChartToSuppliersController(
        Get.find<GetAllAssignableSuppliersUsecase>(),
        Get.find<AssignChartToSuppliersUsecase>(),
        Get.find<UnassignChartToSuppliersUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AddNewCollectionController>(
      () => AddNewCollectionController(
        Get.find<GetAllssignedChartsUsecase>(),
        Get.find<GetAllMilkSuppliersUsecase>(),
        Get.find<AddCollectionUsecase>(),
        Get.find<UpdateCollectionUsecase>(),
        Get.find<DeleteCollectionUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AllCollectionController>(
      () => AllCollectionController(Get.find<GetAllCollectionUsecase>()),
      fenix: true,
    );

    Get.lazyPut<AdjustCollectionController>(
      () => AdjustCollectionController(
        Get.find<GetCollectionAdjusmentsUsecase>(),

        Get.find<GetAllMilkSuppliersUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<CustomerPdfSheetController>(
      () => CustomerPdfSheetController(),
      fenix: true,
    );

    Get.lazyPut<AllMilkSalesControllers>(
      () => AllMilkSalesControllers(Get.find<GetAllMilksalesUsecase>()),
      fenix: true,
    );

    Get.lazyPut<AddMilksaleController>(
      () => AddMilksaleController(
        Get.find<GetAllssignedChartsUsecase>(),
        Get.find<GetAllMilkBuyersUsecase>(),
        Get.find<AddMilkSaleUsecase>(),
        Get.find<UpdateMilkSaleUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<MilkBuyersController>(
      () => MilkBuyersController(
        Get.find<GetAllMilkBuyersUsecase>(),
        Get.find<UpdateMilkBuyerStatusUsecase>(),
        Get.find<DeleteMilkBuyerUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AddMilkBuyerController>(
      () => AddMilkBuyerController(
        Get.find<AddMilkBuyerUsecase>(),
        Get.find<UpdateMilkBuyerUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AddFoodDealerController>(
      () => AddFoodDealerController(
        Get.find<AddFoodDealerUsecase>(),
        Get.find<UpdateFoodDealerUsecase>(),
      ),
      fenix: true,
    );
    Get.lazyPut<FoodDealersController>(
      () => FoodDealersController(Get.find<GetFoodDealersUsecase>()),
      fenix: true,
    );

    Get.lazyPut<FoodStockController>(
      () => FoodStockController(Get.find<GetFoodStockUsecase>()),
      fenix: true,
    );

    Get.lazyPut<AddFoodStockController>(
      () => AddFoodStockController(
        Get.find<AddFoodStockUsecase>(),
        Get.find<GetFoodDealersUsecase>(),
        Get.find<UpdateFoodStockUsecase>(),
        Get.find<GetUnitsUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AddFoodSaleController>(
      () => AddFoodSaleController(
        Get.find<UpdateSaleUsecase>(),
        Get.find<GetAllMilkBuyersUsecase>(),
        Get.find<GetFoodStockUsecase>(),
        Get.find<AddFoodSaleUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AllItemsController>(
      () => AllItemsController(
        Get.find<GetAllItemsUsecase>(),
        Get.find<AddItemUsecase>(),
        Get.find<UpdateItemUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<FoodSalesController>(
      () => FoodSalesController(Get.find<GetFoodSalesUsecase>()),
      fenix: true,
    );

    Get.lazyPut<FoodStockHistoryController>(
      () => FoodStockHistoryController(Get.find<GetFoodStockHistoryUsecase>()),
      fenix: true,
    );

    Get.lazyPut<NoticePostsController>(
      () => NoticePostsController(Get.find<GetNoticesPostsUsecase>()),
      fenix: true,
    );

    Get.lazyPut<AddNoticePostController>(
      () => AddNoticePostController(
        Get.find<AddNoticePostUsecase>(),
        Get.find<UpdateNoticeUsecase>(),
        Get.find<DeleteNoticePostUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AllKhataCustomersController>(
      () =>
          AllKhataCustomersController(Get.find<GetKhatabookCustomersUseCase>()),
      fenix: true,
    );

    Get.lazyPut<AddKhataCustomerController>(
      () => AddKhataCustomerController(
        Get.find<AddKhataCustomerUsecase>(),
        Get.find<UpdateKhatacustomerUsecase>(),
        Get.find<DeleteKhatacustomerUsecase>(),
      ),

      fenix: true,
    );

    Get.lazyPut<KhataEntriesController>(
      () => KhataEntriesController(
        Get.find<GetEntriesByUserUsecase>(),
        Get.find<AddEntryUsecase>(),
        Get.find<UpdateEntryUsecase>(),
        Get.find<DeleteEntryUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AllInvoiceController>(
      () => AllInvoiceController(
        Get.find<GetAllInvoicesUsecase>(),
        Get.find<GenrateInvoiceUsecase>(),
        Get.find<MarkPaidInvoiceUsecase>(),
        Get.find<MarkUnpaidInvoiceUseCase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<InvoiceDetailsController>(
      () => InvoiceDetailsController(
        Get.find<DeleteInvoiceUsecase>(),
        Get.find<GetInvoiceDetailsUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<SubscriptionPlanController>(
      () => SubscriptionPlanController(
        Get.find<GetAllSubscriptionPlansUsecase>(),
        Get.find<GetOrderidUecase>(),
        Get.find<VerifyPaymentUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<PaymentCotnroller>(() => PaymentCotnroller(), fenix: true);
    Get.lazyPut<SearchInAppController>(
      () => SearchInAppController(),
      fenix: true,
    );
    Get.lazyPut<ScanDevicesController>(
      () => ScanDevicesController(),
      fenix: true,
    );

    Get.lazyPut<ProfileController>(
      () => ProfileController(
        updateVendorNameUsecase: Get.find<UpdateVendorNameUsecase>(),
        getCurrentPlanUsecase: Get.find<GetCurrentPlanUsecase>(),
      ),
      fenix: true,
    );
    Get.lazyPut<AppSettingController>(
      () => AppSettingController(
        getdairySettingsData: Get.find<GetDairySettingDataUsecase>(),
        getExistingSettingDataUsecase:
            Get.find<GetExistingSettingDataUsecase>(),
        updateDairySettingUsecase: Get.find<UpdateDairySettingUsecase>(),
      ),
      fenix: true,
    );
    Get.lazyPut<TransactionHistoryController>(
      () => TransactionHistoryController(
        transactionHistoryUsecase: Get.find<GetTransactionHistoryUsecase>(),
      ),
      fenix: true,
    );
  }
}

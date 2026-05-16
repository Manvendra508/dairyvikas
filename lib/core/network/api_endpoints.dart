class ApiEndpoints {
  ApiEndpoints._();
  // static String baseUrl = 'http://172.20.10.2:3000'; // phone hotspot
  // static String baseUrl = 'http://192.168.0.36:3000'; // office wifi
  //static String baseUrl = 'http://192.168.31.139:3000'; // home wifi
  static String baseUrl = 'https://api.dairysathi.com'; // live URL

  // other apis
  static String pincodeApi = 'https://api.postalpincode.in/pincode/';

  // vendor api

  static String addDairyDetails = '$baseUrl/vendors/addDairy';
  static String dashboardData =
      '$baseUrl/vendors/getFeatureListByCategoryAndDairyDetail';

  // common routes api
  static String getDairySettingsdata = '$baseUrl/common/getFields';
  static String getDateRange = '$baseUrl/common/getDateRange';
  static String checkAppUpdate = '$baseUrl/common/getAppVersion';

  // auth apis
  static String refreshToken = '$baseUrl/auth/vendorRefresh';
  static String logoutVendor = '$baseUrl/auth/vendorLogout';
  static String logoutFromallDevices = '$baseUrl/auth/vendorLogoutAll';
  static String resendOtp = '$baseUrl/auth/vendorResendOtp';
  static String forgotPassword = '$baseUrl/auth/vendorResendOtp';
  static String sendOtpForForgotPassoprd = '$baseUrl/auth/vendorForgotPassword';
  static String verifyOtpForForgotPassword =
      '$baseUrl/auth/vendorVerifyForgotPasswordOtp';
  static String vendorResetPassword = '$baseUrl/auth/vendorResetPassword';
  static String registerVendor = '$baseUrl/auth/vendorRegister';
  static String loginVendor = '$baseUrl/auth/vendorLogin';
  static String verifyOtp = '$baseUrl/auth/vendorVerifyOtp';

  // rate chart end point
  static String addNewRateChart = '$baseUrl/vendors/addNewRateChart';

  static String getAllRateCharts = '$baseUrl/vendors/getRateChart';
  static String getAllAssignedRateCharts = '$baseUrl/vendors/getAssignedCharts';
  static String updateNewRateChart = '$baseUrl/vendors/updateRateChart';
  static String getRateChartsDetails = '$baseUrl/vendors/getRateChartById';
  static String deleteRateChart = '$baseUrl/vendors/deleteRateChart';
  static String assignRateChartsToDairy = '$baseUrl/vendors/assignRateChart';
  static String unassignRateChart = '$baseUrl/vendors/unassignRateChart';
  static String changeRatechartStatus =
      '$baseUrl/vendors/updateRateChartStatus';
  static String uploadExcel = '$baseUrl/vendors/importRateChart';
  // milk suppliers endpoints
  static String addNewMilkSupplier = '$baseUrl/vendors/addNewMilkSupplier';

  static String updateMilkSupplier = '$baseUrl/vendors/updateMilkSupplier';
  static String getAllMilkSupliers = '$baseUrl/vendors/getMilkSuppliers';
  static String deleteMilkSupliers = '$baseUrl/vendors/deleteMilkSupplier';
  static String updateSupplierStatus =
      '$baseUrl/vendors/updateMilkSupplierStatus';

  static String getAllAssignableSuppliers =
      '$baseUrl/vendors/getAssignedTargetsToRateChart';

  // collections api endpoints
  static String addCollection = '$baseUrl/vendors/addCollection';
  static String updateCollection = '$baseUrl/vendors/updateCollection';
  static String getAllCollection = '$baseUrl/vendors/getCollectionsByDairyId';
  static String deleteCollection = '$baseUrl/vendors/deleteCollection';
  static String getCollectionsForAdjustment =
      '$baseUrl/vendors/getCollectionsBySupplierId';

  // milk sale endpoints
  static String addNewMilkBuyers = '$baseUrl/vendors/addNewMilkBuyer';

  static String updateMilkBuyer = '$baseUrl/vendors/updateMilkBuyer';
  static String getAllMilkBuyers = '$baseUrl/vendors/getMilkBuyers';
  static String deleteMilkBuyers = '$baseUrl/vendors/deleteMilkBuyer';
  static String updateBuyerStatus = '$baseUrl/vendors/updateMilkBuyerStatus';
  static String addMilkSale = '$baseUrl/vendors/addSale';
  static String getAllMilkSale = '$baseUrl/vendors/getSalesByDairyId';

  static String updateMilkSale = '$baseUrl/vendors/updateSale';

  // food endpoints
  static String addNewFoodDealer = '$baseUrl/vendors/addNewDealer';
  static String getFoodDealers = '$baseUrl/vendors/getDealers';
  static String updateFoodDealer = '$baseUrl/vendors/updateDealer';
  static String getAllItems = '$baseUrl/vendors/getItems';
  static String addNewItem = '$baseUrl/vendors/addNewItem';
  static String updateItem = '$baseUrl/vendors/updateItem';
  static String addNewStock = '$baseUrl/vendors/addItemStock';
  static String updateStock = '$baseUrl/vendors/updateItemStock';
  static String getAllStock = '$baseUrl/vendors/getDairyStock';
  static String addFoodSale = '$baseUrl/vendors/addItemSale';
  static String updateFoodSale = '$baseUrl/vendors/updateItemSale';
  static String getStockHistory = '$baseUrl/vendors/getItemStockHistory';
  static String foodSales = '$baseUrl/vendors/getItemSales';
  static String getUnits = '$baseUrl/vendors/';

  // notice board enpoints

  static String addNotice = '$baseUrl/vendors/addNotice';
  static String updateNotice = '$baseUrl/vendors/updateNotice';
  static String getNotices = '$baseUrl/vendors/getNoticesByDairyId';
  static String deleteNotice = '$baseUrl/vendors/deleteNotice';

  // khata book api endpoints
  static String addKhataBookCustomer = '$baseUrl/vendors/addKhatabookUser';
  static String updateKhataBookCustomer =
      '$baseUrl/vendors/updateKhatabookUser';
  static String getKhataBookUsers = '$baseUrl/vendors/getKhatabookUsersSummary';
  static String deleteKhataCustomer = '$baseUrl/vendors/deleteKhatabookUser';

  static String addKhatabookEntry = '$baseUrl/vendors/addKhatabookEntry';
  static String updateKhatabookEntry = '$baseUrl/vendors/updateKhatabookEntry';
  static String getKhatabookEntriesByUser =
      '$baseUrl/vendors/getKhatabookEntriesByUser';
  static String deleteKhatabookEntry = '$baseUrl/vendors/deleteKhatabookEntry';

  // invoices endpoints
  static String getInvoiceDashboard = '$baseUrl/vendors/getInvoiceDashboard';
  static String generateInvoice = '$baseUrl/vendors/generateInvoice';
  static String markPaid = '$baseUrl/vendors/createInvoicePayment';
  static String deleteInvoice = '$baseUrl/vendors/deleteInvoice';
  static String markUnPaid = '$baseUrl/vendors/markInvoiceUnpaid';
  static String getInvoiceDetails = '$baseUrl/vendors/getInvoiceDetails';

  // subscripiotn plans
  static String getSubscriptionPlans = '$baseUrl/vendors/getPlans';
  static String createOrderId = '$baseUrl/vendors/vendorCreateOrder';
  static String verifyPayment = '$baseUrl/vendors/verifyPaymentController';
  static String transactionHistory = '$baseUrl/vendors/getTransactionList';

  // profile and app settings
  static String getExistingDairySetting =
      '$baseUrl/vendors/getDairyWithSettings';
  static String updateVendorName = '$baseUrl/auth/vendorUpdateName';
  static String updateDairySetting = '$baseUrl/vendors/updateDairy';
  static String getCurrentPlan = '$baseUrl/vendors/getCurrentPlan';
}

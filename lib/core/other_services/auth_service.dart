import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/error/exceptions.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/local_datasources/local_storage_service.dart';
import 'package:dairysathi/core/local_datasources/secured_storage_service.dart';
import 'package:dairysathi/core/network/api_endpoints.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AuthService with CommonMixin {
  static Future<bool> isLoggedIn() async {
    return await SecureStorage.instance.getVendorLoginStatus() == 'true';
  }

  static Future<bool> isDairyDetailsSaved() async {
    return await SharedPrefsService.instance.getDairyDetails() != null;
  }

  Future<List<String>> refreshAccessToken(String refreshToken, Dio dio) async {
    List<String> tokens = [];
    String deviceId = await SecureStorage.instance.getVendorDeviceid() ?? '';

    try {
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {"refreshToken": refreshToken, "device_id": deviceId},
        options: Options(headers: {"skipAuth": true}),
      );

      if (response.statusCode == 200) {
        String accessToken = response.data["accessToken"] ?? '';
        String refreshToken = response.data["refreshToken"] ?? '';
        tokens.add(accessToken);
        tokens.add(refreshToken);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    }
    return tokens;
  }

  Future<bool> logoutVendroRemote(String refreshToken, Dio dio) async {
    bool isLoogedOut = false;
    String deviceId = await SecureStorage.instance.getVendorDeviceid() ?? '';

    try {
      final response = await dio.post(
        ApiEndpoints.logoutVendor,
        data: {"rawToken": refreshToken, "device_id": deviceId},
      );

      if (response.statusCode == 200 && response.data['success']) {
        isLoogedOut = true;
        await logoutUserLocal();
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    }
    return isLoogedOut;
  }

  Future<bool> logoutVendroFromAllDevice(String refreshToken, Dio dio) async {
    bool isLoogedFromallOut = false;

    try {
      final response = await dio.post(ApiEndpoints.logoutFromallDevices);

      if (response.statusCode == 200 && response.data['success']) {
        isLoogedFromallOut = true;
        await logoutVendroRemote(refreshToken, dio);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    }
    return isLoogedFromallOut;
  }

  logoutUserLocal() async {
    SharedPrefsService.instance.clear();
    await SecureStorage.instance.deleteAllExcept();
    // clear appstate data
    AppState.dairyName = 'unavailable';
    AppState.vendorDistrict = 'unknown';
    AppState.vendorState = 'unknown';
    AppState.chartIdForassignablesupplierScreen = '';
    AppState.customerTypeForassignablSupplierScreen = '';
    AppState.dateRanges.clear();
    AppState.milkSuppliers.clear();
    Get.delete<DashboardController>();
    AppNavigation.goToLoginAndRemoveAll();
  }
}

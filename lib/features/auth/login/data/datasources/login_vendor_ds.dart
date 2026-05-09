import 'package:DairyVikas/core/network/api_endpoints.dart';
import 'package:DairyVikas/features/auth/registration_flow/data/model/vendor_data_model.dart';
import 'package:dio/dio.dart';

class LoginVendorRemoteDataSource {
  final Dio dio;

  LoginVendorRemoteDataSource(this.dio);

  Future<VendorDataModel> loginVendor(Map credentials) async {
    final response = await dio.post(
      ApiEndpoints.loginVendor,
      data: credentials,
    );
    return VendorDataModel.fromJson(response.data);
  }

  Future<Map> sendOtpForForgotPassowrdUsecase(Map phoneNumber) async {
    final response = await dio.post(
      ApiEndpoints.sendOtpForForgotPassoprd,
      data: phoneNumber,
    );
    return response.data;
  }

  Future<Map> verifyOtpForForgotPassowrdUsecase(Map data) async {
    final response = await dio.post(
      ApiEndpoints.verifyOtpForForgotPassword,
      data: data,
    );
    return response.data;
  }

  Future<Map> resetPassowrd(Map data) async {
    final response = await dio.post(
      ApiEndpoints.vendorResetPassword,
      data: data,
    );
    return response.data;
  }
}

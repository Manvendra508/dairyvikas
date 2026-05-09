import 'package:DairyVikas/core/network/api_endpoints.dart';
import 'package:DairyVikas/features/auth/registration_flow/data/model/add_dairy_responce_model.dart';
import 'package:DairyVikas/features/auth/registration_flow/data/model/dairy_setting_data_response_model.dart';
import 'package:DairyVikas/features/auth/registration_flow/data/model/register_vendor_reponse_model.dart';
import 'package:DairyVikas/features/auth/registration_flow/data/model/vendor_data_model.dart';
import 'package:dio/dio.dart';

class RegisterVendorRemoteDataSource {
  final Dio dio;

  RegisterVendorRemoteDataSource(this.dio);

  Future<RegisterVendorResponseModel> registerVendor(Map vendorData) async {
    final response = await dio.post(
      ApiEndpoints.registerVendor,
      data: vendorData,
    );
    return RegisterVendorResponseModel.fromJson(response.data);
  }

  Future<VendorDataModel> verifyOtp(Map data) async {
    final response = await dio.post(ApiEndpoints.verifyOtp, data: data);
    return VendorDataModel.fromJson(response.data);
  }

  Future<AddDairyResponseModel> addDairyDetails(Map data) async {
    final response = await dio.post(ApiEndpoints.addDairyDetails, data: data);
    return AddDairyResponseModel.fromJson(response.data);
  }

  Future<DairySettingDataResponseModel> getDairySettingData() async {
    final response = await dio.get(ApiEndpoints.getDairySettingsdata);
    return DairySettingDataResponseModel.fromJson(response.data);
  }

  Future<Map> resendOtp(String mobile) async {
    final response = await dio.post(
      ApiEndpoints.resendOtp,
      data: {"mobile": mobile},
    );
    return response.data;
  }
}

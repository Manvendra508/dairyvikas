import 'package:DairyVikas/features/auth/registration_flow/domain/entities/add_dairy_response_entity.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/entities/dairy_setting_data_response_entity.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/entities/register_vendor_respose_entity.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/entities/vendor_data_entity.dart';

abstract class RegisterVendorRepo {
  Future<RegisterVendorReponseEntity> registerVendor(Map vendorData);
  Future<VendorDataEntity> verifyOtp(Map data);

  Future<AddDairyResponseEntity> addDairyDetails(Map data);

  Future<DairySettingDataResponseEntity> getDairyCenterSettingData();

  Future<Map> resendOtp(String mobile);
}

import 'package:DairyVikas/features/auth/registration_flow/data/datasources/register_vendor_ds.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/entities/add_dairy_response_entity.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/entities/dairy_setting_data_response_entity.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/entities/register_vendor_respose_entity.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/entities/vendor_data_entity.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/repository/register_vendor_repo.dart';

class RegisterVendorImpl implements RegisterVendorRepo {
  final RegisterVendorRemoteDataSource registerVendorRemoteDataSource;

  RegisterVendorImpl(this.registerVendorRemoteDataSource);

  @override
  Future<RegisterVendorReponseEntity> registerVendor(Map vendorData) async {
    return await registerVendorRemoteDataSource.registerVendor(vendorData);
  }

  @override
  Future<VendorDataEntity> verifyOtp(Map data) async {
    return await registerVendorRemoteDataSource.verifyOtp(data);
  }

  @override
  Future<AddDairyResponseEntity> addDairyDetails(Map data) async {
    return await registerVendorRemoteDataSource.addDairyDetails(data);
  }

  @override
  Future<DairySettingDataResponseEntity> getDairyCenterSettingData() async {
    return await registerVendorRemoteDataSource.getDairySettingData();
  }

  @override
  Future<Map> resendOtp(String mobile) async {
    return await registerVendorRemoteDataSource.resendOtp(mobile);
  }
}

import 'package:dairysathi/features/auth/login/data/datasources/login_vendor_ds.dart';
import 'package:dairysathi/features/auth/login/domain/repository/login_vendor_repo.dart';
import 'package:dairysathi/features/auth/registration_flow/data/model/vendor_data_model.dart';

class LoginVendorRepoImpl implements LoginVendorRepo {
  final LoginVendorRemoteDataSource loginVendorRemoteDataSource;

  LoginVendorRepoImpl(this.loginVendorRemoteDataSource);

  @override
  Future<VendorDataModel> loginVendor(Map credentials) async {
    return await loginVendorRemoteDataSource.loginVendor(credentials);
  }

  @override
  Future<Map> sendOtpForForgotPassowrdUsecase(Map phoneNumber) async {
    return await loginVendorRemoteDataSource.sendOtpForForgotPassowrdUsecase(
      phoneNumber,
    );
  }

  @override
  Future<Map> verifyOtpForForgotPassowrdUsecase(Map data) async {
    return await loginVendorRemoteDataSource.verifyOtpForForgotPassowrdUsecase(
      data,
    );
  }

  @override
  Future<Map> resetPasswordPassowrdUsecase(Map data) async {
    return await loginVendorRemoteDataSource.resetPassowrd(data);
  }
}

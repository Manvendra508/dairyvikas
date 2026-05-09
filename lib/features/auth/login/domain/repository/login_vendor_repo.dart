import 'package:DairyVikas/features/auth/registration_flow/domain/entities/vendor_data_entity.dart';

abstract class LoginVendorRepo {
  Future<VendorDataEntity> loginVendor(Map credentials);
  Future<Map> sendOtpForForgotPassowrdUsecase(Map phoneNumber);
  Future<Map> verifyOtpForForgotPassowrdUsecase(Map data);

  Future<Map> resetPasswordPassowrdUsecase(Map data);
}

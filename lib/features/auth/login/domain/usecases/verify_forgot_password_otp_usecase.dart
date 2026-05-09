import 'package:DairyVikas/features/auth/login/domain/repository/login_vendor_repo.dart';

class VerifyForgotPasswordOtpUsecase {
  final LoginVendorRepo loginVendorRepo;

  VerifyForgotPasswordOtpUsecase(this.loginVendorRepo);

  Future<Map> call(Map data) {
    return loginVendorRepo.verifyOtpForForgotPassowrdUsecase(data);
  }
}

import 'package:DairyVikas/features/auth/login/domain/repository/login_vendor_repo.dart';

class SendOtpForForgotPassowrdUsecase {
  final LoginVendorRepo loginVendorRepo;

  SendOtpForForgotPassowrdUsecase(this.loginVendorRepo);

  Future<Map> call(Map phoneNumber) {
    return loginVendorRepo.sendOtpForForgotPassowrdUsecase(phoneNumber);
  }
}

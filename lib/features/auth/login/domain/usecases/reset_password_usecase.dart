import 'package:dairysathi/features/auth/login/domain/repository/login_vendor_repo.dart';

class ResetPasswordUsecase {
  final LoginVendorRepo loginVendorRepo;

  ResetPasswordUsecase(this.loginVendorRepo);

  Future<Map> call(Map data) {
    return loginVendorRepo.resetPasswordPassowrdUsecase(data);
  }
}

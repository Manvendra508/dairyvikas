import 'package:dairysathi/features/auth/registration_flow/domain/repository/register_vendor_repo.dart';

class ResendOtpUsecase {
  final RegisterVendorRepo _registerVendorRepo;

  ResendOtpUsecase(this._registerVendorRepo);

  Future<Map> call(String mobile) {
    return _registerVendorRepo.resendOtp(mobile);
  }
}

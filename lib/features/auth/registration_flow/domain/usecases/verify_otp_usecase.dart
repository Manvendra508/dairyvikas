import 'package:DairyVikas/features/auth/registration_flow/domain/entities/vendor_data_entity.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/repository/register_vendor_repo.dart';

class VerifyOtpUsecase {
  final RegisterVendorRepo _registerVendorRepo;

  VerifyOtpUsecase(this._registerVendorRepo);

  Future<VendorDataEntity> call(Map data) {
    return _registerVendorRepo.verifyOtp(data);
  }
}

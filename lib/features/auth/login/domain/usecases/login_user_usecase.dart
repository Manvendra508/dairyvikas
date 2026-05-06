import 'package:dairysathi/features/auth/login/domain/repository/login_vendor_repo.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/entities/vendor_data_entity.dart';

class LoginVendorUsecase {
  final LoginVendorRepo loginVendorRepo;

  LoginVendorUsecase(this.loginVendorRepo);

  Future<VendorDataEntity> call(Map data) {
    return loginVendorRepo.loginVendor(data);
  }
}

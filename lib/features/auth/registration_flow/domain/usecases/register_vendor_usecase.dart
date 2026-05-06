import 'package:dairysathi/features/auth/registration_flow/domain/entities/register_vendor_respose_entity.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/repository/register_vendor_repo.dart';

class RegisterVendorUsecase {
  final RegisterVendorRepo _registerVendorRepo;

  RegisterVendorUsecase(this._registerVendorRepo);

  Future<RegisterVendorReponseEntity> call(Map vendorData) {
    return _registerVendorRepo.registerVendor(vendorData);
  }
}

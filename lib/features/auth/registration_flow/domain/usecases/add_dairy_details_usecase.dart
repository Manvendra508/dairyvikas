import 'package:DairyVikas/features/auth/registration_flow/domain/entities/add_dairy_response_entity.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/repository/register_vendor_repo.dart';

class AddDairyDetailsUsecase {
  final RegisterVendorRepo _registerVendorRepo;

  AddDairyDetailsUsecase(this._registerVendorRepo);

  Future<AddDairyResponseEntity> call(Map dairyData) {
    return _registerVendorRepo.addDairyDetails(dairyData);
  }
}

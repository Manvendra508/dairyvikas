import 'package:DairyVikas/features/auth/registration_flow/domain/entities/dairy_setting_data_response_entity.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/repository/register_vendor_repo.dart';

class GetDairySettingDataUsecase {
  final RegisterVendorRepo _registerVendorRepo;

  GetDairySettingDataUsecase(this._registerVendorRepo);

  Future<DairySettingDataResponseEntity> call() {
    return _registerVendorRepo.getDairyCenterSettingData();
  }
}

import 'package:dairysathi/features/profile_and_settings/domain/repository/app_setting_repo.dart';

class UpdateVendorNameUsecase {
  final AppSettingRepo _appSettingRepo;

  UpdateVendorNameUsecase(this._appSettingRepo);

  Future<Map> call(String name) {
    return _appSettingRepo.updateVendorName(name);
  }
}

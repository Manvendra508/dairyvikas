import 'package:DairyVikas/features/profile_and_settings/domain/repository/app_setting_repo.dart';

class GetExistingSettingDataUsecase {
  final AppSettingRepo _appSettingRepo;

  GetExistingSettingDataUsecase(this._appSettingRepo);

  Future<Map> call(String dairyId) {
    return _appSettingRepo.getExistingDairySettingData(dairyId);
  }
}

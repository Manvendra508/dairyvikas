import 'package:DairyVikas/features/profile_and_settings/domain/repository/app_setting_repo.dart';

class UpdateDairySettingUsecase {
  final AppSettingRepo _appSettingRepo;

  UpdateDairySettingUsecase(this._appSettingRepo);

  Future<Map> call(Map params) {
    return _appSettingRepo.updateDairySetting(params);
  }
}

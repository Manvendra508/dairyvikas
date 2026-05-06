import 'package:dairysathi/features/profile_and_settings/domain/repository/app_setting_repo.dart';

class GetCurrentPlanUsecase {
  final AppSettingRepo _appSettingRepo;

  GetCurrentPlanUsecase(this._appSettingRepo);

  Future<Map> call() {
    return _appSettingRepo.getCurrentPlan();
  }
}

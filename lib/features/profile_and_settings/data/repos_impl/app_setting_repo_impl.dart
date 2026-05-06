import 'package:dairysathi/features/profile_and_settings/data/datasources/app_setting_ds.dart';
import 'package:dairysathi/features/profile_and_settings/domain/repository/app_setting_repo.dart';

class AppSettingRepoImpl implements AppSettingRepo {
  final AppSettingDs _appSettingDs;

  AppSettingRepoImpl(this._appSettingDs);

  @override
  Future<Map> getExistingDairySettingData(String dairyId) async {
    return _appSettingDs.getExistingDairysettings(dairyId);
  }

  @override
  Future<Map<dynamic, dynamic>> updateVendorName(String name) async {
    return _appSettingDs.updateVendorName(name);
  }

  @override
  Future<Map<dynamic, dynamic>> updateDairySetting(
    Map<dynamic, dynamic> params,
  ) async {
    return _appSettingDs.updateDairySetting(params);
  }

  @override
  Future<Map<dynamic, dynamic>> getCurrentPlan() async {
    return _appSettingDs.getCurrentPlan();
  }
}

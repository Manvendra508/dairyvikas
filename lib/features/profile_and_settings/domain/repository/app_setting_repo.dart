abstract class AppSettingRepo {
  Future<Map> getExistingDairySettingData(String dairyId);
  Future<Map> updateVendorName(String name);
  Future<Map> updateDairySetting(Map params);
  Future<Map> getCurrentPlan();
}

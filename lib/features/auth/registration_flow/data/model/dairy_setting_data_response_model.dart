import 'package:DairyVikas/features/auth/registration_flow/domain/entities/dairy_setting_data_response_entity.dart';

class DairySettingDataResponseModel extends DairySettingDataResponseEntity {
  DairySettingDataResponseModel({
    required super.success,
    required super.settingData,
    required super.message,
  });

  factory DairySettingDataResponseModel.empty() {
    return DairySettingDataResponseModel(
      success: false,
      settingData: SettingData.empty(),
      message: '',
    );
  }

  /// ---------- FROM JSON ----------
  factory DairySettingDataResponseModel.fromJson(Map<String, dynamic> json) {
    return DairySettingDataResponseModel(
      success: json['success'] ?? false,
      settingData: json['data'] == null
          ? SettingData.empty()
          : SettingData.fromJson(json['data']),
      message: json['message'] ?? '',
    );
  }

  /// ---------- TO JSON ----------
  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": settingData.toJson(),
      "message": message,
    };
  }
}

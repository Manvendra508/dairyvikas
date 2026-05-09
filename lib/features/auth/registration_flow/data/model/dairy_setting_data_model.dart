import 'package:DairyVikas/features/auth/registration_flow/domain/entities/dairy_settings_data_entity.dart';

class DairySettingDataModel extends DairySettingsDataEntity {
  DairySettingDataModel({required super.id, required super.name});

  factory DairySettingDataModel.empty() {
    return DairySettingDataModel(name: '', id: '');
  }

  /// ---------- FROM JSON ----------
  factory DairySettingDataModel.fromJson(Map<String, dynamic> json) {
    return DairySettingDataModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
    );
  }

  /// ---------- TO JSON ----------
  Map<String, dynamic> toJson() {
    return {"id": id, "name": name};
  }
}

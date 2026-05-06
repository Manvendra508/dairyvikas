import '../../data/model/dairy_setting_data_model.dart';

class DairySettingDataResponseEntity {
  final bool success;
  final String message;
  final SettingData settingData;

  DairySettingDataResponseEntity({
    required this.settingData,
    required this.success,
    required this.message,
  });
}

class SettingData {
  List<DairySettingDataModel> collectionshifts = [];
  List<DairySettingDataModel> collectionTypes = [];
  List<DairySettingDataModel> milkTypes = [];
  List<DairySettingDataModel> paymentPeriods = [];

  SettingData({
    required this.collectionshifts,
    required this.collectionTypes,
    required this.milkTypes,
    required this.paymentPeriods,
  });

  factory SettingData.empty() {
    return SettingData(
      collectionshifts: <DairySettingDataModel>[],
      collectionTypes: <DairySettingDataModel>[],
      milkTypes: <DairySettingDataModel>[],
      paymentPeriods: <DairySettingDataModel>[],
    );
  }

  SettingData.fromJson(Map<String, dynamic> json) {
    if (json['collectionshifts'] != null) {
      collectionshifts = <DairySettingDataModel>[];
      json['collectionshifts'].forEach((v) {
        collectionshifts.add(DairySettingDataModel.fromJson(v));
      });
    }
    if (json['collectionTypes'] != null) {
      collectionTypes = <DairySettingDataModel>[];
      json['collectionTypes'].forEach((v) {
        collectionTypes.add(DairySettingDataModel.fromJson(v));
      });
    }
    if (json['milkTypes'] != null) {
      milkTypes = <DairySettingDataModel>[];
      json['milkTypes'].forEach((v) {
        milkTypes.add(DairySettingDataModel.fromJson(v));
      });
    }
    if (json['paymentPeriods'] != null) {
      paymentPeriods = <DairySettingDataModel>[];
      json['paymentPeriods'].forEach((v) {
        paymentPeriods.add(DairySettingDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (collectionshifts.isNotEmpty) {
      data['collectionshifts'] = collectionshifts
          .map((v) => v.toJson())
          .toList();
    }
    if (collectionTypes.isNotEmpty) {
      data['collectionTypes'] = collectionTypes.map((v) => v.toJson()).toList();
    }
    if (milkTypes.isNotEmpty) {
      data['milkTypes'] = milkTypes.map((v) => v.toJson()).toList();
    }
    if (paymentPeriods.isNotEmpty) {
      data['paymentPeriods'] = paymentPeriods.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

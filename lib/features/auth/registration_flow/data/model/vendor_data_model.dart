import 'package:DairyVikas/features/auth/registration_flow/data/model/vendor_model.dart';
import 'package:DairyVikas/features/auth/registration_flow/domain/entities/vendor_data_entity.dart';

class VendorDataModel extends VendorDataEntity {
  VendorDataModel({
    required super.success,
    required super.message,
    required super.vendorModel,
    required super.accessToken,
    required super.refreshToken,
  });
  factory VendorDataModel.fromJson(Map<String, dynamic> json) {
    return VendorDataModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      vendorModel:
          json['vendor'] != null && json['vendor'] is Map<String, dynamic>
          ? VendorModel.fromJson(json['vendor'])
          : VendorModel.empty(), // fallback
    );
  }
}

import 'package:dairysathi/features/auth/registration_flow/domain/entities/register_vendor_respose_entity.dart';

class RegisterVendorResponseModel extends RegisterVendorReponseEntity {
  RegisterVendorResponseModel({
    required super.message,
    required super.success,

    required super.otp,
  });

  factory RegisterVendorResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterVendorResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      otp: json['otp'] ?? 0,
    );
  }
}

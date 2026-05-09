import 'package:DairyVikas/features/auth/registration_flow/domain/entities/vendor_entity.dart';

class VendorModel extends VendorEntity {
  VendorModel({
    required super.id,
    required super.name,
    required super.mobile,
    required super.role,
    required super.userCode,
    required super.dairyId,
  });
  factory VendorModel.empty() => VendorModel(
    id: "",
    name: "",
    mobile: '',
    role: '',
    userCode: '',
    dairyId: '',
  );

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      role: json['role'].toString(),
      userCode: json['user_code'] ?? '',
      id: json['id'].toString(),
      dairyId: json['dairy_id'] == null ? '0' : json['dairy_id'].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mobile'] = mobile;
    data['user_code'] = userCode;
    data['role'] = role;
    data['dairy_id'] = dairyId;
    return data;
  }
}

import 'package:dairysathi/features/auth/registration_flow/data/model/dairy_model.dart';
import 'package:dairysathi/features/auth/registration_flow/domain/entities/add_dairy_response_entity.dart';

class AddDairyResponseModel extends AddDairyResponseEntity {
  AddDairyResponseModel({
    required super.success,
    required super.message,
    required super.dairyModel,
  });

  /// ---------- EMPTY MODEL ----------
  factory AddDairyResponseModel.empty() {
    return AddDairyResponseModel(
      success: false,
      message: '',
      dairyModel: DairyModel.empty(),
    );
  }

  /// ---------- FROM JSON ----------
  factory AddDairyResponseModel.fromJson(Map<String, dynamic> json) {
    return AddDairyResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      dairyModel: DairyModel.fromJson(json['dairy']),
    );
  }

  /// ---------- TO JSON ----------
  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "dairy": dairyModel.toJson(),
    };
  }
}

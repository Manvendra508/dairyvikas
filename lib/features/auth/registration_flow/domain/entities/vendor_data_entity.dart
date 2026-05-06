import '../../data/model/vendor_model.dart';

class VendorDataEntity {
  final bool success;
  final String message;
  final VendorModel vendorModel;
  final String accessToken;
  final String refreshToken;

  VendorDataEntity({
    required this.success,
    required this.message,
    required this.vendorModel,
    required this.accessToken,
    required this.refreshToken,
  });
}

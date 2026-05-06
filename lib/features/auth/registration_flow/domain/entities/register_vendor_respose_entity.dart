class RegisterVendorReponseEntity {
  final bool success;
  final String message;

  final int otp;

  RegisterVendorReponseEntity({
    required this.success,
    required this.message,

    required this.otp,
  });
}

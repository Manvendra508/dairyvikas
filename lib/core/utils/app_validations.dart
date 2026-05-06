import 'package:dairysathi/core/utils/app_regex.dart';

class AppValidation {
  String? validateName(String name) {
    if (name.isEmpty) return "name_required";
    if (!AppRegex.nameRegex.hasMatch(name)) return "invalid_name";
    return null;
  }

  String? validateChartName(String name) {
    if (name.isEmpty) return "chart_name_required";

    return null;
  }

  String? validatePhone(String phone) {
    if (phone.isEmpty) return "phone_required";
    if (!AppRegex.phoneRegex.hasMatch(phone)) return "invalid_phone";
    return null;
  }

  String? validatePhoneForContacts(String phone) {
    if (phone.isEmpty) return "phone_required";
    // if (!AppRegex.phoneRegex.hasMatch(phone)) return "invalid_phone";
    return null;
  }

  String? validateEmail(String email) {
    if (email.isEmpty) return "email_required";
    if (!AppRegex.emailRegex.hasMatch(email)) return "invalid_email";
    return null;
  }

  String? validateCustomerCode(String code) {
    if (code.isEmpty) return "code_required";
    if (!AppRegex.onlyNumber.hasMatch(code)) return "invalid_code";
    return null;
  }

  String? validatePassword(String pass) {
    if (pass.isEmpty) return "password_required";
    if (pass.length < 6) return "password_length";
    return null;
  }
}

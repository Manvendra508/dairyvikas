import 'package:flutter/services.dart';

class OneDecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // ✅ Allow deletion
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    final text = newValue.text;

    // Allow empty
    if (text.isEmpty) return newValue;

    // Allow only digits
    final digitsOnly = text.replaceAll('.', '');
    if (!RegExp(r'^\d+$').hasMatch(digitsOnly)) {
      return oldValue;
    }

    // Auto-insert dot after first digit
    if (text.length == 2 && !text.contains('.')) {
      final formatted = '${text[0]}.${text[1]}';
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    // Block more than X.X
    if (text.contains('.') && text.split('.').last.length > 1) {
      return oldValue;
    }

    // Max length X.X
    if (text.length > 3) {
      return oldValue;
    }

    return newValue;
  }
}

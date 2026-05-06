extension StringExtensions on String {
  bool get isValidPhone => length == 10 && RegExp(r'^[0-9]+$').hasMatch(this);

  bool get isValidOtp => length == 6 && RegExp(r'^[0-9]+$').hasMatch(this);

  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  String get capitalize =>
      isEmpty ? this : this[0].toUpperCase() + substring(1);

  String get removeSpaces => replaceAll(' ', '');

  String get trimPhone => replaceAll(' ', '').trim();
  // String get firstLetter => substring(0, 1).toUpperCase();

  String get capitalizeWords {
    return split(" ")
        .map(
          (word) => word.isEmpty
              ? word
              : "${word[0].toUpperCase()}${word.substring(1)}",
        )
        .join(" ");
  }
}

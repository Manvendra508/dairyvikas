class AppRegex {
  AppRegex._();

  static const gstRegext = "[A-Za-z0-9]";
  //static final nameRegex = RegExp(r"^[a-zA-Z ]{3,}$");
  static final nameRegex = RegExp(r'^(?!\s*$)[^\p{Emoji}]+$', unicode: true);
  static final phoneRegex = RegExp(r'^[6-9]\d{9}$');
  static final onlyNumber = RegExp(r'^\d+\.?\d{0,2}');
  static final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
}

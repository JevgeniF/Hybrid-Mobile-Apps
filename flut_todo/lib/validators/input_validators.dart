class Validators {
  static String? passwordValidator(value) {
    RegExp passwordPattern = RegExp(
        r'^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{6,}$');
    if (value!.isEmpty || value.length < 6) {
      return 'Password minimum length is 6 characters';
    } else if (!passwordPattern.hasMatch(value)) {
      return 'Password must contain 1 capital letter, 1 number, 1 special character';
    }
  }

  static String? emailValidator(value) {
    RegExp emailPattern =
        RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w\w+)+$');
    if (value!.isEmpty || !emailPattern.hasMatch(value)) {
      return 'Invalid e-mail';
    }
  }

  static String? genericNameValidator(value) {
    if (value!.isEmpty) {
      return 'Minimum one character';
    }
  }
}

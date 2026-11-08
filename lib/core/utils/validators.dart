/// Validation functions for form fields. Each returns an error message when the value is invalid, or null when it is valid.
class AppValidators {
  // Private constructor to prevent instantiation
  AppValidators._();
  // Validates an email address. Returns an error message if the email is invalid, or null if it is valid.
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Validates a password. Returns an error message if the password is invalid, or null if it is valid.
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Checks that a required field is not blank. [fieldName] is the field's name in the error message.
  static String? defaultValidator(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? "Field"} is required';
    }
    return null;
  }
}

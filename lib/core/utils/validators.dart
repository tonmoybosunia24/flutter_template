import 'package:get/get.dart';
import 'package:template/core/utils/app_strings.dart';

/// Validation functions for form fields. Each returns an error message in the current language when the value is invalid, or null when it is valid.
class AppValidators {
  // Private constructor to prevent instantiation
  AppValidators._();
  // Validates an email address. Returns an error message if the email is invalid, or null if it is valid.
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.validationEmailRequired.tr;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.validationEmailInvalid.tr;
    }
    return null;
  }

  // Validates a password. Returns an error message if the password is invalid, or null if it is valid.
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.validationPasswordRequired.tr;
    }
    if (value.length < 6) {
      return AppStrings.validationPasswordTooShort.tr;
    }
    return null;
  }

  // Checks that a required field is not blank. [fieldName] is the already translated name shown in the error message.
  static String? defaultValidator(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationFieldRequired.trParams({
        'field': fieldName ?? AppStrings.validationFieldDefault.tr,
      });
    }
    return null;
  }
}

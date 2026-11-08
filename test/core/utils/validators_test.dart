import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:template/core/localization/app_translations.dart';
import 'package:template/core/utils/validators.dart';

/// Tests the form field rules in [AppValidators] and that their messages follow the current language.
void main() {
  setUpAll(() {
    Get.addTranslations(AppTranslations().keys);
    Get.locale = const Locale('en', 'US');
  });

  test('messages follow the current language', () {
    Get.locale = const Locale('bn', 'BD');
    addTearDown(() => Get.locale = const Locale('en', 'US'));

    expect(AppValidators.emailValidator(''), 'ইমেইল দিতে হবে');
    expect(
      AppValidators.defaultValidator('', fieldName: 'নাম'),
      'নাম পূরণ করতে হবে',
    );
    expect(AppValidators.defaultValidator(''), 'ঘরটি পূরণ করতে হবে');
  });

  group('emailValidator', () {
    test('requires a value', () {
      expect(AppValidators.emailValidator(null), 'Email is required');
      expect(AppValidators.emailValidator(''), 'Email is required');
    });

    test('rejects a malformed email', () {
      expect(AppValidators.emailValidator('abc'), 'Enter a valid email');
      expect(AppValidators.emailValidator('abc@site'), 'Enter a valid email');
    });

    test('accepts a valid email', () {
      expect(AppValidators.emailValidator('user@example.com'), isNull);
    });
  });

  group('passwordValidator', () {
    test('requires a value', () {
      expect(AppValidators.passwordValidator(null), 'Password is required');
      expect(AppValidators.passwordValidator(''), 'Password is required');
    });

    test('rejects fewer than 6 characters', () {
      expect(
        AppValidators.passwordValidator('12345'),
        'Password must be at least 6 characters',
      );
    });

    test('accepts 6 or more characters', () {
      expect(AppValidators.passwordValidator('123456'), isNull);
    });
  });

  group('defaultValidator', () {
    test('uses the field name in the message', () {
      expect(
        AppValidators.defaultValidator('', fieldName: 'Name'),
        'Name is required',
      );
    });

    test('falls back to a generic name and treats spaces as blank', () {
      expect(AppValidators.defaultValidator('   '), 'Field is required');
    });

    test('accepts any non-blank value', () {
      expect(AppValidators.defaultValidator('ok', fieldName: 'Name'), isNull);
    });
  });
}

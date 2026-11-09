import 'package:flutter_test/flutter_test.dart';
import 'package:template/core/localization/app_translations.dart';

/// Tests that no language is missing a translation.
void main() {
  final languages = AppTranslations().keys;
  final englishKeys = languages['en_US']!.keys.toSet();

  for (final MapEntry(key: locale, value: strings) in languages.entries) {
    test('$locale has every key with a non-empty value', () {
      expect(strings.keys.toSet(), englishKeys);
      expect(strings.values.where((text) => text.trim().isEmpty), isEmpty);
    });
  }
}

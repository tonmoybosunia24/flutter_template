import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/storage/storage_service.dart';

/// Changes the app's theme and language at runtime and saves the choice through [StorageService].
class SettingsUtil {
  // Private constructor to prevent instantiation
  SettingsUtil._();

  // The current theme of the application
  static final RxString _currentTheme = ''.obs;
  // The current language of the application
  static final RxString _currentLanguage = ''.obs;

  // Getter for the current theme. If the current theme is not set, it retrieves it from the StorageService.
  static RxString get currentTheme {
    if (_currentTheme.value.isEmpty) {
      _currentTheme.value = Get.find<StorageService>().getTheme() ?? 'system';
    }
    return _currentTheme;
  }

  // Getter for the current language. If the current language is not set, it retrieves it from the StorageService.
  static RxString get currentLanguage {
    if (_currentLanguage.value.isEmpty) {
      _currentLanguage.value = Get.find<StorageService>().getLanguage() ?? 'en';
    }
    return _currentLanguage;
  }

  // Applies the theme for [themeModeCode] ('light', 'dark' or 'system') and saves it.
  static void changeTheme(String themeModeCode) {
    currentTheme.value = themeModeCode;
    if (themeModeCode == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    } else if (themeModeCode == 'light') {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.system);
    }
    Get.find<StorageService>().saveTheme(themeModeCode);
  }

  // Applies the language for [langCode] ('en', 'ar' or 'bn') and saves it.
  static void changeLanguage(String langCode) {
    currentLanguage.value = langCode;
    if (langCode == 'ar') {
      Get.updateLocale(const Locale('ar', 'SA'));
    } else if (langCode == 'bn') {
      Get.updateLocale(const Locale('bn', 'BD'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }
    Get.find<StorageService>().saveLanguage(langCode);
  }
}

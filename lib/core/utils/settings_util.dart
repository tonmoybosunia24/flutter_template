import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/storage/storage_service.dart';

/// This utility class provides methods to manage application settings such as theme and language. It uses [GetX] for state management and [StorageService] for persistent storage.
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

  // Method to change the theme of the application. It updates the current Theme and saves it in the StorageService.
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

  // Method to change the language of the application. It updates the current Language and saves it in the StorageService.
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

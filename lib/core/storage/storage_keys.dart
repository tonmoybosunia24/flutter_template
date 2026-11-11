/// All keys used for local and secure storage, plus the saved language codes. Every read and write must use these constants.
class StorageKeys {
  // Private constructor to prevent instantiation
  StorageKeys._();

  // Authentication
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String tokenExpiry = 'token_expiry';

  // User Preferences
  static const String themeMode = 'theme_mode';
  static const String langCode = 'lang_code';

  // Onboarding
  static const String hasOnboarded = 'has_onboarded';

  // Language Codes
  static const String langCodeEn = 'en';
  static const String langCodeAr = 'ar';
  static const String langCodeBn = 'bn';
}

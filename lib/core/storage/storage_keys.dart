/// This class contains all the keys used for storing data in local storage. All [GetStorage] read/write operations must use these keys.
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
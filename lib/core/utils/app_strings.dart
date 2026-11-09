/// The translation keys of every UI text. Use them with `.tr`, e.g. `AppStrings.appName.tr`.
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // General
  static const String appName = 'app_name';

  // Splash
  static const String splashTitle = 'splash_title';

  // Onboarding
  static const String onboardingSkip = 'onboarding_skip';
  static const String onboardingNext = 'onboarding_next';
  static const String onboardingGetStarted = 'onboarding_get_started';
  static const String onboardingTitle1 = 'onboarding_title_1';
  static const String onboardingDesc1 = 'onboarding_desc_1';
  static const String onboardingTitle2 = 'onboarding_title_2';
  static const String onboardingDesc2 = 'onboarding_desc_2';
  static const String onboardingTitle3 = 'onboarding_title_3';
  static const String onboardingDesc3 = 'onboarding_desc_3';

  // Login
  static const String loginTitle = 'login_title';
  static const String loginEmailHint = 'login_email_hint';
  static const String loginPasswordHint = 'login_password_hint';
  static const String loginRememberMe = 'login_remember_me';
  static const String loginSignIn = 'login_sign_in';
  static const String loginForgotPassword = 'login_forgot_password';
  static const String loginOrContinueWith = 'login_or_continue_with';
  static const String loginNoAccount = 'login_no_account';
  static const String loginSignUp = 'login_sign_up';

  // Main screen tabs
  static const String navHome = 'nav_home';
  static const String navSearch = 'nav_search';
  static const String navNotifications = 'nav_notifications';
  static const String navSettings = 'nav_settings';
  static const String navProfile = 'nav_profile';

  // Home
  static const String homeLikeCount = 'home_like_count';
  static const String homeViewComments = 'home_view_comments';
  static const String homeSave = 'home_save';
  static const String homeJustNow = 'home_just_now';
  static const String homeMinutesAgo = 'home_minutes_ago';
  static const String homeHoursAgo = 'home_hours_ago';
  static const String homeDaysAgo = 'home_days_ago';
  static const String homeLike = 'home_like';
  static const String homeComment = 'home_comment';
  static const String homeShare = 'home_share';
  static const String homeCreatePostHint = 'home_create_post_hint';
  static const String homeCreatePostSubmit = 'home_create_post_submit';
  static const String homeWelcomeBack = 'home_welcome_back';

  // Profile
  static const String profileAccountSettings = 'profile_account_settings';
  static const String profileMyAccount = 'profile_my_account';
  static const String profileChangePassword = 'profile_change_password';
  static const String profileNotification = 'profile_notification';
  static const String profilePreferences = 'profile_preferences';
  static const String profileTheme = 'profile_theme';
  static const String profileLanguage = 'profile_language';
  static const String profileCurrentLanguage = 'profile_current_language';
  static const String profilePayment = 'profile_payment';
  static const String profileUpgradePremium = 'profile_upgrade_premium';
  static const String profileSupport = 'profile_support';
  static const String profileHelpCenter = 'profile_help_center';
  static const String profileTerms = 'profile_terms';
  static const String profilePrivacy = 'profile_privacy';
  static const String profileLogout = 'profile_logout';

  // Language
  static const String languageEnglish = 'language_english';
  static const String languageBengali = 'language_bengali';
  static const String languageArabic = 'language_arabic';
  static const String languageSuggested = 'language_suggested';
  static const String languageOthers = 'language_others';
  static const String languageSave = 'language_save';

  // Errors
  static const String errorUnknown = 'error_unknown';
  static const String errorNoInternet = 'error_no_internet';
  static const String errorTimeout = 'error_timeout';
  static const String errorSessionExpired = 'error_session_expired';
  static const String errorBadRequest = 'error_bad_request';
  static const String errorUnauthorized = 'error_unauthorized';
  static const String errorForbidden = 'error_forbidden';
  static const String errorNotFound = 'error_not_found';
  static const String errorValidation = 'error_validation';
  static const String errorServer = 'error_server';
  static const String errorRequestFailed = 'error_request_failed';
  static const String errorRetry = 'error_retry';

  // Form validation
  static const String validationEmailRequired = 'validation_email_required';
  static const String validationEmailInvalid = 'validation_email_invalid';
  static const String validationPasswordRequired = 'validation_password_required';
  static const String validationPasswordTooShort = 'validation_password_too_short';
  static const String validationFieldRequired = 'validation_field_required';
  static const String validationFieldDefault = 'validation_field_default';
}

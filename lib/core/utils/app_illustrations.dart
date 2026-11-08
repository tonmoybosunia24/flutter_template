/// This class contains all the illustration asset paths used across the application (onboarding, empty states, error pages, etc.). Illustrations are large, multi-color artwork and must not be tinted like icons. Use [IllustrationPath] constants instead of hardcoded strings to load illustrations safely and consistently.
class IllustrationPath {
  // Private constructor to prevent instantiation
  IllustrationPath._();
  // Base directory path for all illustration assets
  static const String asset = 'assets/illustrations/';
  // Onboarding illustrations
  static const String onboarding1 = '${asset}onboarding_1.svg';
  static const String onboarding2 = '${asset}onboarding_2.svg';
  static const String onboarding3 = '${asset}onboarding_3.svg';
}

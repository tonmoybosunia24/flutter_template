/// Asset paths of the illustrations (onboarding, empty states, error pages). Illustrations are large, multi-color artwork and must not be tinted like icons. Use these constants instead of hardcoded strings.
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

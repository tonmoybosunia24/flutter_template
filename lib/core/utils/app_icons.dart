/// This class contains all the SVG icon asset paths used across the application.Use [IconPath] constants instead of hardcoded strings to load icons safely and consistently.
class IconPath {
  // Private constructor to prevent instantiation
  IconPath._(); 
  // Base directory path for all icon assets
  static const String asset = 'assets/icons/';
  // Navigation & action icons
  static const String backArrow = '${asset}back_arrow.svg';
  static const String close = '${asset}close.svg';
  static const String delete = '${asset}delete.svg';
  static const String edit = '${asset}edit.svg';
  static const String eye = '${asset}eye.svg';
  static const String eyeOff = '${asset}eye_off.svg';
  static const String home = '${asset}home.svg';
  static const String loading = '${asset}loading.svg';
  static const String notification = '${asset}notification.svg';
  static const String search = '${asset}search.svg';
  static const String settings = '${asset}settings.svg';
  static const String user = '${asset}user.svg';
}

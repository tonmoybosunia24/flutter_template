/// This class contains all the SVG icon asset paths used across the application.Use [IconPath] constants instead of hardcoded strings to load icons safely and consistently.
class IconPath {
  // Private constructor to prevent instantiation
  IconPath._(); 
  // Base directory path for all icon assets
  static const String asset = 'assets/icons/';
  // Navigation & action icons
  static const String backArrow = '${asset}back_arrow.svg';
  static const String checkboxChecked = '${asset}checkbox_checked.svg';
  static const String check = '${asset}check.svg';
  static const String close = '${asset}close.svg';
  static const String delete = '${asset}delete.svg';
  static const String edit = '${asset}edit.svg';
  static const String eye = '${asset}eye.svg';
  static const String eyeOff = '${asset}eye_off.svg';
  static const String home = '${asset}home.svg';
  static const String loading = '${asset}loading.svg';
  static const String lock = '${asset}lock.svg';
  static const String mail = '${asset}mail.svg';
  static const String notification = '${asset}notification.svg';
  static const String search = '${asset}search.svg';
  static const String settings = '${asset}settings.svg';
  static const String user = '${asset}user.svg';
  // Profile icons
  static const String account = '${asset}account.svg';
  static const String arrowRight = '${asset}arrow_right.svg';
  static const String contracts = '${asset}contracts.svg';
  static const String global = '${asset}global.svg';
  static const String helpCircle = '${asset}help_circle.svg';
  static const String info = '${asset}info.svg';
  static const String lockOpen = '${asset}lock_open.svg';
  static const String moneyAdd = '${asset}money_add.svg';
  static const String moon = '${asset}moon.svg';
  static const String sun = '${asset}sun.svg';
  // Brand icons (multi-color, don't tint)
  static const String facebook = '${asset}facebook.svg';
  static const String google = '${asset}google.svg';
}

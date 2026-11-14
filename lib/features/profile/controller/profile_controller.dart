import 'dart:async';

import 'package:get/get.dart';
import 'package:template/core/core.dart';
import 'package:template/routes/app_routes.dart';

/// Holds the state of the profile screen: the user's name, the notification toggle, the theme setting and logging out.
class ProfileController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final RxBool isLoggingOut = false.obs;
  final String userName = 'Md Tonmoy Bosunia';
  final RxBool notificationEnabled = true.obs;
  // Waits for the switch to finish sliding before the whole app rebuilds; quick repeated taps apply only the last one.
  static const Duration _themeApplyDelay = Duration(milliseconds: 200);
  Timer? _themeTimer;
  late final RxBool darkModeSwitch = _isDarkMode.obs;
  String get themeIcon => darkModeSwitch.value ? IconPath.moon : IconPath.sun;

  // Determines if the current theme is dark mode based on the saved setting and system preference.
  bool get _isDarkMode {
    final theme = SettingsUtil.currentTheme.value;
    return theme == 'dark' || (theme == 'system' && Get.isPlatformDarkMode);
  }

  // Toggles the notification switch.
  void toggleNotification() => notificationEnabled.toggle();

  // Switches between dark and light mode.
  void toggleTheme() {
    darkModeSwitch.toggle();
    _themeTimer?.cancel();
    _themeTimer = Timer(
      _themeApplyDelay,
      () => SettingsUtil.changeTheme(darkModeSwitch.value ? 'dark' : 'light'),
    );
  }

  // Clears the saved session and opens the login screen. When the backend has a logout endpoint, call it through a repository before clearAuth().
  Future<void> logout() async {
    if (isLoggingOut.value) return;
    isLoggingOut.value = true;
    await _storage.clearAuth();
    if (isClosed) return;
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    _themeTimer?.cancel();
    super.onClose();
  }
}

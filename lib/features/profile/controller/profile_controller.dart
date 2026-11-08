import 'dart:async';

import 'package:get/get.dart';
import 'package:template/core/core.dart';

// Holds the state of the profile screen: the user's name, the notification toggle and the theme setting (applied and saved through SettingsUtil).
class ProfileController extends GetxController {
  // Placeholder until the profile comes from the API.
  final String userName = 'Md Tonmoy Bosunia';

  // Reactive state of the notification switch.
  final RxBool notificationEnabled = true.obs;

  // Wait before applying a theme change, so the switch finishes sliding before the whole app rebuilds.
  static const Duration _themeApplyDelay = Duration(milliseconds: 200);
  Timer? _themeTimer;

  // Reactive state of the theme switch: on means dark mode.
  late final RxBool darkModeSwitch = _isDarkMode.obs;

  // Icon of the theme row: a moon in dark mode, a sun in light mode.
  String get themeIcon => darkModeSwitch.value ? IconPath.moon : IconPath.sun;

  // Whether the app is showing dark mode, including when it follows a dark system theme.
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

  @override
  void onClose() {
    _themeTimer?.cancel();
    super.onClose();
  }
}

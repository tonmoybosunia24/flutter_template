import 'package:get/get.dart';
import '../controller/settings_controller.dart';

/// Registers [SettingsController] for the settings tab.
class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // Register SettingsController as a lazy-loaded dependency using GetX
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}

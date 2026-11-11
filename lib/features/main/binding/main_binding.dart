import 'package:get/get.dart';
import 'package:template/features/home/binding/home_binding.dart';
import 'package:template/features/notification/binding/notification_binding.dart';
import 'package:template/features/profile/binding/profile_binding.dart';
import 'package:template/features/search/binding/search_binding.dart';
import 'package:template/features/settings/binding/settings_binding.dart';

import '../controller/main_controller.dart';

/// Registers [MainController] and the controllers of every tab shown inside the main screen.
class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Register MainController as a lazy-loaded dependency using GetX
    Get.lazyPut<MainController>(() => MainController());

    // The tabs live inside the main screen, so their controllers are registered here too
    HomeBinding().dependencies();
    SearchBinding().dependencies();
    NotificationBinding().dependencies();
    SettingsBinding().dependencies();
    ProfileBinding().dependencies();
  }
}

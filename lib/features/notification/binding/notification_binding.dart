import 'package:get/get.dart';

import '../controller/notification_controller.dart';

/// Registers [NotificationController] for the notifications tab.
class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    // Register NotificationController as a lazy-loaded dependency using GetX
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}

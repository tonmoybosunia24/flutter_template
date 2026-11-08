import 'package:get/get.dart';
import '../controller/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    // Register NotificationController as a lazy-loaded dependency using GetX
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}

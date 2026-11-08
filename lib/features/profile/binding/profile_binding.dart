import 'package:get/get.dart';
import '../controller/profile_controller.dart';

/// Registers [ProfileController] for the profile tab.
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Register ProfileController as a lazy-loaded dependency using GetX
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}

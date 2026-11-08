import 'package:get/get.dart';
import '../controller/home_controller.dart';

/// Registers [HomeController] for the home tab.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register HomeController as a lazy-loaded dependency using GetX
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

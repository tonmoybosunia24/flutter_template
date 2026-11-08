import 'package:get/get.dart';
import '../controller/home_controller.dart';

/// Binds the HomeController to the HomeScreen, ensuring that the controller is available when the screen is displayed.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register HomeController as a lazy-loaded dependency using GetX
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

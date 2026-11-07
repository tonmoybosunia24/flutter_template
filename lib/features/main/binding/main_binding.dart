import 'package:get/get.dart';
import '../controller/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Register MainController as a lazy-loaded dependency using GetX
    Get.lazyPut<MainController>(() => MainController());
  }
}


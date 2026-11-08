import 'package:get/get.dart';
import '../controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Eagerly created (not lazyPut) so startup runs even though the view never reads the controller.
    Get.put<SplashController>(SplashController());
  }
}

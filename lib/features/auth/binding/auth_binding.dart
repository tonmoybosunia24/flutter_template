import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Register AuthController as a lazy-loaded dependency using GetX
    Get.lazyPut<AuthController>(() => AuthController());
  }
}


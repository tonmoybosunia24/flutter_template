import 'package:get/get.dart';
import '../controller/login_controller.dart';


/// Registers [LoginController] for the login screen.
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

import 'package:get/get.dart';
import '../controller/login_controller.dart';


/// LoginBinding class is responsible for managing the dependencies for the login feature.
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

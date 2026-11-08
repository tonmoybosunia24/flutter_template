import 'package:get/get.dart';
import '../controller/language_controller.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    // Register LanguageController as a lazy-loaded dependency using GetX
    Get.lazyPut<LanguageController>(() => LanguageController());
  }
}

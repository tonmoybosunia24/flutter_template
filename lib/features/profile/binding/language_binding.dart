import 'package:get/get.dart';
import '../controller/language_controller.dart';

/// Registers [LanguageController] for the language screen.
class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    // Register LanguageController as a lazy-loaded dependency using GetX
    Get.lazyPut<LanguageController>(() => LanguageController());
  }
}

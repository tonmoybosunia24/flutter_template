import 'package:get/get.dart';
import '../controller/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    // Register OnboardingController as a lazy-loaded dependency using GetX
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}


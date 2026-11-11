import 'package:get/get.dart';

import '../controller/onboarding_controller.dart';

/// Registers [OnboardingController] for the onboarding screen.
class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    // Register OnboardingController as a lazy-loaded dependency using GetX
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}

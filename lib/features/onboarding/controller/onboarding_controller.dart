import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:template/core/core.dart';
import 'package:template/features/onboarding/model/onboarding_item.dart';
import 'package:template/routes/app_routes.dart';

// The OnboardingController class is responsible for managing the onboarding state and logic of the application. It extends GetxController, which provides reactive state management capabilities.
class OnboardingController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  // Controls the onboarding PageView.
  final PageController pageController = PageController();

  // Duration of the slide animation when tapping "Next".
  static const Duration _pageAnimationDuration = Duration(milliseconds: 350);

  // The onboarding pages. Replace the images and texts to fit your app.
  final List<OnboardingItem> items = const [
    OnboardingItem(
      image: IconPath.home,
      title: AppStrings.onboardingTitle1,
      description: AppStrings.onboardingDesc1,
    ),
    OnboardingItem(
      image: IconPath.notification,
      title: AppStrings.onboardingTitle2,
      description: AppStrings.onboardingDesc2,
    ),
    OnboardingItem(
      image: IconPath.settings,
      title: AppStrings.onboardingTitle3,
      description: AppStrings.onboardingDesc3,
    ),
  ];

  // Index of the page currently shown.
  final RxInt currentPage = 0.obs;

  bool get isLastPage => currentPage.value == items.length - 1;

  void onPageChanged(int index) => currentPage.value = index;

  // Goes to the next page, or finishes onboarding on the last page.
  void next() {
    if (isLastPage) {
      complete();
      return;
    }
    pageController.nextPage(
      duration: _pageAnimationDuration,
      curve: Curves.easeInOut,
    );
  }

  void skip() => complete();

  // Remembers that onboarding is done and moves to the auth flow.
  Future<void> complete() async {
    await _storage.setOnboarded();
    Get.offAllNamed(AppRoutes.auth);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

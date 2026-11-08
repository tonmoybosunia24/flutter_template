import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/onboarding/controller/onboarding_controller.dart';
import 'package:template/features/onboarding/widgets/onboarding_page_content.dart';
import 'package:template/features/onboarding/widgets/onboarding_page_indicator.dart';

/// The OnboardingScreen shows a swipeable set of intro pages with a skip action, a page indicator and a next / get started button.
class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  // Skip (hidden on the last page, space kept so layout doesn't jump)
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Obx(
                      () => Visibility(
                        visible: !controller.isLastPage,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: TextButton(
                          onPressed: controller.skip,
                          child: CustomText(
                            text: AppStrings.onboardingSkip.tr,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Pages
                  Expanded(
                    child: PageView.builder(
                      controller: controller.pageController,
                      itemCount: controller.items.length,
                      onPageChanged: controller.onPageChanged,
                      itemBuilder: (_, index) =>
                          OnboardingPageContent(item: controller.items[index]),
                    ),
                  ),

                  // Indicator
                  Obx(
                    () => OnboardingPageIndicator(
                      count: controller.items.length,
                      currentIndex: controller.currentPage.value,
                    ),
                  ),
                  SizedBox(height: getHeight(AppDimensions.space32)),

                  // Next / Get Started
                  Obx(
                    () => CustomButton(
                      text: controller.isLastPage
                          ? AppStrings.onboardingGetStarted.tr
                          : AppStrings.onboardingNext.tr,
                      onPressed: controller.next,
                    ),
                  ),
                  SizedBox(height: getHeight(AppDimensions.space24)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

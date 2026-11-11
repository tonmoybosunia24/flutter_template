import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// Dot indicator for the onboarding pages. The active dot stretches into a pill. Params: [count]: number of pages. [currentIndex]: index of the active page.
class OnboardingPageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(
            horizontal: getWidth(AppDimensions.space4),
          ),
          width: getWidth(
            isActive ? AppDimensions.space24 : AppDimensions.space8,
          ),
          height: getHeight(AppDimensions.space8),
          decoration: BoxDecoration(
            color: isActive ? colors.primary : colors.textHint,
            borderRadius: BorderRadius.circular(
              getRadius(AppDimensions.radius100),
            ),
          ),
        );
      }),
    );
  }
}

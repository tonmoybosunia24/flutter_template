import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/onboarding/model/onboarding_item.dart';

/// The content of a single onboarding page: an illustration followed by a title and a description.
class OnboardingPageContent extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPageContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;
    final illustrationSize = getRadius(AppDimensions.onboardingIllustrationSize);
    final iconSize = getRadius(AppDimensions.onboardingIconSize);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: illustrationSize,
              height: illustrationSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.overlay,
                shape: BoxShape.circle,
              ),
              child: CustomSvgIcon(
                assetName: item.image,
                width: iconSize,
                height: iconSize,
                color: colors.primary,
              ),
            ),
            SizedBox(height: getHeight(AppDimensions.space48)),
            CustomText(
              text: item.title.tr,
              style: textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getHeight(AppDimensions.space16)),
            CustomText(
              text: item.description.tr,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/onboarding/model/onboarding_item.dart';

/// The content of a single onboarding page: an illustration that fills the available space, followed by a title and a description.
class OnboardingPageContent extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPageContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: item.image.toLowerCase().endsWith('.svg')
                ? CustomSvgIcon(assetName: item.image)
                : Image.asset(item.image, fit: BoxFit.contain),
          ),
        ),
        SizedBox(height: getHeight(AppDimensions.space32)),
        CustomText(
          text: item.title.tr,
          style: textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: getHeight(AppDimensions.space12)),
        CustomText(
          text: item.description.tr,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: getHeight(AppDimensions.space32)),
      ],
    );
  }
}

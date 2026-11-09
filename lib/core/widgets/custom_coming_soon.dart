import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';

/// A centered placeholder for a feature that isn't ready yet: an icon, a title, a subtitle and a small home button. Params: [icon]: SVG path from [IconPath] for the feature. [onHomeTap]: called when the home button is tapped. [title]: the already translated title. Defaults to a coming soon title. [subtitle]: the already translated text under the title. Defaults to a general coming soon message.
class CustomComingSoon extends StatelessWidget {
  final String icon;
  final VoidCallback onHomeTap;
  final String? title;
  final String? subtitle;

  const CustomComingSoon({
    super.key,
    required this.icon,
    required this.onHomeTap,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSvgIcon(
              assetName: icon,
              width: getRadius(AppDimensions.avatarSize),
              height: getRadius(AppDimensions.avatarSize),
              color: colors.primary,
            ),
            SizedBox(height: getHeight(AppDimensions.space20)),
            CustomText(
              text: title ?? AppStrings.comingSoon.tr,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getHeight(AppDimensions.space8)),
            CustomText(
              text: subtitle ?? AppStrings.comingSoonMessage.tr,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getHeight(AppDimensions.space24)),
            CustomPillButton(
              icon: IconPath.home,
              text: AppStrings.navHome.tr,
              onTap: onHomeTap,
            ),
          ],
        ),
      ),
    );
  }
}

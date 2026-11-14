import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';

/// A centered placeholder for a feature that isn't ready yet: an icon, a title, a subtitle and a small home button, drawn by [CustomScreenState]. Params: [icon]: SVG path from [IconPath] for the feature. [onHomeTap]: called when the home button is tapped. [title]: the already translated title. Defaults to a coming soon title. [subtitle]: the already translated text under the title. Defaults to a general coming soon message.
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
    return CustomScreenState(
      icon: icon,
      title: title ?? AppStrings.comingSoon.tr,
      message: subtitle ?? AppStrings.comingSoonMessage.tr,
      actionText: AppStrings.navHome.tr,
      actionIcon: IconPath.home,
      onAction: onHomeTap,
    );
  }
}

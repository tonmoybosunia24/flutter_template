import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/profile/controller/profile_controller.dart';

/// The profile tab of the main screen. Shows placeholder content until the real design is added.
class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: CustomText(
          text: AppStrings.navProfile.tr,
          style: context.textTheme.titleLarge,
        ),
      ),
    );
  }
}

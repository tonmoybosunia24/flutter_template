import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/settings/controller/settings_controller.dart';

/// The settings tab of the main screen. Shows placeholder content until the real design is added.
class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: CustomText(
          text: AppStrings.navSettings.tr,
          style: context.textTheme.titleLarge,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/main/controller/main_controller.dart';
import 'package:template/features/main/widgets/main_app_bar.dart';
import 'package:template/features/settings/controller/settings_controller.dart';

/// The settings tab of the main screen. Shows placeholder content until the real design is added.
class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: CustomComingSoon(
        icon: IconPath.settings,
        onHomeTap: Get.find<MainController>().goHome,
      ),
    );
  }
}

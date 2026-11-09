import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/main/controller/main_controller.dart';
import 'package:template/features/main/widgets/main_app_bar.dart';
import 'package:template/features/notification/controller/notification_controller.dart';

/// The notifications tab of the main screen. Shows placeholder content until the real design is added.
class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: CustomComingSoon(
        icon: IconPath.notification,
        onHomeTap: Get.find<MainController>().goHome,
      ),
    );
  }
}

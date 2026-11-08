import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/notification/controller/notification_controller.dart';

/// The notifications tab of the main screen. Shows placeholder content until the real design is added.
class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: CustomText(
          text: AppStrings.navNotifications.tr,
          style: context.textTheme.titleLarge,
        ),
      ),
    );
  }
}

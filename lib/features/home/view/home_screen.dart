import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/home/controller/home_controller.dart';

/// The home tab of the main screen. Shows placeholder content until the real design is added.
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.navHome.tr,
        actions: [
          CustomAppBarAction(
            icon: IconPath.notification,
            tooltip: AppStrings.navNotifications.tr,
            onTap: () {},
          ),
        ],
      ),
      body: Center(
        child: CustomText(
          text: AppStrings.navHome.tr,
          style: context.textTheme.titleLarge,
        ),
      ),
    );
  }
}

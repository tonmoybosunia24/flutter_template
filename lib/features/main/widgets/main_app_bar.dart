import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/main/controller/main_controller.dart';

/// The profile-style app bar shared by the tabs of the main screen: the user's photo, name and greeting, with a notification button.
class MainAppBar extends GetView<MainController>
    implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: controller.userName,
      subtitle: AppStrings.homeWelcomeBack.tr,
      avatar: Image.asset(ImagePath.profileAvatar, fit: BoxFit.cover),
      actions: [
        CustomAppBarAction(
          icon: IconPath.notification,
          tooltip: AppStrings.navNotifications.tr,
          onTap: () {},
        ),
      ],
    );
  }
}

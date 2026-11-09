import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/features/home/view/home_screen.dart';
import 'package:template/features/main/controller/main_controller.dart';
import 'package:template/features/main/widgets/main_bottom_nav.dart';
import 'package:template/features/notification/view/notification_screen.dart';
import 'package:template/features/profile/view/profile_screen.dart';
import 'package:template/features/search/view/search_screen.dart';
import 'package:template/features/settings/view/settings_screen.dart';

/// The app's main shell: shows the selected tab above the bottom navigation bar. IndexedStack keeps every tab alive, so scroll position and state survive switching tabs.
class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeScreen(),
            SearchScreen(),
            NotificationScreen(),
            SettingsScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: const MainBottomNav(),
    );
  }
}

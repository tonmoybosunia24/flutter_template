import 'package:get/get.dart';
import 'package:template/core/core.dart';
import 'package:template/features/main/model/main_tab_item.dart';

/// Manages the main screen's bottom navigation: the list of tabs and which one is selected. The order of [tabs] must match the screens in `MainScreen`.
class MainController extends GetxController {
  final List<MainTabItem> tabs = const [
    MainTabItem(icon: IconPath.home, label: AppStrings.navHome),
    MainTabItem(icon: IconPath.search, label: AppStrings.navSearch),
    MainTabItem(icon: IconPath.notification, label: AppStrings.navNotifications),
    MainTabItem(icon: IconPath.settings, label: AppStrings.navSettings),
    MainTabItem(icon: IconPath.user, label: AppStrings.navProfile),
  ];

  // Placeholder until login provides the user.
  final String userName = 'Tonmoy Bosunia';

  // Index of the currently selected tab.
  final RxInt currentIndex = 0.obs;

  // Switches to the tab at [index].
  void changeTab(int index) => currentIndex.value = index;
}

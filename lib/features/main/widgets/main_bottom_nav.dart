import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/core.dart';
import 'package:template/features/main/controller/main_controller.dart';
import 'package:template/features/main/widgets/main_bottom_nav_item.dart';

/// The bottom navigation bar of the main screen: a row of equal tab slots on the app background, with a top border and a soft upward shadow.
class MainBottomNav extends GetView<MainController> {
  const MainBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(
          top: BorderSide(
            color: colors.border.withValues(alpha: 0.5),
            width: AppDimensions.borderWidth1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.bottomNavShadow,
            offset: Offset(0, -4),
            blurRadius: 23.5,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: getHeight(AppDimensions.padding14)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getWidth(AppDimensions.padding10),
          ),
          child: Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (index, tab) in controller.tabs.indexed)
                  Expanded(
                    child: MainBottomNavItem(
                      tab: tab,
                      isSelected: controller.currentIndex.value == index,
                      onTap: () => controller.changeTab(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/main/model/main_tab_item.dart';

/// A single tab in the main bottom navigation bar: icon above label. The whole slot is tappable, and long translated labels shrink to fit it. Params: [tab]: the icon and label of this tab. [isSelected]: shows the tab in the primary color. [onTap]: called when the tab is tapped.
class MainBottomNavItem extends StatelessWidget {
  final MainTabItem tab;
  final bool isSelected;
  final VoidCallback onTap;

  const MainBottomNavItem({
    super.key,
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          top: getHeight(AppDimensions.padding16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSvgIcon(
              assetName: tab.icon,
              width: getRadius(AppDimensions.icon20),
              height: getRadius(AppDimensions.icon20),
              color: isSelected ? colors.primary : colors.textMuted,
            ),
            SizedBox(height: getHeight(AppDimensions.space4)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: CustomText(
                text: tab.label.tr,
                style: isSelected ? textTheme.labelMedium : textTheme.bodyMedium,
                color: isSelected ? colors.primary : colors.textMuted,
                maxLines: 1,
                strutStyle: StrutStyle(
                  fontFamily: textTheme.bodyMedium?.fontFamily,
                  fontSize: getSp(AppDimensions.font14),
                  forceStrutHeight: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

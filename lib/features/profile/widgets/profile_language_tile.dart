import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// One language row on the language screen: [name] in its own language, [subtitle] as its translated name, and a radio on the end side. When [isSelected] the row is tinted and the radio shows a tick.
class ProfileLanguageTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const ProfileLanguageTile({
    super.key,
    required this.name,
    required this.subtitle,
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
      child: Container(
        color: isSelected ? colors.primary.withValues(alpha: 0.07) : null,
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(AppDimensions.padding20),
          vertical: getHeight(AppDimensions.padding14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: name,
                    style: textTheme.titleSmall,
                    fontWeight: isSelected ? null : FontWeight.w500,
                    color: isSelected ? colors.primary : null,
                    // The same strut for both states, so the row doesn't shift when the font weight changes.
                    strutStyle: StrutStyle(
                      fontFamily: textTheme.titleSmall?.fontFamily,
                      fontSize: getSp(AppDimensions.font15),
                      forceStrutHeight: true,
                    ),
                  ),
                  CustomText(
                    text: subtitle,
                    style: textTheme.bodySmall,
                    color: colors.textMuted,
                  ),
                ],
              ),
            ),
            SizedBox(width: getWidth(AppDimensions.space12)),
            Container(
              width: getRadius(AppDimensions.icon24),
              height: getRadius(AppDimensions.icon24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? colors.primary : null,
                border: isSelected
                    ? null
                    : Border.all(
                        color: colors.textHint.withValues(alpha: 0.5),
                        width: AppDimensions.borderWidth2,
                      ),
              ),
              child: isSelected
                  ? CustomSvgIcon(
                      assetName: IconPath.check,
                      width: getRadius(AppDimensions.icon16),
                      height: getRadius(AppDimensions.icon16),
                      color: AppColors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

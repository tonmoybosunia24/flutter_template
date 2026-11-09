import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// A small rounded button with an icon and a label, filled with the theme's primary gradient. Params: [icon]: SVG path from [IconPath]. [text]: the already translated label. [onTap]: called when the button is tapped.
class CustomPillButton extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onTap;

  const CustomPillButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: getRadius(AppDimensions.iconContainerSize),
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(AppDimensions.padding20),
        ),
        decoration: BoxDecoration(
          gradient: colors.primaryGradient,
          borderRadius: BorderRadius.circular(
            getRadius(AppDimensions.radius100),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSvgIcon(
              assetName: icon,
              width: getRadius(AppDimensions.icon18),
              height: getRadius(AppDimensions.icon18),
              color: colors.onPrimary,
            ),
            SizedBox(width: getWidth(AppDimensions.space6)),
            CustomText(
              text: text,
              style: context.textTheme.labelMedium,
              color: colors.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

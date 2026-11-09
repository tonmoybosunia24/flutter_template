import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// A circular social sign-in button (Facebook, Google, ...) used across the auth flow. Params: [icon]: brand SVG from [IconPath], shown in its original colors. [iconSize]: size of the icon inside the button. [onTap]: called when the button is tapped.
class AuthSocialButton extends StatelessWidget {
  final String icon;
  final double iconSize;
  final VoidCallback onTap;

  const AuthSocialButton({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final size = getRadius(AppDimensions.iconButtonSize);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: colors.border,
            width: AppDimensions.borderWidth1,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: CustomSvgIcon(
          assetName: icon,
          width: getRadius(iconSize),
          height: getRadius(iconSize),
        ),
      ),
    );
  }
}

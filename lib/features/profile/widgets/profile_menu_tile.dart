import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// A single row in a profile section. Params: [icon]: SVG path from [IconPath], shown on the start side. [title]: the already translated label next to the icon. [value]: optional text before the arrow. Ignored when [trailing] is given. [trailing]: replaces the arrow on the end side. [onTap]: makes the whole row tappable.
class ProfileMenuTile extends StatelessWidget {
  final String icon;
  final String title;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          CustomSvgIcon(
            assetName: icon,
            width: getRadius(AppDimensions.icon24),
            height: getRadius(AppDimensions.icon24),
            color: colors.primary,
          ),
          SizedBox(width: getWidth(AppDimensions.space12)),
          Expanded(
            child: CustomText(
              text: title,
              style: textTheme.bodyLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: getWidth(AppDimensions.space8)),
          trailing ??
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (value != null) ...[
                    CustomText(
                      text: value!,
                      style: textTheme.bodyMedium,
                      color: colors.textMuted,
                    ),
                    SizedBox(width: getWidth(AppDimensions.space6)),
                  ],
                  Transform.flip(
                    flipX: Directionality.of(context) == TextDirection.rtl,
                    child: CustomSvgIcon(
                      assetName: IconPath.arrowRight,
                      width: getRadius(AppDimensions.icon20),
                      height: getRadius(AppDimensions.icon20),
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}

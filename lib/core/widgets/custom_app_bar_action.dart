import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// A round icon button for [CustomAppBar], used for the back arrow and the end-side actions. [icon] is an SVG path from [IconPath], [onTap] is the tap callback, [tooltip] is the already translated label for accessibility, and [flipInRtl] mirrors directional icons in right-to-left languages.
class CustomAppBarAction extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool flipInRtl;

  const CustomAppBarAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.flipInRtl = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: colors.surface,
        fixedSize: Size.square(getRadius(AppDimensions.appBarActionSize)),
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(
          color: colors.border.withValues(alpha: 0.5),
          width: AppDimensions.borderWidth1,
        ),
      ),
      icon: Transform.flip(
        flipX: flipInRtl && Directionality.of(context) == TextDirection.rtl,
        child: CustomSvgIcon(
          assetName: icon,
          width: getRadius(AppDimensions.icon24),
          height: getRadius(AppDimensions.icon24),
          color: colors.textPrimary,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// A round photo inside a thin ring of the theme's primary gradient. Params: [child]: the photo, which fills the circle. [size]: outer diameter, including the ring. Defaults to [AppDimensions.iconContainerSize].
class CustomRingAvatar extends StatelessWidget {
  final Widget child;
  final double size;

  const CustomRingAvatar({
    super.key,
    required this.child,
    this.size = AppDimensions.iconContainerSize,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: getRadius(size),
      height: getRadius(size),
      padding: EdgeInsets.all(AppDimensions.borderWidth2),
      decoration: BoxDecoration(
        gradient: colors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.borderWidth2),
        decoration: BoxDecoration(
          color: colors.background,
          shape: BoxShape.circle,
        ),
        child: ClipOval(child: child),
      ),
    );
  }
}

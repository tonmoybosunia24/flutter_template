import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// One grey block of a loading placeholder, standing in for a line of text, an image or an avatar. Place it inside a [CustomSkeleton]. Params: [width]: width from [AppDimensions]. Fills the available width when null. [height]: height from [AppDimensions]. Fills the available height when null. [radius]: corner radius from [AppDimensions]. Defaults to [AppDimensions.radius8]. [isCircle]: draws a circle whose diameter is [width].
class CustomSkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;
  final bool isCircle;

  const CustomSkeletonBox({
    super.key,
    this.width,
    this.height,
    this.radius = AppDimensions.radius8,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (isCircle) {
      return Container(
        width: getRadius(width ?? AppDimensions.iconContainerSize),
        height: getRadius(width ?? AppDimensions.iconContainerSize),
        decoration: BoxDecoration(
          color: colors.outline,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      width: width == null ? double.infinity : getWidth(width!),
      height: height == null ? double.infinity : getHeight(height!),
      decoration: BoxDecoration(
        color: colors.outline,
        borderRadius: BorderRadius.circular(getRadius(radius)),
      ),
    );
  }
}

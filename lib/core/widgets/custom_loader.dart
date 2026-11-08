import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// A reusable loading indicator that continuously rotates the app's loading SVG icon. [size] sets the icon size (defaults to [AppDimensions.icon30]), [color] tints the icon (defaults to the theme's primary color), and [duration] controls the time for one full rotation.
class CustomLoader extends StatefulWidget {
  final double? size;
  final Color? color;
  final Duration duration;

  const CustomLoader({
    super.key,
    this.size,
    this.color,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

/// The state class for [CustomLoader] that manages the rotation animation.
class _CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void didUpdateWidget(covariant CustomLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller
        ..duration = widget.duration
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Builds the widget tree for the [CustomLoader], applying a rotation transition to the loading icon.
  @override
  Widget build(BuildContext context) {
    final size = getRadius(widget.size ?? AppDimensions.icon30);

    return RotationTransition(
      turns: _controller,
      child: CustomSvgIcon(
        assetName: IconPath.loading,
        width: size,
        height: size,
        color: widget.color ?? context.appColors.primary,
      ),
    );
  }
}

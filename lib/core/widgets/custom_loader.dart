import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// A loading indicator that continuously rotates the app's loading SVG icon. Params: [size]: icon size. Defaults to [AppDimensions.icon30]. [color]: icon tint. Defaults to the theme's primary color. [duration]: time for one full rotation. Defaults to 2 seconds.
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

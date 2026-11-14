import 'package:flutter/material.dart';

/// Wraps a loading placeholder built from [CustomSkeletonBox]es: pulses it softly and lets screen readers hear one label instead of nothing. Params: [label]: the already translated text read by screen readers, such as "Loading posts". [child]: the placeholder, shaped like the content it stands in for so nothing jumps when the content arrives.
class CustomSkeleton extends StatefulWidget {
  final String label;
  final Widget child;

  const CustomSkeleton({super.key, required this.label, required this.child});

  @override
  State<CustomSkeleton> createState() => _CustomSkeletonState();
}

/// The state of [CustomSkeleton] that runs the pulse animation.
class _CustomSkeletonState extends State<CustomSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  late final Animation<double> _opacity = Tween<double>(
    begin: 0.45,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Users who turned off animations get a still placeholder.
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      container: true,
      liveRegion: true,
      label: widget.label,
      child: ExcludeSemantics(
        child: IgnorePointer(
          child: reduceMotion
              ? widget.child
              : FadeTransition(opacity: _opacity, child: widget.child),
        ),
      ),
    );
  }
}

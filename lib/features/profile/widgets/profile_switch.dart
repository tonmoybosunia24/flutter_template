import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// The small pill-shaped toggle used in the profile rows. Params: [value]: the current state. [onChanged]: called when the switch is tapped.
class ProfileSwitch extends StatelessWidget {
  final bool value;
  final VoidCallback onChanged;

  const ProfileSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const Duration _animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Semantics(
      toggled: value,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged,
        child: AnimatedContainer(
          duration: _animationDuration,
          curve: Curves.easeInOut,
          width: getRadius(AppDimensions.switchWidth),
          padding: const EdgeInsets.all(AppDimensions.switchPadding),
          decoration: BoxDecoration(
            color: value ? colors.primary : colors.textHint,
            borderRadius: BorderRadius.circular(
              getRadius(AppDimensions.radius100),
            ),
          ),
          child: AnimatedAlign(
            duration: _animationDuration,
            curve: Curves.easeInOut,
            alignment: value
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            heightFactor: 1,
            child: Container(
              width: getRadius(AppDimensions.icon16),
              height: getRadius(AppDimensions.icon16),
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

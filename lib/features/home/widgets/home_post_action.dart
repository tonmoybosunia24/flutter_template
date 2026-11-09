import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// An icon-only button in the action row of a post. Params: [icon]: SVG path from [IconPath]. [label]: the already translated name read by screen readers. [color]: color of the icon. [onTap]: called when the button is tapped.
class HomePostAction extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const HomePostAction({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(getRadius(AppDimensions.padding8)),
          child: CustomSvgIcon(
            assetName: icon,
            width: getRadius(AppDimensions.icon24),
            height: getRadius(AppDimensions.icon24),
            color: color,
          ),
        ),
      ),
    );
  }
}

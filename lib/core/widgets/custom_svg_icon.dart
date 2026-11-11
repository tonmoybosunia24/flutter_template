import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Displays an SVG asset, optionally tinted. Params: [assetName]: path of the SVG asset, usually from [IconPath]. [width]: icon width. [height]: icon height. [color]: tints the whole icon. Leave null to keep the SVG's own colors.
class CustomSvgIcon extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;

  const CustomSvgIcon({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}

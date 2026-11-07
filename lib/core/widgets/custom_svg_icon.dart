import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


/// A reusable widget for displaying SVG icons. [assetName] is the path to the SVG asset, [width] and [height] allow for custom sizing, and [color] allows for color customization of the SVG.
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

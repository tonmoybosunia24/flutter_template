import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// A reusable text widget that allows for custom styling, including font size, weight, color, alignment, and overflow handling. [text] is the string to display, [style] allows for a custom TextStyle, [fontSize], [fontWeight], and [color] provide additional customization options, while [textAlign], [maxLines], and [overflow] control the text layout and behavior, and [strutStyle] can force fixed line metrics.
class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final StrutStyle? strutStyle;

  const CustomText({
    super.key,
    required this.text,
    this.style,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.strutStyle,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        style ?? context.textTheme.bodyLarge ?? const TextStyle();

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      strutStyle: strutStyle,
      style: baseStyle.copyWith(
        fontSize: getSp(fontSize ?? baseStyle.fontSize ?? AppDimensions.font14),
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

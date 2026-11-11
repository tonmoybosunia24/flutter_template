import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// The app's text widget: applies a text style and scales its font size for the screen. Params: [text]: the string to display. [style]: base text style. Defaults to the theme's bodyLarge. [fontSize]: overrides the size of [style]. [fontWeight]: overrides the weight of [style]. [color]: overrides the color of [style]. [textAlign]: horizontal alignment of the text. [maxLines]: maximum number of lines. [overflow]: how text that doesn't fit is handled. [strutStyle]: forces fixed line metrics.
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
    final baseStyle = style ?? context.textTheme.bodyLarge ?? const TextStyle();

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

import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// A reusable primary button widget that supports loading states, optional icons, and custom styling. [text] is the button label, [onPressed] is the callback when the button is tapped, [isLoading] indicates if a loading spinner should be shown, [color] and [textColor] allow for custom colors, [icon] allows for an optional icon, and [borderRadius] allows for custom corner rounding.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.textColor,
    this.icon,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return SizedBox(
      width: double.infinity,
      height: getHeight(AppDimensions.buttonHeight),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? colors.primary,
          foregroundColor: textColor ?? colors.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              getRadius(borderRadius ?? AppDimensions.radius100),
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: getRadius(AppDimensions.icon24),
                width: getRadius(AppDimensions.icon24),
                child: CircularProgressIndicator(
                  color: textColor ?? colors.onPrimary,
                  strokeWidth: AppDimensions.borderWidth2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: textColor ?? colors.onPrimary,
                      size: getRadius(AppDimensions.icon20),
                    ),
                    SizedBox(width: getWidth(AppDimensions.space8)),
                  ],
                  CustomText(
                    text: text,
                    style: textTheme.labelLarge,
                    color: textColor ?? colors.onPrimary,
                  ),
                ],
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/utils/app_size_class.dart';

/// Helper methods on [String].
extension StringExtension on String {
  // Uppercases the first letter and lowercases the rest.
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

/// Quick access to common screen and theme values from a [BuildContext].
extension ContextExtension on BuildContext {
  // Quick access to screen height.
  double get screenHeight => MediaQuery.sizeOf(this).height;
  // Quick access to screen width.
  double get screenWidth => MediaQuery.sizeOf(this).width;
  // Quick access to the AppSizeClass instance for responsive design.
  AppSizeClass get sz => AppSizeClass.instance;
  // Quick access to the global theme data.
  ThemeData get theme => Theme.of(this);
  // Quick access to text theme.
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  // Quick access to the current theme's color scheme (e.g., context.appColors.primary).
  AppColorScheme get appColors =>
      Theme.of(this).extension<AppColorScheme>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? AppColorScheme.dark
          : AppColorScheme.light);
}

import 'package:flutter/material.dart';

/// Raw color constants of the application. Widgets should use the semantic colors of the active theme instead, through `context.appColors` (see [AppColorScheme]).
class AppColors {

  // Common utility colors.
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // The light and dark theme's primary colors.
  static const Color primaryLight = Color(0xFFFA4A0C);
  static const Color primaryDark = Color(0xFFFF6D3A);

  // The light and dark theme's foreground color on primary surfaces (buttons, badges).
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onPrimaryDark = Color(0xFFFFFFFF);

  // The light and dark theme's primary variant colors.
  static const Color primaryVariantLight = Color(0xFFD93B04);
  static const Color primaryVariantDark = Color(0xFFFA4A0C);

  // The light and dark theme's secondary colors.
  static const Color secondaryLight = Color(0xFF1BAC4B);
  static const Color secondaryDark = Color(0xFF34C759);

  // The light and dark theme's secondary variant colors.
  static const Color secondaryVariantLight = Color(0xFF263238);
  static const Color secondaryVariantDark = Color(0xFF37474F);

  // The light and dark theme's background colors.
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF0F1117);

  // The light and dark theme's surface colors (cards, sheets, bottom bar).
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1D2B);

  // The light and dark theme's surface variant colors.
  static const Color surfaceVariantLight = Color(0xFFF5F5F5);
  static const Color surfaceVariantDark = Color(0xFF252838);

  // The light and dark theme's elevated surface colors (dialogs, bottom sheets, elevated cards).
  static const Color elevatedSurfaceLight = Color(0xFFFEFEFD);
  static const Color elevatedSurfaceDark = Color(0xFF21253A);

  // The light and dark theme's app bar colors.
  static const Color appBarLight = Color(0xFFF5F5F5);
  static const Color appBarDark = Color(0xFF1A1D2B);

  // The light and dark theme's border colors.
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF363946);

  // The light and dark theme's outline colors.
  static const Color outlineLight = Color(0xFFE2E2E2);
  static const Color outlineDark = Color(0xFF323955);

  // The light and dark theme's divider colors.
  static const Color dividerLight = Color(0xFFDADADA);
  static const Color dividerDark = Color(0xFF2A2E45);

  // The light and dark theme's primary text colors.
  static const Color textPrimaryLight = Color(0xFF090A1C);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);

  // The light and dark theme's secondary text colors.
  static const Color textSecondaryLight = Color(0xFF616161);
  static const Color textSecondaryDark = Color(0xFFA0A4B8);

  // The light and dark theme's muted text colors.
  static const Color textMutedLight = Color(0xFF7E7D7D);
  static const Color textMutedDark = Color(0xFF8A8E9E);

  // The light and dark theme's hint text colors.
  static const Color textHintLight = Color(0xFF9E9E9E);
  static const Color textHintDark = Color(0xFF6E7285);

  // The light and dark theme's success status colors.
  static const Color successLight = Color(0xFF34C759);
  static const Color successDark = Color(0xFF34C759);

  // The light and dark theme's warning status colors.
  static const Color warningLight = Color(0xFFFFCC00);
  static const Color warningDark = Color(0xFFFFD60A);

  // The light and dark theme's error status colors.
  static const Color errorLight = Color(0xFFFF383C);
  static const Color errorDark = Color(0xFFFF453A);

  // The light and dark theme's info status colors.
  static const Color infoLight = Color(0xFF0277BD);
  static const Color infoDark = Color(0xFF29B6F6);

  // The light theme's soft status background colors.
  static const Color successSoftLight = Color(0x3334C759); // rgba(52, 199, 89, 0.2)
  static const Color warningSoftLight = Color(0x33FFCC00); // rgba(255, 204, 0, 0.2)
  static const Color errorSoftLight = Color(0x33FF383C); // rgba(255, 56, 60, 0.2)
  static const Color primarySoftLight = Color(0x1AFA4A0C); // rgba(250, 74, 12, 0.1)

  // The light and dark theme's overlay colors.
  static const Color overlayLight = Color(0x1AFA4A0C); // primary 10%
  static const Color overlayDark = Color(0x1AFF6D3A); // primary 10%

  // The light and dark theme's scrim colors for modals and barriers.
  static const Color scrimLight = Color(0xB3000000); // rgba(0, 0, 0, 0.7)
  static const Color scrimDark = Color(0xCC000000);

  // The shadow colors for buttons, cards, and bottom navigation.
  static const Color primaryShadow = Color(0x1AFA4A0C); // 0px 4px 4px rgba(250, 74, 12, 0.1)
  static const Color cardShadow = Color(0x1A100E0E); // rgba(16, 14, 14, 0.1)
  static const Color cardShadowDark = Color(0x73000000); // rgba(0, 0, 0, 0.45)
  static const Color bottomNavShadow = Color(0x0F989292); // rgba(152, 146, 146, 0.06)

  // The light theme's primary linear gradient.
  static const LinearGradient primaryGradientLight = LinearGradient(
    colors: [Color(0xFFFA4A0C), Color(0xFFFF6D3A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // The dark theme's primary linear gradient.
  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [Color(0xFFFF6D3A), Color(0xFFFA4A0C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// The semantic colors of a theme, available through `context.appColors` or `Theme.of(context).extension<AppColorScheme>()`. Use [AppColorScheme.light] or [AppColorScheme.dark]. Each field is one named color role of the theme.
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final Color primary;
  final Color onPrimary;
  final Color primaryVariant;
  final Color secondary;
  final Color secondaryVariant;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color elevatedSurface;
  final Color appBar;
  final Color border;
  final Color outline;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textHint;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color overlay;
  final Color scrim;
  final LinearGradient primaryGradient;

  // Creates an instance of AppColorScheme with the required semantic colors.
  const AppColorScheme({
    required this.primary,
    required this.onPrimary,
    required this.primaryVariant,
    required this.secondary,
    required this.secondaryVariant,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.elevatedSurface,
    required this.appBar,
    required this.border,
    required this.outline,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textHint,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.overlay,
    required this.scrim,
    required this.primaryGradient,
  });

  // The semantic color scheme configuration for the light theme.
  static const AppColorScheme light = AppColorScheme(
    primary: AppColors.primaryLight,
    onPrimary: AppColors.onPrimaryLight,
    primaryVariant: AppColors.primaryVariantLight,
    secondary: AppColors.secondaryLight,
    secondaryVariant: AppColors.secondaryVariantLight,
    background: AppColors.backgroundLight,
    surface: AppColors.surfaceLight,
    surfaceVariant: AppColors.surfaceVariantLight,
    elevatedSurface: AppColors.elevatedSurfaceLight,
    appBar: AppColors.appBarLight,
    border: AppColors.borderLight,
    outline: AppColors.outlineLight,
    divider: AppColors.dividerLight,
    textPrimary: AppColors.textPrimaryLight,
    textSecondary: AppColors.textSecondaryLight,
    textMuted: AppColors.textMutedLight,
    textHint: AppColors.textHintLight,
    success: AppColors.successLight,
    warning: AppColors.warningLight,
    error: AppColors.errorLight,
    info: AppColors.infoLight,
    overlay: AppColors.overlayLight,
    scrim: AppColors.scrimLight,
    primaryGradient: AppColors.primaryGradientLight,
  );

  // The semantic color scheme configuration for the dark theme.
  static const AppColorScheme dark = AppColorScheme(
    primary: AppColors.primaryDark,
    onPrimary: AppColors.onPrimaryDark,
    primaryVariant: AppColors.primaryVariantDark,
    secondary: AppColors.secondaryDark,
    secondaryVariant: AppColors.secondaryVariantDark,
    background: AppColors.backgroundDark,
    surface: AppColors.surfaceDark,
    surfaceVariant: AppColors.surfaceVariantDark,
    elevatedSurface: AppColors.elevatedSurfaceDark,
    appBar: AppColors.appBarDark,
    border: AppColors.borderDark,
    outline: AppColors.outlineDark,
    divider: AppColors.dividerDark,
    textPrimary: AppColors.textPrimaryDark,
    textSecondary: AppColors.textSecondaryDark,
    textMuted: AppColors.textMutedDark,
    textHint: AppColors.textHintDark,
    success: AppColors.successDark,
    warning: AppColors.warningDark,
    error: AppColors.errorDark,
    info: AppColors.infoDark,
    overlay: AppColors.overlayDark,
    scrim: AppColors.scrimDark,
    primaryGradient: AppColors.primaryGradientDark,
  );

  // Creates a copy of this AppColorScheme with the given fields replaced by new values.
  @override
  AppColorScheme copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryVariant,
    Color? secondary,
    Color? secondaryVariant,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? elevatedSurface,
    Color? appBar,
    Color? border,
    Color? outline,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textHint,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? overlay,
    Color? scrim,
    LinearGradient? primaryGradient,
  }) {
    return AppColorScheme(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryVariant: primaryVariant ?? this.primaryVariant,
      secondary: secondary ?? this.secondary,
      secondaryVariant: secondaryVariant ?? this.secondaryVariant,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      appBar: appBar ?? this.appBar,
      border: border ?? this.border,
      outline: outline ?? this.outline,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textHint: textHint ?? this.textHint,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      overlay: overlay ?? this.overlay,
      scrim: scrim ?? this.scrim,
      primaryGradient: primaryGradient ?? this.primaryGradient,
    );
  }

  // Linearly interpolates between two AppColorScheme instances during theme transitions.
  @override
  AppColorScheme lerp(AppColorScheme? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryVariant: Color.lerp(primaryVariant, other.primaryVariant, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryVariant: Color.lerp(
        secondaryVariant,
        other.secondaryVariant,
        t,
      )!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      elevatedSurface: Color.lerp(elevatedSurface, other.elevatedSurface, t)!,
      appBar: Color.lerp(appBar, other.appBar, t)!,
      border: Color.lerp(border, other.border, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      primaryGradient: t < 0.5 ? primaryGradient : other.primaryGradient,
    );
  }
}

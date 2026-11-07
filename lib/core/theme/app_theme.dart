import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/utils/app_dimensions.dart';

/// This class defines the light and dark themes for the application using a shared theme builder. Both [AppTheme.light] and [AppTheme.dark] are generated from [_buildTheme] using [AppColorScheme.light] and [AppColorScheme.dark].
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Light theme configuration for the application.
  static ThemeData get light => _buildTheme(
        brightness: Brightness.light,
        colors: AppColorScheme.light,
      );

  // Dark theme configuration for the application.
  static ThemeData get dark => _buildTheme(
        brightness: Brightness.dark,
        colors: AppColorScheme.dark,
      );

  // Common helper method to build both light and dark themes from an AppColorScheme.
  static ThemeData _buildTheme({
    required Brightness brightness,
    required AppColorScheme colors,
  }) {
    final isDark = brightness == Brightness.dark;
    final base = isDark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    return base.copyWith(
      // Core brightness & background colors
      brightness: brightness,
      primaryColor: colors.primary,
      scaffoldBackgroundColor: colors.background,

      // Material 3 ColorScheme mapping
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        primaryContainer: colors.primaryVariant,
        secondary: colors.secondary,
        secondaryContainer: colors.secondaryVariant,
        error: colors.error,
        surface: colors.surface,
        onPrimary: AppColors.surfaceLight,
        onSecondary: AppColors.surfaceLight,
        onSurface: colors.textPrimary,
        onError: AppColors.surfaceLight,
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colors.appBar,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: AppDimensions.font18,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
        ),
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: isDark ? 0 : 2,
        shadowColor: isDark ? colors.scrim : AppColors.cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius20),
          side: BorderSide(
            color: colors.border,
            width: AppDimensions.borderWidth1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: AppDimensions.borderWidth1,
        space: 0,
      ),

      // Typography & Text styles
      textTheme: base.textTheme
          .apply(fontFamily: GoogleFonts.poppins().fontFamily)
          .copyWith(
        displayLarge: GoogleFonts.poppins(
          color: colors.textPrimary,
          fontSize: AppDimensions.font33,
          fontWeight: FontWeight.w500,
        ),
        displayMedium: GoogleFonts.poppins(
          color: colors.textPrimary,
          fontSize: AppDimensions.font30,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: GoogleFonts.poppins(
          color: colors.textPrimary,
          fontSize: AppDimensions.font20,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: GoogleFonts.poppins(
          color: colors.textPrimary,
          fontSize: AppDimensions.font16,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: GoogleFonts.poppins(
          color: colors.textPrimary,
          fontSize: AppDimensions.font15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: colors.textPrimary,
          fontSize: AppDimensions.font16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: colors.textSecondary,
          fontSize: AppDimensions.font14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.poppins(
          color: colors.textHint,
          fontSize: AppDimensions.font12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.urbanist(
          color: colors.textPrimary,
          fontSize: AppDimensions.font16,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: GoogleFonts.poppins(
          color: colors.textSecondary,
          fontSize: AppDimensions.font11,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Elevated button theme (Primary pill buttons)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: AppColors.surfaceLight,
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.padding20,
            vertical: AppDimensions.padding12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius100),
          ),
          elevation: 0,
          shadowColor: AppColors.primaryShadow,
          textStyle: GoogleFonts.urbanist(
            fontSize: AppDimensions.font16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.padding20,
            vertical: AppDimensions.padding12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius100),
          ),
          side: BorderSide(
            color: colors.border,
            width: AppDimensions.borderWidth1,
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: AppDimensions.font16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: GoogleFonts.poppins(
            fontSize: AppDimensions.font16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // TextFormField & InputDecoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        hintStyle: GoogleFonts.poppins(
          color: colors.textHint,
          fontSize: AppDimensions.font14,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.padding20,
          vertical: AppDimensions.padding16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius30),
          borderSide: BorderSide(
            color: colors.border,
            width: AppDimensions.borderWidth1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius30),
          borderSide: BorderSide(
            color: colors.border,
            width: AppDimensions.borderWidth1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius30),
          borderSide: BorderSide(
            color: colors.primary,
            width: AppDimensions.borderWidth15,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius30),
          borderSide: BorderSide(
            color: colors.error,
            width: AppDimensions.borderWidth1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius30),
          borderSide: BorderSide(
            color: colors.error,
            width: AppDimensions.borderWidth15,
          ),
        ),
      ),

      // Modal bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceVariant,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radius40),
          ),
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.textHint,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: AppDimensions.font12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: AppDimensions.font12,
          fontWeight: FontWeight.w400,
        ),
        elevation: 8,
      ),

      // SnackBar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.elevatedSurface,
        contentTextStyle: GoogleFonts.poppins(
          color: colors.textPrimary,
          fontSize: AppDimensions.font14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Custom theme extensions
      extensions: [colors],
    );
  }
}

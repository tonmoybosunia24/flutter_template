import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The device categories used for responsive layouts.
enum ScreenType { mobile, tablet, desktop, tv }

// Global helper functions for responsive sizing.
// Call [AppSizeClass.init] in the app's builder before using them.

/// Scales [size] with the screen height.
double getHeight(double size) => AppSizeClass.instance.getHeight(size);
/// Scales [size] with the screen width.
double getWidth(double size) => AppSizeClass.instance.getWidth(size);
/// Scales the font [size] with the screen.
double getSp(double size) => AppSizeClass.instance.getSp(size);
/// Scales a corner radius or icon [size] with the smaller screen side.
double getRadius(double size) => AppSizeClass.instance.getRadius(size);

/// Returns the value for the current screen type, falling back to the next smaller size that was given.
T getValue<T>({required T mobile, T? tablet, T? desktop, T? tv}) => AppSizeClass
    .instance
    .getValue(mobile: mobile, tablet: tablet, desktop: desktop, tv: tv);

// Global screen utility getters

/// The current screen width in logical pixels.
double get screenWidth => AppSizeClass.instance.screenWidth;
/// The current screen height in logical pixels.
double get screenHeight => AppSizeClass.instance.screenHeight;
/// The horizontal page padding for the current screen type.
double get horizontalPadding => AppSizeClass.instance.horizontalPadding;
/// The maximum content width for the current screen type.
double get maxContentWidth => AppSizeClass.instance.maxContentWidth;

// Global screen type checks

/// Whether the screen is mobile sized.
bool get isMobile => AppSizeClass.instance.isMobile;
/// Whether the screen is tablet sized.
bool get isTablet => AppSizeClass.instance.isTablet;
/// Whether the screen is desktop sized.
bool get isDesktop => AppSizeClass.instance.isDesktop;
/// Whether the screen is TV sized.
bool get isTV => AppSizeClass.instance.isTV;

/// The responsive sizing system: works out the screen type and scale factor from the screen width. Created with [AppSizeClass.init] and read through [AppSizeClass.instance] or the global helpers above.
class AppSizeClass {

  // Singleton instance of AppSizeClass
  static AppSizeClass? _instance;
  
  // Screen dimensions and type
  final double screenWidth;
  final double screenHeight;
  final ScreenType screenType;
  final double scaleFactor;

  // Private constructor to initialize the AppSizeClass with screen dimensions and type.
  AppSizeClass._({
    required this.screenWidth,
    required this.screenHeight,
    required this.screenType,
    required this.scaleFactor,
  });

  // The global singleton instance.
  static AppSizeClass get instance {
    assert(
      _instance != null,
      'AppSizeClass must be initialized by calling AppSizeClass.init(context) in your App build method.',
    );
    return _instance!;
  }

  // Initialize the responsive system.
  static void init(BuildContext context) {

    // Get the screen size from the MediaQuery
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    // Determine the screen type and scaling factor based on the width
    final ScreenType type;
    final double scale;

    if (width < 600) {
      type = ScreenType.mobile;
      scale = (width / 412).clamp(0.8, 1.2);
    } else if (width < 1024) {
      type = ScreenType.tablet;
      scale = (width / 768).clamp(1.0, 1.4);
    } else if (width < 1440) {
      type = ScreenType.desktop;
      scale = (width / 1280).clamp(1.1, 1.6);
    } else {
      type = ScreenType.tv;
      scale = (width / 1920).clamp(1.4, 2.2);
    }

    // Create the singleton instance with the calculated values
    _instance = AppSizeClass._(
      screenWidth: width,
      screenHeight: height,
      screenType: type,
      scaleFactor: scale,
    );
  }

  // Type checks
  bool get isMobile => screenType == ScreenType.mobile;
  bool get isTablet => screenType == ScreenType.tablet;
  bool get isDesktop => screenType == ScreenType.desktop;
  bool get isTV => screenType == ScreenType.tv;
  bool get isLarge => screenWidth >= 600;

  // Responsive value methods
  double getSp(double size) => size.sp;
  double getWidth(double size) => size.w;
  double getHeight(double size) => size.h;
  double getRadius(double size) => size.r;

  // Get a value based on the current screen type. It takes different values for mobile, tablet, desktop, and TV, and returns the appropriate one based on the current screen type.
  T getValue<T>({required T mobile, T? tablet, T? desktop, T? tv}) {
    switch (screenType) {
      case ScreenType.tv:
        return tv ?? desktop ?? tablet ?? mobile;
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.mobile:
        return mobile;
    }
  }

  // Get the maximum content width based on the current screen type. This is useful for setting constraints on content layout to ensure it looks good on different devices.
  double get maxContentWidth {
    switch (screenType) {
      case ScreenType.mobile:
        return screenWidth;
      case ScreenType.tablet:
        return 720;
      case ScreenType.desktop:
        return 1024;
      case ScreenType.tv:
        return 1400;
    }
  }

  // Get the horizontal padding based on the current screen type. This is useful for setting consistent padding around content on different devices.
  double get horizontalPadding =>
      getValue<double>(mobile: 20, tablet: 32, desktop: 48, tv: 64);

}

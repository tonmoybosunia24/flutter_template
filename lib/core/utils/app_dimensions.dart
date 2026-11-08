/// This class defines centralized design tokens for application dimensions, including padding, border radii, font sizes, icon sizes, and spacing. It stores raw `double` values that can be scaled in the UI using responsive helpers (`getWidth`, `getHeight`, `getSp`, `getRadius`) or `ScreenUtil` extensions (`.w`, `.h`, `.sp`, `.r`).
class AppDimensions {
  // Private constructor to prevent instantiation
  AppDimensions._();

  // Standard padding and margin values used across the UI.
  static const double padding4 = 4.0;
  static const double padding8 = 8.0;
  static const double padding10 = 10.0;
  static const double padding12 = 12.0;
  static const double padding14 = 14.0;
  static const double padding16 = 16.0;
  static const double padding18 = 18.0;
  static const double padding20 = 20.0;
  static const double padding24 = 24.0;
  static const double padding32 = 32.0;
  static const double padding40 = 40.0;
  static const double padding48 = 48.0;

  // Standard border radius values for cards, buttons, inputs, and dialogs.
  static const double radius4 = 4.0;
  static const double radius8 = 8.0;
  static const double radius10 = 10.0;
  static const double radius12 = 12.0;
  static const double radius14 = 14.0;
  static const double radius16 = 16.0;
  static const double radius20 = 20.0;
  static const double radius30 = 30.0;
  static const double radius40 = 40.0;
  static const double radius100 = 100.0;

  // Standard typography font sizes used across text styles.
  static const double font11 = 11.0;
  static const double font12 = 12.0;
  static const double font13 = 13.0;
  static const double font14 = 14.0;
  static const double font15 = 15.0;
  static const double font16 = 16.0;
  static const double font17 = 17.0;
  static const double font18 = 18.0;
  static const double font20 = 20.0;
  static const double font24 = 24.0;
  static const double font28 = 28.0;
  static const double font30 = 30.0;
  static const double font33 = 33.0;
  static const double font40 = 40.0;

  // Standard icon sizes for buttons, inputs, and navigation items.
  static const double icon14 = 14.0;
  static const double icon16 = 16.0;
  static const double icon18 = 18.0;
  static const double icon20 = 20.0;
  static const double icon22 = 22.0;
  static const double icon24 = 24.0;
  static const double icon30 = 30.0;
  static const double icon40 = 40.0;

  // Fixed dimensions for common UI components (buttons, inputs, avatars, nav bar).
  static const double buttonHeight = 50.0;
  static const double inputHeight = 52.0;
  static const double iconButtonSize = 50.0;
  static const double iconContainerSize = 40.0;
  static const double avatarSize = 70.0;
  static const double vehicleThumbWidth = 96.0;
  static const double vehicleThumbHeight = 92.0;
  static const double logoSizeLarge = 200.0;
  static const double logoSizeMedium = 120.0;
  static const double bottomNavBarHeight = 81.0;
  static const double onboardingIllustrationSize = 200.0;
  static const double onboardingIconSize = 64.0;

  // Standard border stroke widths for outlines, dividers, and focused inputs.
  static const double borderWidth05 = 0.5;
  static const double borderWidth1 = 1.0;
  static const double borderWidth15 = 1.5;
  static const double borderWidth2 = 2.0;
  static const double borderWidth3 = 3.0;

  // Predefined widths for skeleton shimmer loading placeholders.
  static const double skeletonWidthLarge = 200.0;
  static const double skeletonWidthMedium = 150.0;
  static const double skeletonWidthSmall = 100.0;

  // Standard spacing values for gaps between widgets.
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space10 = 10.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;
}

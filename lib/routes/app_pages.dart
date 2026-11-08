import 'package:get/route_manager.dart';
import 'package:template/features/auth/binding/login_binding.dart';
import 'package:template/features/auth/view/login_screen.dart';
import 'package:template/features/main/binding/main_binding.dart';
import 'package:template/features/main/view/main_screen.dart';
import 'package:template/features/onboarding/binding/onboarding_binding.dart';
import 'package:template/features/onboarding/view/onboarding_screen.dart';
import 'package:template/features/profile/binding/language_binding.dart';
import 'package:template/features/profile/view/language_screen.dart';
import 'package:template/features/splash/binding/splash_binding.dart';
import 'package:template/features/splash/view/splash_screen.dart';
import 'package:template/routes/app_routes.dart';

export 'package:template/routes/app_routes.dart';

/// The app's pages, each linked to its route and binding.
class AppPages {
  static final routes = [
    // Define the route for the splash screen
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),

    // Define the route for the onboarding screen
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),

    // Auth flow: login
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),

    // Define the route for the main screen
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      binding: MainBinding(),
    ),

    // Define the route for the language screen
    GetPage(
      name: AppRoutes.language,
      page: () => const LanguageScreen(),
      binding: LanguageBinding(),
    ),
  ];
}

import 'package:get/get.dart';
import 'package:template/core/core.dart';
import 'package:template/routes/app_routes.dart';

/// A controller for the splash screen that handles the app's initialization logic and determines the next route to navigate to after the splash screen.
class SplashController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  // Shortest time the splash stays visible, so it doesn't just flash when loading is instant.
  static const Duration _minSplashDuration = Duration(milliseconds: 1500);

  @override
  void onReady() {
    super.onReady();
    _start();
  }

  // Runs the startup work and the minimum display time in parallel, then navigates once both are done.
  Future<void> _start() async {
    final (nextRoute, _) = await (
      _resolveNextRoute(),
      Future<void>.delayed(_minSplashDuration),
    ).wait;

    // The splash may have been closed while we were waiting.
    if (isClosed) return;

    // offNamed removes splash from the stack so the user can't navigate back to it.
    Get.offNamed(nextRoute);
  }

  // Startup work goes here (e.g. remote config, user profile). Returns the route to open next.
  Future<String> _resolveNextRoute() async {
    try {
      if (!_storage.hasOnboarded()) return AppRoutes.onboarding;

      return await _isLoggedIn() ? AppRoutes.main : AppRoutes.login;
    } catch (e, stackTrace) {
      AppLogger.logError('Splash startup failed', e, stackTrace);
      return AppRoutes.login;
    }
  }

  // A session counts as logged in if the access token is still valid, or if a refresh token exists (NetworkCaller refreshes an expired access token on the next request).
  Future<bool> _isLoggedIn() async {
    final accessToken = await _storage.getAccessToken();
    if (accessToken != null && !_storage.isAccessTokenExpired()) return true;

    final refreshToken = await _storage.getRefreshToken();
    return refreshToken != null;
  }
}

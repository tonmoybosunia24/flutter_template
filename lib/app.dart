import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/bindings/app_binding.dart';
import 'package:template/core/core.dart';
import 'package:template/routes/app_pages.dart';

/// The main entry point of the application. It initializes the app and sets up the necessary configurations. The [MyApp] class is the root widget of the application. It sets up the theme, localization, and routing for the app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    // Get the StorageService instance
    final storage = Get.find<StorageService>();
    final themePreference = storage.getTheme() ?? 'system';
    final langPreference = storage.getLanguage() ?? 'en';

    // Determine the initial theme mode based on the stored preference
    final initialTheme = switch (themePreference) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    // Determine the initial locale based on the stored language preference
    final initialLocale = switch (langPreference) {
      StorageKeys.langCodeAr => const Locale('ar', 'SA'),
      StorageKeys.langCodeBn => const Locale('bn', 'BD'),
      _ => const Locale('en', 'US'),
    };

    // Initialize ScreenUtil for responsive design
    return ScreenUtilInit(
      designSize: const Size(412, 917), // Base design size for scaling
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName.tr, // Application title.Change this to your app's name.
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: initialTheme,
          translations: AppTranslations(),
          locale: initialLocale,
          fallbackLocale: const Locale('en', 'US'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ], // Delegates for localization support
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ar', 'SA'),
            Locale('bn', 'BD'),
          ],
          builder: (context, child) {
            AppSizeClass.init(context); // Initialize AppSizeClass for responsive sizing
            return child!;
          },
          initialBinding: AppBinding(), // Initial binding to set up dependencies
          initialRoute: AppRoutes.splash, // Set the initial route to the splash screen
          getPages: AppPages.routes, // Define the application's routes
        );
      },
    );
  }
}

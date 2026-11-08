import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/splash/controller/splash_controller.dart';

/// A splash screen that displays the app's title and a loading indicator while the app initializes. It uses [SplashController] to manage the initialization logic.
class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: AppStrings.splashTitle.tr,
              style: context.textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getHeight(AppDimensions.space24)),
            const CustomLoader(),
          ],
        ),
      ),
    );
  }
}

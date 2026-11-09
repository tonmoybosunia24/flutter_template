import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';

/// Shown in place of the home feed when it fails to load. Params: [message]: the already translated error text. [onRetry]: called when the retry button is tapped.
class HomeErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const HomeErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: message,
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getHeight(AppDimensions.space16)),
            CustomPillButton(
              icon: IconPath.refresh,
              text: AppStrings.errorRetry.tr,
              onTap: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

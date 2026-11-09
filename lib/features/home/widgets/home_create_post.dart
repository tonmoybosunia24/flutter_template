import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';

/// A flat box at the top of the feed for writing a new post's title. Params: [controller]: holds the entered title. [canSubmit]: whether there is a title to send. [isSubmitting]: shows a spinner on the post button. [errorText]: the already translated reason the last attempt failed. [onSubmit]: called when the post button is tapped.
class HomeCreatePost extends StatelessWidget {
  final TextEditingController controller;
  final bool canSubmit;
  final bool isSubmitting;
  final String? errorText;
  final VoidCallback onSubmit;

  const HomeCreatePost({
    super.key,
    required this.controller,
    required this.canSubmit,
    required this.isSubmitting,
    required this.errorText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;
    final isActive = canSubmit || isSubmitting;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getWidth(AppDimensions.padding12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title and post button
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: controller,
                      hintText: AppStrings.homeCreatePostHint.tr,
                      isBorderless: true,
                    ),
                  ),
                  SizedBox(width: getWidth(AppDimensions.space8)),
                  GestureDetector(
                    onTap: onSubmit,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: getRadius(AppDimensions.iconContainerSize),
                      padding: EdgeInsets.symmetric(
                        horizontal: getWidth(AppDimensions.padding24),
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isActive ? null : colors.outline,
                        gradient: isActive ? colors.primaryGradient : null,
                        borderRadius: BorderRadius.circular(
                          getRadius(AppDimensions.radius100),
                        ),
                      ),
                      // The hidden label keeps the button's width while the spinner shows.
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: isSubmitting ? 0 : 1,
                            child: CustomText(
                              text: AppStrings.homeCreatePostSubmit.tr,
                              style: textTheme.labelMedium,
                              color: isActive
                                  ? colors.onPrimary
                                  : colors.textMuted,
                            ),
                          ),
                          if (isSubmitting)
                            CustomLoader(
                              size: AppDimensions.icon20,
                              color: colors.onPrimary,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (errorText != null) ...[
                SizedBox(height: getHeight(AppDimensions.space8)),
                CustomText(
                  text: errorText!,
                  style: textTheme.bodySmall,
                  color: colors.error,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: getHeight(AppDimensions.space8)),
        Divider(height: AppDimensions.borderWidth1, color: colors.outline),
      ],
    );
  }
}

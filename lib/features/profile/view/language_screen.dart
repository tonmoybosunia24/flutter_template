import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/profile/controller/language_controller.dart';
import 'package:template/features/profile/widgets/profile_language_section.dart';

/// The screen for picking the app language. The choice is only applied when Save is tapped.
class LanguageScreen extends GetView<LanguageController> {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: getHeight(AppDimensions.space20)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getWidth(AppDimensions.space4),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back<void>(),
                          child: Transform.flip(
                            flipX:
                                Directionality.of(context) == TextDirection.rtl,
                            child: CustomSvgIcon(
                              assetName: IconPath.backArrow,
                              width: getRadius(AppDimensions.icon32),
                              height: getRadius(AppDimensions.icon32),
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            text: AppStrings.profileLanguage.tr,
                            style: context.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: getRadius(AppDimensions.icon32)),
                      ],
                    ),
                  ),
                  SizedBox(height: getHeight(AppDimensions.space30)),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ProfileLanguageSection(
                            title: AppStrings.languageSuggested.tr,
                            languages: controller.suggestedLanguages,
                          ),
                          SizedBox(height: getHeight(AppDimensions.space20)),
                          ProfileLanguageSection(
                            title: AppStrings.languageOthers.tr,
                            languages: controller.otherLanguages,
                          ),
                          SizedBox(height: getHeight(AppDimensions.space20)),
                        ],
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        getRadius(AppDimensions.radius100),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.primaryShadow,
                          offset: Offset(0, 4),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: CustomButton(
                      text: AppStrings.languageSave.tr,
                      onPressed: controller.save,
                    ),
                  ),
                  SizedBox(height: getHeight(AppDimensions.space30)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

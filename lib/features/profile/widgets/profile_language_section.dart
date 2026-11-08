import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/profile/controller/language_controller.dart';
import 'package:template/features/profile/widgets/profile_language_tile.dart';

/// A titled card of selectable languages on the language screen. Params: [title]: the already translated heading above the card. [languages]: the rows, as records of (language code, name in its own language, translation key of its translated name).
class ProfileLanguageSection extends GetView<LanguageController> {
  final String title;
  final List<(String, String, String)> languages;

  const ProfileLanguageSection({
    super.key,
    required this.title,
    required this.languages,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final lineColor = colors.border.withValues(alpha: 0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomText(text: title, style: context.textTheme.titleLarge),
        SizedBox(height: getHeight(AppDimensions.space16)),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(
              getRadius(AppDimensions.radius20),
            ),
            border: Border.all(
              color: lineColor,
              width: AppDimensions.borderWidth1,
            ),
          ),
          child: Obx(
            () => Column(
              children: [
                for (final (index, (code, name, subtitleKey))
                    in languages.indexed) ...[
                  if (index > 0)
                    Divider(
                      height: AppDimensions.borderWidth1,
                      color: lineColor,
                    ),
                  ProfileLanguageTile(
                    name: name,
                    subtitle: subtitleKey.tr,
                    isSelected: controller.selectedCode.value == code,
                    onTap: () => controller.select(code),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

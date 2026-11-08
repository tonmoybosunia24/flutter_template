import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// A titled card on the profile screen. Params: [title]: the already translated heading above the card. [children]: the rows of the card, separated by thin lines.
class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomText(text: title, style: context.textTheme.titleLarge),
        SizedBox(height: getHeight(AppDimensions.space16)),
        Container(
          padding: EdgeInsets.all(getRadius(AppDimensions.padding20)),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(
              getRadius(AppDimensions.radius20),
            ),
            border: Border.all(
              color: colors.elevatedSurface,
              width: AppDimensions.borderWidth1,
            ),
            boxShadow: const [
              BoxShadow(color: AppColors.cardShadow, blurRadius: 2.15),
            ],
          ),
          child: Column(
            children: [
              for (final (index, child) in children.indexed) ...[
                if (index > 0) ...[
                  SizedBox(height: getHeight(AppDimensions.space16)),
                  Divider(
                    height: AppDimensions.borderWidth1,
                    color: colors.outline,
                  ),
                  SizedBox(height: getHeight(AppDimensions.space16)),
                ],
                child,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

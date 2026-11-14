import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// Fills a screen that has nothing else to show (empty, error, offline or coming soon) with a centered icon, title, message and an optional pill button. Scrolls when it doesn't fit and supports pull-to-refresh. Params: [icon]: SVG path from [IconPath]. [title]: the already translated heading. [message]: the already translated text under the title. [actionText]: the already translated button label. No button is shown without it. [actionIcon]: SVG path of the button icon. Defaults to [IconPath.refresh]. [onAction]: called when the button is tapped. [isActionLoading]: shows a spinner on the button while the action runs. [onRefresh]: called on pull-to-refresh. Pulling is off when null.
class CustomScreenState extends StatelessWidget {
  final String icon;
  final String title;
  final String message;
  final String? actionText;
  final String actionIcon;
  final VoidCallback? onAction;
  final bool isActionLoading;
  final RefreshCallback? onRefresh;

  const CustomScreenState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.actionIcon = IconPath.refresh,
    this.onAction,
    this.isActionLoading = false,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    final body = CustomScrollView(
      // Always scrollable, so pull-to-refresh works even when everything fits.
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomSvgIcon(
                    assetName: icon,
                    width: getRadius(AppDimensions.avatarSize),
                    height: getRadius(AppDimensions.avatarSize),
                    color: context.appColors.primary,
                  ),
                  SizedBox(height: getHeight(AppDimensions.space12)),
                  CustomText(
                    text: title,
                    style: textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: getHeight(AppDimensions.space4)),
                  CustomText(
                    text: message,
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (actionText != null && onAction != null) ...[
                    SizedBox(height: getHeight(AppDimensions.space16)),
                    CustomPillButton(
                      icon: actionIcon,
                      text: actionText!,
                      onTap: onAction!,
                      isLoading: isActionLoading,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );

    if (onRefresh == null) return body;
    return RefreshIndicator(onRefresh: onRefresh!, child: body);
  }
}

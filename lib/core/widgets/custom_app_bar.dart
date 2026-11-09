import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';

/// A reusable app bar with a start-aligned title, a soft bottom line and round action buttons. The back arrow only appears when there is a route to go back to, so root screens and main tabs don't show it. Params: [title]: the already translated title. [avatar]: photo shown in a gradient ring before the title, for a profile-style bar. [subtitle]: the already translated small text under the title, shown only with [avatar]. [actions]: widgets on the end side, usually [CustomAppBarAction]. [onBack]: replaces the default back behavior. [showBackButton]: set to false to hide the back arrow. Defaults to true.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? avatar;
  final String? subtitle;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    this.title,
    this.avatar,
    this.subtitle,
    this.actions,
    this.onBack,
    this.showBackButton = true,
  });

  // Size of the avatar and the round buttons. Capped because the bar's height doesn't scale with the screen.
  static double get itemSize => math.min(
    getRadius(AppDimensions.appBarActionSize),
    AppDimensions.appBarHeight - AppDimensions.space8,
  );

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final canGoBack = showBackButton && Navigator.canPop(context);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: colors.background,
      toolbarHeight: AppDimensions.appBarHeight,
      centerTitle: false,
      shape: Border(
        bottom: BorderSide(
          color: colors.border.withValues(alpha: 0.5),
          width: AppDimensions.borderWidth1,
        ),
      ),
      leadingWidth: canGoBack
          ? getWidth(AppDimensions.padding20) +
              getRadius(AppDimensions.appBarActionSize)
          : null,
      leading: canGoBack
          ? Padding(
              padding: EdgeInsetsDirectional.only(
                start: getWidth(AppDimensions.padding20),
              ),
              child: Center(
                child: CustomAppBarAction(
                  icon: IconPath.backArrow,
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  flipInRtl: true,
                  onTap: onBack ?? () => Get.back<void>(),
                ),
              ),
            )
          : null,
      titleSpacing: getWidth(
        canGoBack || avatar != null
            ? AppDimensions.padding12
            : AppDimensions.padding20,
      ),
      title: avatar != null
          ? Row(
              children: [
                SizedBox.square(
                  dimension: itemSize,
                  child: CustomRingAvatar(child: avatar!),
                ),
                SizedBox(width: getWidth(AppDimensions.space10)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        CustomText(
                          text: title!,
                          style: context.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (subtitle != null)
                        CustomText(
                          text: subtitle!,
                          style: context.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            )
          : title == null
          ? null
          : CustomText(
              text: title!,
              style: context.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      actionsPadding: EdgeInsetsDirectional.only(
        end: getWidth(AppDimensions.padding20),
      ),
      actions: [
        for (final action in actions ?? const <Widget>[])
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: getWidth(AppDimensions.space8),
            ),
            child: action,
          ),
      ],
    );
  }
}

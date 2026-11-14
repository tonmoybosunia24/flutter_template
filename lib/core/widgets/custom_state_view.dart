import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';

/// Shows a data screen in its current [ViewState]: a skeleton, an empty, error or offline message, or the content, with the dev scenario switcher floating above it in debug builds. Params: [state]: the state to show. [child]: the content. [onRetry]: reloads the data, from the retry button or pull-to-refresh. [isRetrying]: shows a spinner on the retry button. [loadingChild]: a skeleton shaped like the content. Defaults to generic cards. [loadingLabel]: the already translated text screen readers hear while loading. [emptyTitle]: the already translated empty heading. [emptyMessage]: the already translated empty text. [errorMessage]: the already translated error text. Defaults to a generic message.
class CustomStateView extends StatelessWidget {
  final ViewState state;
  final Widget child;
  final RefreshCallback onRetry;
  final bool isRetrying;
  final Widget? loadingChild;
  final String? loadingLabel;
  final String? emptyTitle;
  final String? emptyMessage;
  final String? errorMessage;

  const CustomStateView({
    super.key,
    required this.state,
    required this.child,
    required this.onRetry,
    this.isRetrying = false,
    this.loadingChild,
    this.loadingLabel,
    this.emptyTitle,
    this.emptyMessage,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final body = switch (state) {
      ViewState.content => child,
      ViewState.loading => CustomSkeleton(
        label: loadingLabel ?? AppStrings.stateLoading.tr,
        child: loadingChild ?? const _DefaultSkeleton(),
      ),
      ViewState.empty => CustomScreenState(
        icon: IconPath.inbox,
        title: emptyTitle ?? AppStrings.stateEmptyTitle.tr,
        message: emptyMessage ?? AppStrings.stateEmptyMessage.tr,
        onRefresh: onRetry,
      ),
      ViewState.offline => CustomScreenState(
        icon: IconPath.hotspotOffline,
        title: AppStrings.stateOfflineTitle.tr,
        message: AppStrings.stateOfflineMessage.tr,
        actionText: AppStrings.errorRetry.tr,
        onAction: onRetry,
        isActionLoading: isRetrying,
        onRefresh: onRetry,
      ),
      ViewState.error => CustomScreenState(
        icon: IconPath.alertCircle,
        title: AppStrings.stateErrorTitle.tr,
        message: (errorMessage?.isNotEmpty ?? false)
            ? errorMessage!
            : AppStrings.errorUnknown.tr,
        actionText: AppStrings.errorRetry.tr,
        onAction: onRetry,
        isActionLoading: isRetrying,
        onRefresh: onRetry,
      ),
    };

    // Every data screen gets the dev scenario switcher, tabs and pushed pages alike. It draws nothing in release builds.
    return Stack(
      fit: StackFit.expand,
      children: [body, const CustomDevScenarioSwitcher()],
    );
  }
}

/// The skeleton shown when a screen gives no [CustomStateView.loadingChild]: a few generic cards with an avatar and text lines.
class _DefaultSkeleton extends StatelessWidget {
  const _DefaultSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: getHeight(AppDimensions.padding16),
      ),
      itemCount: 4,
      separatorBuilder: (_, _) =>
          SizedBox(height: getHeight(AppDimensions.space16)),
      itemBuilder: (_, _) => Container(
        padding: EdgeInsets.all(getRadius(AppDimensions.padding16)),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(
            getRadius(AppDimensions.radius16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CustomSkeletonBox(
                  width: AppDimensions.iconContainerSize,
                  isCircle: true,
                ),
                SizedBox(width: getWidth(AppDimensions.space12)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomSkeletonBox(
                      width: AppDimensions.skeletonWidthMedium,
                      height: AppDimensions.space12,
                    ),
                    SizedBox(height: getHeight(AppDimensions.space6)),
                    const CustomSkeletonBox(
                      width: AppDimensions.skeletonWidthSmall,
                      height: AppDimensions.space10,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: getHeight(AppDimensions.space16)),
            const CustomSkeletonBox(height: AppDimensions.space12),
            SizedBox(height: getHeight(AppDimensions.space8)),
            const CustomSkeletonBox(
              width: AppDimensions.skeletonWidthLarge,
              height: AppDimensions.space12,
            ),
          ],
        ),
      ),
    );
  }
}

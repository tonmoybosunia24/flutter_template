import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/home/controller/home_controller.dart';
import 'package:template/features/home/widgets/home_feed.dart';
import 'package:template/features/home/widgets/home_post_skeleton.dart';
import 'package:template/features/main/widgets/main_app_bar.dart';

/// The home tab of the main screen. Shows the post feed in one of five states (loading, empty, error, offline or content).
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppDimensions.feedMaxWidth),
          child: Obx(
            () => CustomStateView(
              state: controller.state.value,
              isRetrying: controller.isLoading.value,
              errorMessage: controller.errorMessage.value,
              onRetry: controller.fetchData,
              loadingLabel: AppStrings.homeLoading.tr,
              loadingChild: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  vertical: getHeight(AppDimensions.space8),
                ),
                itemCount: 3,
                separatorBuilder: (_, _) =>
                    SizedBox(height: getHeight(AppDimensions.space4)),
                itemBuilder: (_, _) => const HomePostSkeleton(),
              ),
              emptyTitle: AppStrings.homeEmptyTitle.tr,
              emptyMessage: AppStrings.homeEmptyMessage.tr,
              child: const HomeFeed(),
            ),
          ),
        ),
      ),
    );
  }
}

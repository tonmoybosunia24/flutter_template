import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/home/controller/home_controller.dart';
import 'package:template/features/home/widgets/home_error_state.dart';
import 'package:template/features/home/widgets/home_post_card.dart';

/// The home tab of the main screen. Shows a feed of mock posts with loading, error and pull-to-refresh states.
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.navHome.tr,
        actions: [
          CustomAppBarAction(
            icon: IconPath.notification,
            tooltip: AppStrings.navNotifications.tr,
            onTap: () {},
          ),
        ],
      ),
      body: Obx(() {
        final error = controller.errorMessage.value;
        if (error != null) {
          return HomeErrorState(
            message: error,
            onRetry: controller.fetchPosts,
          );
        }

        // Keep the list on screen during pull-to-refresh.
        if (controller.isLoading.value && controller.posts.isEmpty) {
          return const Center(child: CustomLoader());
        }

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppDimensions.feedMaxWidth),
            child: RefreshIndicator(
              onRefresh: controller.fetchPosts,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  vertical: getHeight(AppDimensions.space8),
                ),
                itemCount: controller.posts.length,
                separatorBuilder: (_, _) =>
                    SizedBox(height: getHeight(AppDimensions.space20)),
                itemBuilder: (_, index) {
                  final post = controller.posts[index];
                  return Obx(
                    () => HomePostCard(
                      post: post,
                      isLiked: controller.isLiked(post.id),
                      likeCount: controller.likeCount(post),
                      timeAgo: controller.timeAgo(post),
                      onToggleLike: () => controller.toggleLike(post.id),
                      onPhotoDoubleTap: () => controller.likePost(post.id),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}

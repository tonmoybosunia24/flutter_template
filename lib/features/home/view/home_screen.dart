import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/home/controller/home_controller.dart';
import 'package:template/features/home/widgets/home_create_post.dart';
import 'package:template/features/home/widgets/home_error_state.dart';
import 'package:template/features/home/widgets/home_post_card.dart';

/// The home tab of the main screen. Shows the create post box above a feed of posts with loading, error and pull-to-refresh states.
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
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Create post box
                  SliverPadding(
                    padding: EdgeInsets.only(
                      top: getHeight(AppDimensions.space8),
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Obx(
                        () => HomeCreatePost(
                          authorName: controller.authorName,
                          category: controller.postCategory,
                          controller: controller.titleController,
                          canSubmit: controller.canCreatePost.value,
                          isSubmitting: controller.isCreatingPost.value,
                          errorText: controller.createPostError.value,
                          onSubmit: controller.createPost,
                        ),
                      ),
                    ),
                  ),

                  // Posts
                  SliverPadding(
                    padding: EdgeInsets.only(
                      top: getHeight(AppDimensions.space4),
                      bottom: getHeight(AppDimensions.space8),
                    ),
                    sliver: SliverList.separated(
                      itemCount: controller.posts.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: getHeight(AppDimensions.space4)),
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
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
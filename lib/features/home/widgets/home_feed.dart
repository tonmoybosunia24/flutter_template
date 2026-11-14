import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/home/controller/home_controller.dart';
import 'package:template/features/home/widgets/home_post_card.dart';

/// The content state of the home tab: the list of posts with pull-to-refresh.
class HomeFeed extends GetView<HomeController> {
  const HomeFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.fetchData,
      child: Obx(
        () => ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            vertical: getHeight(AppDimensions.space8),
          ),
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
    );
  }
}

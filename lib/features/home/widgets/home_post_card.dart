import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/home/model/home_post.dart';
import 'package:template/features/home/widgets/home_post_action.dart';

/// A flat, photo-first feed post: author, square photo, icon actions, like count and caption. Params: [post]: the post to show. [isLiked]: whether the current user liked it. [likeCount]: number of likes to show. [timeAgo]: the already translated post age. [onToggleLike]: called when the heart is tapped. [onPhotoDoubleTap]: called when the photo is double-tapped.
class HomePostCard extends StatelessWidget {
  final HomePost post;
  final bool isLiked;
  final int likeCount;
  final String timeAgo;
  final VoidCallback onToggleLike;
  final VoidCallback onPhotoDoubleTap;

  const HomePostCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.likeCount,
    required this.timeAgo,
    required this.onToggleLike,
    required this.onPhotoDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Author
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            getWidth(AppDimensions.padding12),
            getHeight(AppDimensions.padding8),
            getWidth(AppDimensions.padding4),
            getHeight(AppDimensions.padding8),
          ),
          child: Row(
            children: [
              // Gradient ring around the avatar
              Container(
                padding: EdgeInsets.all(AppDimensions.borderWidth2),
                decoration: BoxDecoration(
                  gradient: colors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: EdgeInsets.all(AppDimensions.borderWidth2),
                  decoration: BoxDecoration(
                    color: colors.background,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: SizedBox(
                      width: getRadius(AppDimensions.icon32),
                      height: getRadius(AppDimensions.icon32),
                      child: CustomNetworkImage(url: post.avatarUrl),
                    ),
                  ),
                ),
              ),
              SizedBox(width: getWidth(AppDimensions.space10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: post.authorName,
                      style: textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    CustomText(
                      text: post.category,
                      style: textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(getRadius(AppDimensions.padding8)),
                  child: CustomSvgIcon(
                    assetName: IconPath.moreHorizontal,
                    width: getRadius(AppDimensions.icon20),
                    height: getRadius(AppDimensions.icon20),
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Photo
        GestureDetector(
          onDoubleTap: onPhotoDoubleTap,
          child: AspectRatio(
            aspectRatio: 1,
            child: CustomNetworkImage(url: post.imageUrl),
          ),
        ),

        // Actions
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getWidth(AppDimensions.padding4),
            vertical: getHeight(AppDimensions.padding4),
          ),
          child: Row(
            children: [
              HomePostAction(
                icon: isLiked ? IconPath.heartFilled : IconPath.heart,
                label: AppStrings.homeLike.tr,
                color: isLiked ? colors.error : colors.textPrimary,
                onTap: onToggleLike,
              ),
              HomePostAction(
                icon: IconPath.comment,
                label: AppStrings.homeComment.tr,
                color: colors.textPrimary,
                onTap: () {},
              ),
              HomePostAction(
                icon: IconPath.share,
                label: AppStrings.homeShare.tr,
                color: colors.textPrimary,
                onTap: () {},
              ),
              const Spacer(),
              HomePostAction(
                icon: IconPath.bookmark,
                label: AppStrings.homeSave.tr,
                color: colors.textPrimary,
                onTap: () {},
              ),
            ],
          ),
        ),

        // Likes and caption
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getWidth(AppDimensions.padding12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: AppStrings.homeLikeCount.trParams({
                  'count': '$likeCount',
                }),
                style: textTheme.titleSmall,
              ),
              SizedBox(height: getHeight(AppDimensions.space4)),
              CustomText(text: post.title, style: textTheme.titleSmall),
              CustomText(
                text: post.body,
                style: textTheme.bodyMedium,
                color: colors.textPrimary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: getHeight(AppDimensions.space4)),
              CustomText(
                text: AppStrings.homeViewComments.trParams({
                  'count': '${post.comments}',
                }),
                style: textTheme.bodyMedium,
                color: colors.textMuted,
              ),
              SizedBox(height: getHeight(AppDimensions.space4)),
              CustomText(text: timeAgo, style: textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

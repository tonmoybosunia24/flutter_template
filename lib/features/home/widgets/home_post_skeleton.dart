import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// The loading placeholder of one feed post. It copies the layout of HomePostCard (author row, square photo, action row, likes and caption), so the feed doesn't jump when the posts arrive.
class HomePostSkeleton extends StatelessWidget {
  const HomePostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Author, with the same paddings as HomePostAuthor
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            getWidth(AppDimensions.padding12),
            getHeight(AppDimensions.padding8),
            getWidth(AppDimensions.padding4),
            getHeight(AppDimensions.padding8),
          ),
          child: Row(
            children: [
              const CustomSkeletonBox(
                width: AppDimensions.iconContainerSize,
                isCircle: true,
              ),
              SizedBox(width: getWidth(AppDimensions.space10)),
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
        ),

        // Photo
        const AspectRatio(aspectRatio: 1, child: CustomSkeletonBox(radius: 0)),

        // Actions: three on the start side, one on the end side, each the size of HomePostAction
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getWidth(AppDimensions.padding4),
            vertical: getHeight(AppDimensions.padding4),
          ),
          child: Row(
            children: [
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: EdgeInsets.all(getRadius(AppDimensions.padding8)),
                  child: const CustomSkeletonBox(
                    width: AppDimensions.icon24,
                    isCircle: true,
                  ),
                ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.all(getRadius(AppDimensions.padding8)),
                child: const CustomSkeletonBox(
                  width: AppDimensions.icon24,
                  isCircle: true,
                ),
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
              const CustomSkeletonBox(
                width: AppDimensions.skeletonWidthSmall,
                height: AppDimensions.space12,
              ),
              SizedBox(height: getHeight(AppDimensions.space10)),
              const CustomSkeletonBox(height: AppDimensions.space12),
              SizedBox(height: getHeight(AppDimensions.space8)),
              const CustomSkeletonBox(
                width: AppDimensions.skeletonWidthLarge,
                height: AppDimensions.space12,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

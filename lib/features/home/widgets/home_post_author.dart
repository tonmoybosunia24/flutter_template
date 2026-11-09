import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// The author row at the top of a post or the create post box: ringed avatar, name and a small label. Params: [avatar]: the author's photo, which fills the ring. [name]: the author's full name. [subtitle]: small text under the name. [trailing]: optional widget on the end side.
class HomePostAuthor extends StatelessWidget {
  final Widget avatar;
  final String name;
  final String subtitle;
  final Widget? trailing;

  const HomePostAuthor({
    super.key,
    required this.avatar,
    required this.name,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        getWidth(AppDimensions.padding12),
        getHeight(AppDimensions.padding8),
        getWidth(AppDimensions.padding4),
        getHeight(AppDimensions.padding8),
      ),
      child: Row(
        children: [
          CustomRingAvatar(child: avatar),
          SizedBox(width: getWidth(AppDimensions.space10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name,
                  style: textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                CustomText(
                  text: subtitle,
                  style: textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

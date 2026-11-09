import 'package:flutter/material.dart';
import 'package:template/core/core.dart';

/// Displays a photo from the network, with a plain placeholder while it loads or if it fails. Fills its parent when no size is given. Params: [url]: address of the photo. [width]: image width. [height]: image height. [fit]: how the photo fills its space. Defaults to [BoxFit.cover].
class CustomNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CustomNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = SizedBox(
      width: width,
      height: height,
      child: ColoredBox(color: context.appColors.outline),
    );

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (_, child, frame, wasSynchronouslyLoaded) =>
          wasSynchronouslyLoaded || frame != null ? child : placeholder,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}

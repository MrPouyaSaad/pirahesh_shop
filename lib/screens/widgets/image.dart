import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class ImageLoadingService extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final BorderRadius? borderRadius;
  const ImageLoadingService(
      {super.key, required this.imageUrl, this.borderRadius, this.width});

  @override
  Widget build(BuildContext context) {
    final Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      fit: BoxFit.cover,
    );
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    } else {
      return image;
    }
  }
}

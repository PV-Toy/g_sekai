import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum MediaType {
  jpeg,
  png,
  gif,
  animatedGif,
  webp,
  animatedWebp,
  bmp,
  wbmp;
}

class MediaWidget extends StatelessWidget {
  final String? imageUrl;
  const MediaWidget({super.key, this.imageUrl});

  Widget? MediaView() {}

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(imageUrl: imageUrl!);
  }
}

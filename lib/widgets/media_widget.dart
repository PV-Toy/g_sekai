import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum ImageType {
  jpeg,
  png,
  gif,
  animatedGif,
  webp,
  animatedWebp,
  bmp,
  wbmp;
}

enum VideoType {
  mp4,
}

enum MediaType {
  iamge,
  video,
}

class MediaWidget extends StatefulWidget {
  const MediaWidget({super.key, this.imageUrl});
  final String? imageUrl;

  @override
  State<MediaWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  @override
  Widget build(BuildContext context) {
    return _imageWidget(widget.imageUrl!);
  }

  Widget _imageWidget(String url) {
    return !url.startsWith("http")
        ? Image.asset(url)
        : CachedNetworkImage(imageUrl: widget.imageUrl!, fit: BoxFit.cover);
  }
}

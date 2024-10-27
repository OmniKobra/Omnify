import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  final String url;
  final BoxFit? fit;
  const MyImage({super.key, required this.url, required this.fit});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(url,
        fit: fit, cache: true, enableLoadState: false);
  }
}

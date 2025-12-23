import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'MyCustomCacheManager.dart';

class CachedProxiedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String proxyUrl;

  const CachedProxiedImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.proxyUrl = 'https://thingproxy.freeboard.io/fetch/',
  }) : super(key: key);

  String getProxiedUrl(String imageUrl) {
    return '$proxyUrl$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(cacheManager:MyCustomCacheManager().manager,
      imageUrl: getProxiedUrl(imageUrl),
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
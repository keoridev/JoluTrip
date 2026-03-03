import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  final Map<String, ImageProvider<Object>> _imageCache = {};

  Future<void> precacheImage(String url, BuildContext context) async {
    if (!_imageCache.containsKey(url)) {
      try {
        final provider = CachedNetworkImageProvider(url);
        await precacheImage(provider as String, context);
        _imageCache[url] = provider;
      } catch (e) {
        debugPrint('Error precaching image: $e');
      }
    }
  }

  ImageProvider? getCachedImage(String url) {
    return _imageCache[url];
  }

  void clearCache() {
    _imageCache.clear();
  }
}

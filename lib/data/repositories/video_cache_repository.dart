import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoCacheRepository {
  static final _cacheManager = CacheManager(
    Config(
      'videoCache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
    ),
  );

  Future<File?> getCachedVideo(String url) async {
    final fileInfo = await _cacheManager.getFileFromCache(url);
    return fileInfo?.file;
  }

  void downloadVideo(String url) {
    _cacheManager.downloadFile(url);
  }

  void clearCache() {
    _cacheManager.emptyCache();
  }
}

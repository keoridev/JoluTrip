import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class VideoCacheRepository {
  static const int maxCacheSize = 500 * 1024 * 1024; // 500 MB
  static const int maxCacheAge = 7 * 24 * 60 * 60; // 7 дней

  Future<File?> getCachedVideo(String url) async {
    try {
      final cacheKey = _generateCacheKey(url);
      final cacheDir = await _getCacheDirectory();
      final cacheFile = File('${cacheDir.path}/$cacheKey.mp4');

      if (await cacheFile.exists()) {
        // Проверяем возраст файла
        final fileAge = DateTime.now().difference(await cacheFile.lastModified());
        if (fileAge.inSeconds < maxCacheAge) {
          return cacheFile;
        } else {
          // Файл устарел, удаляем
          await cacheFile.delete();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> downloadVideo(String url) async {
    try {
      // Не качаем Supabase URL
      if (url.contains('supabase.co')) {
        return;
      }

      final cacheKey = _generateCacheKey(url);
      final cacheDir = await _getCacheDirectory();
      final cacheFile = File('${cacheDir.path}/$cacheKey.mp4');

      if (await cacheFile.exists()) {
        return;
      }

      // Фоновая загрузка
      final client = HttpClient();
      try {
        final request = await client.getUrl(Uri.parse(url));
        final response = await request.close();
        
        if (response.statusCode == 200) {
          final sink = cacheFile.openWrite();
          await response.pipe(sink);
          await sink.close();
          await _cleanupCache();
        }
      } finally {
        client.close();
      }
    } catch (e) {
      // Игнорируем ошибки загрузки
    }
  }

  Future<Directory> _getCacheDirectory() async {
    final tempDir = await getTemporaryDirectory();
    final videoCacheDir = Directory('${tempDir.path}/video_cache');
    
    if (!await videoCacheDir.exists()) {
      await videoCacheDir.create(recursive: true);
    }
    return videoCacheDir;
  }

  String _generateCacheKey(String url) {
    // Генерируем ключ на основе URL без параметров для Supabase
    String cleanUrl = url;
    if (url.contains('supabase.co')) {
      try {
        final uri = Uri.parse(url);
        cleanUrl = '${uri.scheme}://${uri.host}${uri.path}';
      } catch (e) {}
    }
    return md5.convert(utf8.encode(cleanUrl)).toString();
  }

  Future<void> _cleanupCache() async {
    try {
      final cacheDir = await _getCacheDirectory();
      final files = await cacheDir.list().toList();
      
      // Сортируем по времени изменения
      files.sort((a, b) => 
        (a.statSync().modified).compareTo(b.statSync().modified)
      );

      int totalSize = 0;
      for (var file in files) {
        if (file is File) {
          totalSize += await file.length();
        }
      }

      // Удаляем старые файлы если превышен лимит
      if (totalSize > maxCacheSize) {
        for (var file in files) {
          if (file is File) {
            await file.delete();
            totalSize -= await file.length();
            if (totalSize <= maxCacheSize) break;
          }
        }
      }
    } catch (e) {}
  }

  Future<void> clearCache() async {
    try {
      final cacheDir = await _getCacheDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
    } catch (e) {}
  }
}
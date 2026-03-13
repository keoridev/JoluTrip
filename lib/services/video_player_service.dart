import 'package:video_player/video_player.dart';
import 'package:jolu_trip/data/repositories/video_cache_repository.dart';

class VideoPlayerService {
  final VideoCacheRepository _cacheRepo = VideoCacheRepository();

  Future<VideoPlayerController> createController(String url) async {
    try {
      final cachedFile = await _cacheRepo.getCachedVideo(url);

      if (cachedFile != null) {
        return VideoPlayerController.file(
          cachedFile,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      } else {
        _cacheRepo.downloadVideo(url);
        return VideoPlayerController.networkUrl(
          Uri.parse(url),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      }
    } catch (e) {
      return VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
    }
  }
}

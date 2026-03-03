import 'package:video_player/video_player.dart';

class VideoControllerService {
  static final VideoControllerService _instance =
      VideoControllerService._internal();

  factory VideoControllerService() => _instance;
  VideoControllerService._internal();

  VideoPlayerController? _currentController;

  VideoPlayerController? get currentController => _currentController;

  void setController(VideoPlayerController controller) {
    _currentController = controller;
  }

  void pauseCurrentVideo() {
    _currentController?.pause();
  }

  void playCurrentVideo() {
    _currentController?.play();
  }

  void clearController() {
    _currentController = null;
  }

  void disposeController() {
    _currentController?.dispose();
    _currentController = null;
  }
}

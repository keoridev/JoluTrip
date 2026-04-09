import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/services/video_controller_service.dart';
import 'package:jolu_trip/services/video_player_service.dart';
import 'package:jolu_trip/widgets/video/video_placeholder.dart';
import 'package:jolu_trip/widgets/video/video_overlay.dart';
import 'package:jolu_trip/widgets/video/video_indicators.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';

class VideoItem extends StatefulWidget {
  final String id;
  final String url;
  final String title;
  final String category;
  final int price;
  final int travelTime;
  final String carType;
  final String difficult;
  final String? thumbnailUrl;

  const VideoItem({
    super.key,
    required this.id,
    required this.url,
    required this.title,
    required this.category,
    required this.price,
    required this.travelTime,
    required this.carType,
    required this.difficult,
    this.thumbnailUrl,
  });

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  final _videoService = VideoPlayerService();
  final _videoController = VideoControllerService();

  bool _isInitialized = false;
  bool _hasError = false;
  bool _isPlaying = false;
  bool _showIcon = false;
  double _playbackSpeed = 1.0;
  bool _isSpeedIndicatorVisible = false;
  bool _isBuffering = false;
  Timer? _speedIndicatorTimer;
  Timer? _hideIconTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initializeVideo();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _controller?.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (_isPlaying) {
        _controller?.play();
      }
    }
    _checkVisibility();
  }

  void _checkVisibility() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final RenderObject? renderObject = context.findRenderObject();
      if (renderObject == null || !renderObject.attached) {
        _controller?.pause();
        if (mounted) setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void didUpdateWidget(VideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.url != widget.url) {
      _reloadVideo();
    }
  }

  Future<void> _reloadVideo() async {
    await _controller?.dispose();
    _controller = null;

    if (mounted) {
      setState(() {
        _isInitialized = false;
        _hasError = false;
        _isPlaying = true;
      });
    }

    await _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (widget.url.isEmpty) {
      if (mounted) setState(() => _hasError = true);
      return;
    }

    try {
      final controller = await _videoService.createController(widget.url);

      controller.addListener(() {
        if (mounted) {
          setState(() {
            _isBuffering = controller.value.isBuffering;
          });
        }
      });

      await controller.initialize();

      if (!mounted) {
        controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _isInitialized = true;
      });

      _controller!.setLooping(true);
      _controller!.setPlaybackSpeed(_playbackSpeed);
      _controller!.play();

      _videoController.setController(_controller!);
    } catch (e) {
      debugPrint('Ошибка загрузки видео: $e');
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
        _showIcon = true;
      } else {
        _controller!.play();
        _isPlaying = true;
        _showIcon = false;
      }
    });

    _hideIconTimer?.cancel();
    _hideIconTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) setState(() => _showIcon = false);
    });
  }

  void _onLongPressStart(LongPressStartDetails details) {
    if (_controller == null) return;
    setState(() {
      _playbackSpeed = 2.0;
      _controller!.setPlaybackSpeed(_playbackSpeed);
      _isSpeedIndicatorVisible = true;
    });
    _speedIndicatorTimer?.cancel();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (_controller == null) return;
    setState(() {
      _playbackSpeed = 1.0;
      _controller!.setPlaybackSpeed(_playbackSpeed);
    });
    _speedIndicatorTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isSpeedIndicatorVisible = false);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _speedIndicatorTimer?.cancel();
    _hideIconTimer?.cancel();

    if (_videoController.currentController == _controller) {
      _videoController.clearController();
    }

    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: AppColors.darkTheme.scaffoldBackgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: AppDimens.iconSizeL * 1.5,
              ),
              const SizedBox(height: AppDimens.spaceM),
              Text(
                '${AppLocalizations.of(context)!.failedToLoadVideo}\n${widget.title}',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return VisibilityDetector(
        key: Key('video_${widget.id}'),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction == 0 && mounted) {
            if (_controller != null && _controller!.value.isPlaying) {
              _controller!.pause();
              setState(() {
                _isPlaying = false;
                _showIcon = true;
              });
            }
          }
        },
        child: GestureDetector(
          onTap: _togglePlayPause,
          onLongPressStart: _onLongPressStart,
          onLongPressEnd: _onLongPressEnd,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (!_isInitialized)
                VideoPlaceholder(thumbnailUrl: widget.thumbnailUrl)
              else
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black87,
                        Colors.black54,
                        Colors.transparent
                      ],
                    ),
                  ),
                ),
              ),

              // Оверлей с информацией
              VideoOverlay(
                id: widget.id,
                title: widget.title,
                category: widget.category,
                price: widget.price,
                travelTime: widget.travelTime,
                carType: widget.carType,
                difficult: widget.difficult,
              ),

              // Индикаторы
              PlayPauseIcon(
                isVisible: _showIcon,
                isPlaying: _isPlaying,
              ),
              SpeedIndicator(
                speed: _playbackSpeed,
                isVisible: _isSpeedIndicatorVisible,
              ),
              BufferingIndicator(isVisible: _isBuffering),
            ],
          ),
        ));
  }
}

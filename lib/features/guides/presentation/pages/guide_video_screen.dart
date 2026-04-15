import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/data/models/guides_model.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';
import 'package:jolu_trip/screens/booking_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class GuideVideoScreen extends StatefulWidget {
  final GuidesModel guide;
  final LocationModel? location;

  const GuideVideoScreen({
    super.key,
    required this.guide,
    this.location,
  });

  @override
  State<GuideVideoScreen> createState() => _GuideVideoScreenState();
}

class _GuideVideoScreenState extends State<GuideVideoScreen> {
  late VideoPlayerController _controller;
  bool _showContactButton = false;
  bool _isInitialized = false;
  bool _isVideoPaused = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    if (widget.guide.helloVideo.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToLoadGuideVideo),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
      return;
    }

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.guide.helloVideo),
    )..initialize().then((_) {
        if (mounted) {
          setState(() => _isInitialized = true);
          _controller.play();
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) setState(() => _showContactButton = true);
          });
        }
      }).catchError((error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.failedToLoadGuideVideo),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        }
      });

    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openWhatsApp() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() => _isVideoPaused = true);
    }

    final String phoneNumber = widget.guide.whatsapp.toString();
    final String locationName = widget.location?.name ?? 'путешествие';
    final String message = Uri.encodeComponent(
      '${widget.guide.name}, привет! Видел твое видео в Jolu Trip, хочу с тобой в $locationName!',
    );
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber?text=$message');

    launchUrl(whatsappUri, mode: LaunchMode.externalApplication).catchError((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Не удалось открыть WhatsApp'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    });
  }

  void _bookNow() {
    final location = widget.location;
    if (location == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingScreen(
          guide: widget.guide,
          location: location,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Keep localization initialized for error snackbar strings.
    AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          if (_showContactButton)
            Positioned(
              bottom: AppDimens.spaceL,
              left: AppDimens.spaceL,
              right: AppDimens.spaceL,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _openWhatsApp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimens.radiusM),
                            ),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text('Связаться'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceM),
                  if (widget.location != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _bookNow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.radiusM),
                          ),
                        ),
                        child: Text(
                          'Забронировать',
                          style: AppTextStyles.buttonLarge,
                        ),
                      ),
                    ),
                  const SizedBox(height: AppDimens.spaceM),
                  TextButton(
                    onPressed: () {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                        setState(() => _isVideoPaused = true);
                      } else {
                        _controller.play();
                        setState(() => _isVideoPaused = false);
                      }
                    },
                    child: Text(
                      _isVideoPaused ? 'Продолжить видео' : 'Пауза',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


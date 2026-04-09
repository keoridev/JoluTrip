import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jolu_trip/screens/booking_screen.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/data/models/guides_model.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';

class GuideVideoScreen extends StatefulWidget {
  final GuidesModel guide;
  final LocationModel location;

  const GuideVideoScreen({
    super.key,
    required this.guide,
    required this.location,
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
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.guide.helloVideo),
    )..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.play();

          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _showContactButton = true;
              });
            }
          });
        }
      }).catchError((error) {
        debugPrint('Ошибка загрузки видео: $error');
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
    // Пауза видео при открытии WhatsApp
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() => _isVideoPaused = true);
    }

    final String phoneNumber = widget.guide.whatsapp.toString();
    final String message = Uri.encodeComponent(
        '${widget.guide.name}, привет! Видел твое видео в Jolu Trip, хочу с тобой в ${widget.location.name}!');
    final Uri whatsappUri =
        Uri.parse('https://wa.me/$phoneNumber?text=$message');

    launchUrl(whatsappUri, mode: LaunchMode.externalApplication)
        .catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Не удалось открыть WhatsApp'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    });
  }

  Future<void> _navigateToBooking() async {
    // Пауза видео при навигации
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() => _isVideoPaused = true);
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingScreen(
          guide: widget.guide,
          location: widget.location,
        ),
      ),
    );

    // Возобновляем видео только если вернулись с экрана бронирования
    // и видео было на паузе из-за навигации
    if (mounted && _isVideoPaused && _isInitialized) {
      _controller.play();
      setState(() => _isVideoPaused = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Видео на весь экран
          if (_isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          else
            Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Container(
                padding: EdgeInsets.all(AppDimens.spaceL),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    padding: EdgeInsets.all(AppDimens.spaceM),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(AppDimens.radiusL),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: Image.network(
                              widget.guide.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.person,
                                size: 48,
                                color: AppColors.textSecondaryDark,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppDimens.spaceM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.guide.name,
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                widget.guide.car,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    widget.guide.rating.toString(),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  SizedBox(width: AppDimens.spaceM),
                                  SizedBox(width: 2),
                                  Text(
                                    '${widget.guide.priceService} сом',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ])),
          ),

          // Градиентная затемненная область снизу для лучшей видимости кнопок
          if (_showContactButton)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),

          // Кнопка закрытия
          Positioned(
            top: padding.top + 8,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),

          // Информация о гиде (появляется через 3 секунды)
          if (_showContactButton)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(AppDimens.spaceL),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Карточка гида
                    SizedBox(height: AppDimens.spaceM),

                    // Кнопка бронирования
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _navigateToBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.radiusL),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today,
                                color: Colors.white, size: 20),
                            SizedBox(width: AppDimens.spaceS),
                            Text(
                              'Забронировать тур',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimens.spaceS),

                    // Кнопка WhatsApp
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _openWhatsApp,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFF25D366)),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.radiusL),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat,
                                color: Color(0xFF25D366), size: 20),
                            SizedBox(width: AppDimens.spaceS),
                            Text(
                              'Написать в WhatsApp',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

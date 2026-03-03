import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/data/models/guides_model.dart';
import 'package:jolu_trip/data/models/location_model.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.guide.helloVideo),
    )..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();

        // Показываем кнопку через 3 секунды
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showContactButton = true;
            });
          }
        });
      }).catchError((error) {
        debugPrint('Ошибка загрузки видео: $error');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Не удалось загрузить видео гида'),
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
    final String phoneNumber = widget.guide.whatsapp.toString();
    // Формируем сообщение: "Айбек, привет! Видел твое видео в Jolu Trip, хочу с тобой в Ала-Арчу!"
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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

          // Кнопка закрытия
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 24),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Кнопка WhatsApp (появляется через 3 секунды)
          if (_showContactButton)
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.radiusXL),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(AppDimens.spaceL),
                child: Column(
                  children: [
                    // Информация о гиде
                    Row(
                      children: [
                        ClipOval(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(
                              widget.guide.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/images/default-user.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppDimens.spaceS),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.guide.name,
                                style: AppTextStyles.headlineMedium.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                widget.guide.car,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimens.spaceXS,
                            vertical: AppDimens.spaceXXS,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius:
                                BorderRadius.circular(AppDimens.radiusS),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Text(
                                " ${widget.guide.rating}",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppDimens.spaceM),

                    // Кнопка WhatsApp
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _openWhatsApp,
                        icon: Icon(Icons.chat, color: Colors.white),
                        label: Text(
                          'Написать в WhatsApp',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF25D366), // WhatsApp green
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.radiusL),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: AppDimens.spaceS),

                    // Предпросмотр сообщения
                    Container(
                      padding: EdgeInsets.all(AppDimens.spaceS),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimens.radiusM),
                      ),
                      child: Text(
                        '«${widget.guide.name}, привет! Видел твое видео в Jolu Trip, хочу с тобой в ${widget.location.name}!»',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
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

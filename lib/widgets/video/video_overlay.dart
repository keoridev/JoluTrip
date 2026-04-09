import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';
import 'package:jolu_trip/screens/detail_screen.dart';
import 'package:jolu_trip/services/video_controller_service.dart';
import 'package:jolu_trip/services/favorites_service.dart';
import 'package:jolu_trip/widgets/auth/auth_popup.dart';

class VideoOverlay extends StatefulWidget {
  final String id;
  final String title;
  final String category;
  final int price;
  final int travelTime;
  final String carType;
  final String difficult;

  const VideoOverlay({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.travelTime,
    required this.carType,
    required this.difficult,
  });

  @override
  State<VideoOverlay> createState() => _VideoOverlayState();
}

class _VideoOverlayState extends State<VideoOverlay> {
  final FavoritesService _favoritesService = FavoritesService();
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    if (!mounted) return;
    final isFav = await _favoritesService.isFavorite(widget.id);
    if (mounted) setState(() => _isFavorite = isFav);
  }

  Future<void> _toggleFavorite() async {
    if (!_favoritesService.isUserLoggedIn) {
      _showAuthPopup();
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isFavorite) {
        await _favoritesService.removeFromFavorites(widget.id);
        _showSnackBar('Удалено из избранного');
      } else {
        await _favoritesService.addToFavorites(widget.id);
        _showSnackBar('Добавлено в избранное');
      }
      if (mounted) setState(() => _isFavorite = !_isFavorite);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAuthPopup() {
    AuthPopup.show(
      context: context,
      onLogin: () => Navigator.pushNamed(context, '/auth')
          .then((_) => _checkFavoriteStatus()),
      onRegister: () =>
          Navigator.pushNamed(context, '/auth', arguments: {'mode': 'register'})
              .then((_) => _checkFavoriteStatus()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Градиент снизу для читаемости текста
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.6, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          right: AppDimens.spaceM,
          bottom: 190,
          child: Column(
            children: [
              _buildSideAction(
                icon: _isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                label: AppLocalizations.of(context)!.like,
                color: _isFavorite ? Colors.redAccent : Colors.white,
                onTap: _toggleFavorite,
                isLoading: _isLoading,
              ),
              const SizedBox(height: AppDimens.spaceL),
              _buildSideAction(
                icon: Icons.share_rounded,
                label: AppLocalizations.of(context)!.share,
                onTap: () => _showSnackBar('Функция скоро появится'),
              ),
            ],
          ),
        ),

        // 3. Информационный блок снизу
        Positioned(
          left: AppDimens.spaceM,
          right: AppDimens.spaceM,
          bottom: AppDimens.spaceL + MediaQuery.of(context).padding.bottom,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Категория
              _buildCategoryBadge(),
              const SizedBox(height: AppDimens.spaceS),

              // Название
              Text(
                widget.title,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [const Shadow(blurRadius: 8, color: Colors.black54)],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppDimens.spaceM),

              // Чипсы с деталями (Время, Машина)
              Row(
                children: [
                  _buildDetailItem(Icons.access_time_filled_rounded,
                      '${widget.travelTime} м'),
                  const SizedBox(width: AppDimens.spaceS),
                  _buildDetailItem(
                      Icons.directions_car_filled_rounded, widget.carType),
                  const SizedBox(width: AppDimens.spaceS),
                  _buildDetailItem(Icons.speed_rounded, widget.difficult),
                ],
              ),

              const SizedBox(height: AppDimens.spaceL),

              // Главная кнопка перехода
              _buildMainButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
    bool isLoading = false,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.85),
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
      ),
      child: Text(
        widget.category.toUpperCase(),
        style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMainButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          VideoControllerService().pauseCurrentVideo();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsScreen(locationId: widget.id)),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusL)),
          elevation: 0,
        ),
        child: Text(l10n.learnMore,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

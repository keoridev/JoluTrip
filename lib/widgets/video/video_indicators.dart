import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';

class SpeedIndicator extends StatelessWidget {
  final double speed;
  final bool isVisible;

  const SpeedIndicator(
      {super.key, required this.speed, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Positioned(
      top: 100,
      right: AppDimens.spaceM,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spaceS,
          vertical: AppDimens.spaceXXS,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flash_on,
              color: AppColors.textPrimaryDark,
              size: AppDimens.iconSizeS,
            ),
            const SizedBox(width: AppDimens.spaceXXS),
            Text(
              '${speed}x',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayPauseIcon extends StatelessWidget {
  final bool isVisible;
  final bool isPlaying;

  const PlayPauseIcon({
    super.key,
    required this.isVisible,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Center(
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: AppColors.textPrimaryDark.withOpacity(0.9),
          size: AppDimens.iconSizeL,
        ),
      ),
    );
  }
}

// Дополнительный индикатор загрузки
class BufferingIndicator extends StatelessWidget {
  final bool isVisible;

  const BufferingIndicator({super.key, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }
}

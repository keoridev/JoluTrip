import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';

class VideoPlaceholder extends StatelessWidget {
  final String? thumbnailUrl;

  const VideoPlaceholder({super.key, this.thumbnailUrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkTheme.cardColor : Colors.grey[300]!;
    final iconColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
          Image.network(
            thumbnailUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                _buildDefaultPlaceholder(bgColor, iconColor),
          )
        else
          _buildDefaultPlaceholder(bgColor, iconColor),

        // Индикатор загрузки
        Center(
          child: Container(
            padding: EdgeInsets.all(AppDimens.spaceS),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultPlaceholder(Color bgColor, Color iconColor) {
    return Container(
      color: bgColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.landscape,
              color: iconColor,
              size: AppDimens.iconSizeL * 2.5,
            ),
            const SizedBox(height: AppDimens.spaceS),
            Text(
              'Изображение не загружено',
              style: AppTextStyles.bodyMedium.copyWith(
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

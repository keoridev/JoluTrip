import 'package:flutter/material.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';

class LocationCard extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onTap;

  const LocationCard({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
          color: isDark ? const Color(0xFF1E1E20) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.black).withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimens.radiusL),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Изображение с градиентом
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                      child: Image.network(
                        location.thumbnailUrl.isNotEmpty
                            ? location.thumbnailUrl
                            : 'https://via.placeholder.com/300',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: isDark ? Colors.grey[800] : Colors.grey[300],
                          child: Icon(
                            Icons.image_not_supported,
                            color: isDark ? Colors.grey[600] : Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    // Бейдж с ценой (улучшенный)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${location.price} сом',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Индикатор сложности
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(location.difficult),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getDifficultyLabel(location.difficult),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Информация (улучшенная)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spaceS),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Название и рейтинг
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            location.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Время и расстояние
                    Row(
                      children: [
                        _buildInfoChip(
                          icon: Icons.access_time,
                          label: '${location.travelTime} мин',
                          isDark: isDark,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),

                    const Spacer(),

                    // Категория (улучшенная)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        location.category,
                        style: TextStyle(
                          fontSize: 9,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 10,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficult) {
    switch (difficult.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'нормально':
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getDifficultyLabel(String difficult) {
    switch (difficult.toLowerCase()) {
      case 'easy':
        return 'Легко';
      case 'нормально':
        return 'Норм';
      case 'medium':
        return 'Средне';
      case 'hard':
        return 'Сложно';
      default:
        return difficult;
    }
  }
}

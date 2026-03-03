import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/widgets/video/video_item.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';

class FeedScreen extends StatelessWidget {
  final VoidCallback? onThemeToggle;
  const FeedScreen({super.key, this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = isDark ? AppColors.darkTheme : AppColors.lightTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (onThemeToggle != null)
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: isDark ? Colors.white : Colors.black,
              ),
              onPressed: onThemeToggle,
              tooltip: 'Переключить тему',
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('locations').snapshots(),
        builder: (context, snapshot) {
          // Обработка ошибок с красивым UI
          if (snapshot.hasError) {
            final e = snapshot.error;
            final msg = e.toString().contains('PERMISSION_DENIED')
                ? 'Нет доступа к Firestore. Проверьте правила доступа.'
                : 'Ошибка загрузки: ${e.toString()}';

            return Center(
              child: Padding(
                padding: AppDimens.screenPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: AppDimens.iconSizeL * 2,
                    ),
                    const SizedBox(height: AppDimens.spaceM),
                    Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                backgroundColor: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.1),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_library_outlined,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    size: AppDimens.iconSizeL * 2,
                  ),
                  const SizedBox(height: AppDimens.spaceM),
                  Text(
                    'Нет доступных видео',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();
              if (data == null) return const SizedBox.shrink();

              final location = LocationModel.fromFirestore(
                doc.id,
                Map<String, dynamic>.from(data as Map),
              );
              return VideoItem(
                id: doc.id,
                url: location.videoUrl,
                title: location.name,
                category: location.category,
                price: location.price,
                carType: location.carType,
                travelTime: location.travelTime,
                difficult: location.difficult,
                thumbnailUrl: location.thumbnailUrl,
              );
            },
          );
        },
      ),
    );
  }
}

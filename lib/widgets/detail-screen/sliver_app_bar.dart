import 'package:flutter/material.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/widgets/ui/glass_button.dart';
import 'package:jolu_trip/widgets/ui/category_badge.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailsSliverAppBar extends StatelessWidget {
  final LocationModel location;
  final bool isDark;
  final Color cardColor;
  final Color textSecondary;
  final Color textPrimary;
  final double scrollOffset;
  final double collapseProgress;

  const DetailsSliverAppBar({
    super.key,
    required this.location,
    required this.isDark,
    required this.cardColor,
    required this.textSecondary,
    required this.textPrimary,
    required this.scrollOffset,
    required this.collapseProgress,
  });

  @override
  Widget build(BuildContext context) {
    final parallaxOffset = (scrollOffset * 0.45).clamp(0.0, 80.0);
    final gradientOpacity = (0.55 + collapseProgress * 0.35).clamp(0.0, 0.9);
    final headerOpacity = (1.0 - collapseProgress * 2.2).clamp(0.0, 1.0);
    final titleOpacity = ((collapseProgress - 0.65) / 0.2).clamp(0.0, 1.0);

    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      stretch: true,
      backgroundColor: isDark
          ? Color.lerp(Colors.transparent,
              AppColors.darkTheme.scaffoldBackgroundColor, collapseProgress)
          : Color.lerp(Colors.transparent,
              AppColors.lightTheme.scaffoldBackgroundColor, collapseProgress),
      elevation: collapseProgress > 0.95 ? 2 : 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GlassButton(
          icon: Icons.arrow_back_ios_new_rounded,
          opacity: (1.0 - collapseProgress * 1.5).clamp(0.0, 1.0),
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      title: Opacity(
        opacity: titleOpacity,
        child: Text(
          location.name,
          style: AppTextStyles.bodyLarge.copyWith(color: textPrimary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Кэшированное изображение
            Positioned.fill(
              top: -parallaxOffset,
              bottom: parallaxOffset,
              child: RepaintBoundary(
                child: CachedNetworkImage(
                  imageUrl: location.thumbnailUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 1080,
                  memCacheHeight: 720,
                  placeholder: (context, url) => Container(
                    color: cardColor,
                    child: const Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: cardColor,
                    child: Icon(Icons.image_not_supported,
                        color: textSecondary, size: AppDimens.iconSizeL),
                  ),
                ),
              ),
            ),

            // Градиент
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(gradientOpacity),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),

            // Заголовок
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Opacity(
                opacity: headerOpacity,
                child: Transform.translate(
                  offset: Offset(0, scrollOffset * 0.15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryBadge(label: location.category),
                      const SizedBox(height: 10),
                      Text(
                        location.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              blurRadius: 16,
                              color: Colors.black45,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

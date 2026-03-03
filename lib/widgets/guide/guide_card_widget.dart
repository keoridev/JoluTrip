import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/data/models/guides_model.dart';

class GuideCardWidget extends StatelessWidget {
  final GuidesModel guide;

  const GuideCardWidget({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 320, // Оставляем фиксированную ширину для горизонтального списка
      margin: EdgeInsets.only(
        right: AppDimens.spaceM,
        bottom: AppDimens.spaceXS,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        image: DecorationImage(
          image: NetworkImage(guide.carPhoto),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              isDark
                  ? Colors.black.withOpacity(0.9)
                  : Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        padding: EdgeInsets.all(AppDimens.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Аватар и имя гида
            Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: AppDimens.guideAvatarSize,
                    height: AppDimens.guideAvatarSize,
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: const AssetImage(
                        'assets/images/default-user.jpg',
                      ),
                      image: NetworkImage(guide.avatarUrl),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/default-user.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceXS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guide.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        guide.car,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondaryDark,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceS),

            // Рейтинг и цена
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceXS,
                    vertical: AppDimens.spaceXXS,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppDimens.radiusS),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: AppDimens.iconSizeS,
                      ),
                      Text(
                        " ${guide.rating}",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${guide.priceService} c",
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/screens/detail_screen.dart';
import 'package:jolu_trip/services/video_controller_service.dart';
import 'package:jolu_trip/widgets/chips/feature_chip.dart';
import 'package:jolu_trip/utils/video_helpers.dart';

class VideoOverlay extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Positioned(
      bottom:
          AppDimens.spaceXL + AppDimens.spaceM, // Учитываем нижнюю навигацию
      left: AppDimens.spaceM,
      right: AppDimens.spaceM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Категория
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.spaceS,
              vertical: AppDimens.spaceXXS,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.9),
              borderRadius: BorderRadius.circular(AppDimens.radiusS),
            ),
            child: Text(
              category,
              style: AppTextStyles.featureLabel.copyWith(
                color: AppColors.textPrimaryDark,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: AppDimens.spaceXS),

          // Название
          Text(
            title,
            style: AppTextStyles.locationTitle.copyWith(
              fontSize: 32,
              color: AppColors.textPrimaryDark,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: AppDimens.spaceS),

          Wrap(
            runSpacing: AppDimens.spaceS,
            spacing: AppDimens.spaceS,
            children: [
              FeatureChip(
                icon: Icons.access_time,
                label: '$travelTime мин',
              ),
              FeatureChip(
                icon: Icons.directions_car,
                label: carType,
              ),
              FeatureChip(
                icon: Icons.terrain,
                label: VideoHelpers.getDifficultyLabel(difficult),
              ),
            ],
          ),

          const SizedBox(height: AppDimens.spaceM),

          // Цена и кнопка
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textPrimaryDark,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceL,
                    vertical: AppDimens.spaceS,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  VideoControllerService().pauseCurrentVideo();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        locationId: id.toString(),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Узнать больше',
                  style: AppTextStyles.buttonLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

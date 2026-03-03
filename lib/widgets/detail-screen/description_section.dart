import 'package:flutter/material.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';

class DescriptionSection extends StatelessWidget {
  final LocationModel location;
  final Color textPrimary;
  final Color textSecondary;

  const DescriptionSection({
    super.key,
    required this.location,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "О месте",
              style: AppTextStyles.headlineMedium.copyWith(color: textPrimary),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceS),
        Text(
          location.longDescription.isNotEmpty
              ? location.longDescription
              : location.description,
          style: AppTextStyles.bodyLarge.copyWith(
            color: textSecondary,
            height: 1.65,
          ),
        ),
      ],
    );
  }
}

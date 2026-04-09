import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/data/models/guides_model.dart';

class PriceInfoCard extends StatelessWidget {
  final GuidesModel guide;
  final int depositAmount;
  final int remainingAmount;
  final double depositPercent;

  const PriceInfoCard({
    super.key,
    required this.guide,
    required this.depositAmount,
    required this.remainingAmount,
    required this.depositPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cardDark,
            AppColors.cardDark.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Полная стоимость',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              Text(
                '${guide.priceService} сом',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceM),
          const Divider(color: Colors.white12),
          const SizedBox(height: AppDimens.spaceM),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimens.spaceXS),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    AppDimens.radiusS,
                  ),
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 20,
                  color: Colors.amber.shade400,
                ),
              ),
              const SizedBox(width: AppDimens.spaceS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Депозит для бронирования (${depositPercent.toInt()}%)',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.amber.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Остаток $remainingAmount сом — гиду на месте',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$depositAmount сом',
                style: AppTextStyles.titleMedium.copyWith(
                  color: Colors.amber.shade400,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

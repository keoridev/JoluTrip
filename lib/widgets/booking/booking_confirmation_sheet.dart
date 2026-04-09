import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/data/models/guides_model.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';

class BookingConfirmationSheet extends StatelessWidget {
  final DateTime selectedDate;
  final GuidesModel guide;
  final int depositAmount;
  final int remainingAmount;
  final double depositPercent;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const BookingConfirmationSheet({
    super.key,
    required this.selectedDate,
    required this.guide,
    required this.depositAmount,
    required this.remainingAmount,
    required this.depositPercent,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusXL),
        ),
      ),
      padding: const EdgeInsets.all(AppDimens.spaceL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),
          Container(
            padding: const EdgeInsets.all(AppDimens.spaceM),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: AppDimens.spaceM),
          Text(
            'Подтверждение брони',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          const SizedBox(height: AppDimens.spaceS),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceL,
              vertical: AppDimens.spaceS,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgDark,
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
            ),
            child: Text(
              DateFormat('d MMMM yyyy', 'ru').format(selectedDate),
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),
          Container(
            padding: const EdgeInsets.all(AppDimens.spaceM),
            decoration: BoxDecoration(
              color: AppColors.bgDark,
              borderRadius: BorderRadius.circular(AppDimens.radiusL),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                _buildPriceRow('Полная стоимость', '${guide.priceService} сом'),
                const SizedBox(height: AppDimens.spaceS),
                const Divider(color: Colors.white12),
                const SizedBox(height: AppDimens.spaceS),
                _buildPriceRow(
                  'Депозит (${depositPercent.toInt()}%)',
                  '$depositAmount сом',
                  isHighlighted: true,
                  color: Colors.amber.shade400,
                ),
                const SizedBox(height: AppDimens.spaceS),
                Container(
                  padding: const EdgeInsets.all(AppDimens.spaceS),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppDimens.spaceS),
                      Expanded(
                        child: Text(
                          'Остаток $remainingAmount сом оплатите гиду на месте',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondaryDark,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusL),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
              ),
              const SizedBox(width: AppDimens.spaceM),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusL),
                    ),
                  ),
                  child: const Text('Перейти к оплате'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceM),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value,
      {bool isHighlighted = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isHighlighted ? color : AppColors.textSecondaryDark,
            fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            color: isHighlighted ? color : AppColors.textPrimaryDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

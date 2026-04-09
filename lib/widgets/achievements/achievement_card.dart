import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/data/models/badge_model.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback? onTap;

  const AchievementCard({
    super.key,
    required this.achievement,
    this.onTap,
  });
  
  get received => null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final status = achievement.status;

    return Card(
      elevation: AppDimens.cardElevation,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(
          color: status == AchievementStatus.completed
              ? achievement.tier.color
              : (isDark
                  ? AppColors.cardDark.withOpacity(0.3)
                  : AppColors.bgLight.withOpacity(0.5)),
          width: status == AchievementStatus.completed ? 2 : 1,
        ),
      ),
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildIconWithStatus(isDark, status),
                  const SizedBox(width: AppDimens.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement.title,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          achievement.description,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildTierBadge(achievement.tier),
                ],
              ),
              if (achievement.status != AchievementStatus.locked) ...[
                const SizedBox(height: AppDimens.spaceM),
                _buildProgressBar(achievement),
                const SizedBox(height: AppDimens.spaceS),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      achievement.getFormattedProgress(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: achievement.tier.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (achievement.reward != null && achievement.isCompleted)
                      _buildRewardChip(achievement.reward!),
                  ],
                ),
              ],
              if (achievement.isCompleted && achievement.completedAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppDimens.spaceS),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          size: 14, color: achievement.tier.color),
                      const SizedBox(width: 4),
                      Text(
                        '${received} ${_formatDate(achievement.completedAt!)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconWithStatus(bool isDark, AchievementStatus status) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: status == AchievementStatus.completed
            ? AppColors.primary.withOpacity(0.1)
            : (isDark ? AppColors.bgDark : AppColors.bgLight),
        border: Border.all(
          color: status == AchievementStatus.completed
              ? AppColors.primary.withOpacity(0.3)
              : (isDark
                  ? AppColors.cardDark.withOpacity(0.5)
                  : AppColors.bgLight.withOpacity(0.8)),
          width: 1,
        ),
      ),
      child: Icon(
        achievement.icon,
        size: 28,
        color: status == AchievementStatus.completed
            ? AppColors.primary
            : (status == AchievementStatus.inProgress
                ? AppColors.primary.withOpacity(0.7)
                : (isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight)),
      ),
    );
  }

  Widget _buildTierBadge(AchievementTier tier) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceS,
        vertical: AppDimens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: tier.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
        border: Border.all(
          color: tier.color.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tier.icon, size: 12, color: tier.color.withOpacity(0.7)),
          const SizedBox(width: 4),
          Text(
            tier.label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: tier.color.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(Achievement achievement) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusS),
      child: LinearProgressIndicator(
        value: achievement.progressRatio,
        backgroundColor: AppColors.accent.withOpacity(0.2),
        color: achievement.tier.color,
        minHeight: 6,
      ),
    );
  }

  Widget _buildRewardChip(Reward reward) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceS,
        vertical: AppDimens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.card_giftcard, size: 12, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            reward.title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

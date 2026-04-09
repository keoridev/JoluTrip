import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';
import 'package:jolu_trip/data/models/badge_model.dart';

class AchievementStats {
  final int completedCount;
  final int totalAchievements;
  final int totalRewards;
  
  const AchievementStats({
    required this.completedCount,
    required this.totalAchievements,
    required this.totalRewards,
  });
  
  double get completionRate => totalAchievements > 0 
      ? completedCount / totalAchievements 
      : 0.0;
  int get percentComplete => (completionRate * 100).round();
}

class AchievementsStatsCard extends StatelessWidget {
  final AchievementStats stats;
  final bool isDark;

  const AchievementsStatsCard({
    super.key,
    required this.stats,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.spaceL),
      padding: const EdgeInsets.all(AppDimens.spaceM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.cardDark.withOpacity(0.8),
                  AppColors.bgDark.withOpacity(0.9)
                ]
              : [
                  AppColors.cardLight.withOpacity(0.9),
                  AppColors.bgLight.withOpacity(0.95)
                ],
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(
          color: isDark
              ? AppColors.cardDark.withOpacity(0.3)
              : AppColors.bgLight.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.emoji_events_rounded,
                value: stats.completedCount.toString(),
                label: l10n.received,
                color: AppColors.primary,
                isDark: isDark,
              ),
              _StatItem(
                icon: Icons.card_giftcard_rounded,
                value: stats.totalRewards.toString(),
                label: l10n.rewards,
                color: AppColors.primary.withOpacity(0.8),
                isDark: isDark,
              ),
              _StatItem(
                icon: Icons.stars_rounded,
                value: stats.totalRewards.toString(),
                label: 'XP',
                color: AppColors.accent.withOpacity(0.8),
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceM),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusS),
            child: LinearProgressIndicator(
              value: stats.completionRate,
              backgroundColor: isDark
                  ? AppColors.cardDark.withOpacity(0.5)
                  : AppColors.bgLight.withOpacity(0.5),
              color: AppColors.primary,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppDimens.spaceS),
          Text(
            '${stats.percentComplete}% ${l10n.completed}',
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimens.spaceS),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: AppDimens.spaceS),
        Text(
          value,
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
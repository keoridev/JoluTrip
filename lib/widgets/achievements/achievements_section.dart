import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/data/models/badge_model.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';
import 'package:jolu_trip/widgets/achievements/achievement_card.dart';
import 'package:jolu_trip/widgets/achievements/achievements_stats_card.dart';

// Провайдеры для достижений (временные, замените на свои)
final groupedAchievementsProvider = Provider<Map<AchievementStatus, List<Achievement>>>((ref) {
  final achievements = AchievementsFactory.getSampleAchievements();
  return {
    AchievementStatus.completed: achievements.where((a) => a.isCompleted).toList(),
    AchievementStatus.inProgress: achievements.where((a) => a.isInProgress).toList(),
    AchievementStatus.locked: achievements.where((a) => a.isLocked).toList(),
  };
});

final achievementsStatsProvider = Provider<AchievementStats>((ref) {
  final achievements = AchievementsFactory.getSampleAchievements();
  final completed = achievements.where((a) => a.isCompleted).length;
  final rewards = achievements.where((a) => a.isCompleted && a.reward != null).length;
  
  return AchievementStats(
    completedCount: completed,
    totalAchievements: achievements.length,
    totalRewards: rewards,
  );
});

class AchievementsSection extends ConsumerWidget {
  final bool isDark;

  const AchievementsSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final groupedAchievements = ref.watch(groupedAchievementsProvider);
    final stats = ref.watch(achievementsStatsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок секции
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceL),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🏆 ${l10n.achievements}',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceS,
                  vertical: AppDimens.spaceXS,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.cardDark.withOpacity(0.8)
                      : AppColors.cardLight.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  border: Border.all(
                    color: isDark
                        ? AppColors.cardDark.withOpacity(0.3)
                        : AppColors.bgLight.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${stats.completedCount}/${stats.totalAchievements}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.spaceM),

        // Статистика
        AchievementsStatsCard(
          stats: stats,
          isDark: isDark,
        ),
        const SizedBox(height: AppDimens.spaceL),

        // Выполненные достижения
        if (groupedAchievements[AchievementStatus.completed]?.isNotEmpty == true)
          _buildStatusSection(
            context,
            '✅ ${l10n.badgesReceived}',
            groupedAchievements[AchievementStatus.completed]!,
            Icons.check_circle_rounded,
            AppColors.primary,
          ),

        // В процессе
        if (groupedAchievements[AchievementStatus.inProgress]?.isNotEmpty == true)
          _buildStatusSection(
            context,
            '⚡ ${l10n.badgesInProgress}',
            groupedAchievements[AchievementStatus.inProgress]!,
            Icons.trending_up_rounded,
            Colors.orange[600]!,
          ),

        // Заблокированные
        if (groupedAchievements[AchievementStatus.locked]?.isNotEmpty == true)
          _buildStatusSection(
            context,
            '🔒 ${l10n.locked}',
            groupedAchievements[AchievementStatus.locked]!,
            Icons.lock_outline_rounded,
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
      ],
    );
  }

  Widget _buildStatusSection(
    BuildContext context,
    String title,
    List<Achievement> achievements,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceL),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: AppDimens.spaceS),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: color,
                ),
              ),
              const SizedBox(width: AppDimens.spaceS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceS,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimens.radiusM),
                ),
                child: Text(
                  '${achievements.length}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.spaceM),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceL),
          itemCount: achievements.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppDimens.spaceM),
          itemBuilder: (context, index) {
            return AchievementCard(
              achievement: achievements[index],
              onTap: () => _showAchievementDialog(context, achievements[index]),
            );
          },
        ),
        const SizedBox(height: AppDimens.spaceL),
      ],
    );
  }

  void _showAchievementDialog(BuildContext context, Achievement achievement) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
        ),
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        child: Container(
          padding: const EdgeInsets.all(AppDimens.spaceL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusL),
            color: isDark ? AppColors.bgDark : AppColors.bgLight,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(achievement.icon,
                        size: 40, color: achievement.tier.color),
                    const SizedBox(width: AppDimens.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement.title,
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildTierBadge(achievement.tier),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceL),
                Text(
                  achievement.fullDescription,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceM),
                if (achievement.requirements.isNotEmpty) ...[
                  const Divider(),
                  Text(
                    '📋 ${l10n.requirements}:',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceS),
                  ...achievement.requirements.map(
                    (req) => Padding(
                      padding: const EdgeInsets.only(bottom: AppDimens.spaceXS),
                      child: Row(
                        children: [
                          Icon(Icons.checklist_rounded,
                              size: 16, color: achievement.tier.color),
                          const SizedBox(width: AppDimens.spaceS),
                          Expanded(
                              child: Text(req, 
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
                if (achievement.reward != null && achievement.isCompleted) ...[
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.all(AppDimens.spaceM),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimens.radiusM),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.card_giftcard, color: AppColors.primary),
                        const SizedBox(width: AppDimens.spaceM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🎁 ${achievement.reward!.title}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                              Text(
                                achievement.reward!.description,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                              if (achievement.reward!.code != null)
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: AppDimens.spaceS),
                                  padding: const EdgeInsets.all(AppDimens.spaceS),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                                    borderRadius:
                                        BorderRadius.circular(AppDimens.radiusS),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.3),
                                    ),
                                  ),
                                  child: SelectableText(
                                    achievement.reward!.code!,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppDimens.spaceL),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusM),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.close),
                  ),
                ),
              ],
            ),
          ),
        ),
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
        color: tier.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
      ),
      child: Text(
        tier.label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: tier.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
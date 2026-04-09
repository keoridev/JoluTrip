import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jolu_trip/data/models/badge_model.dart';

// Провайдер для прогресса пользователя (в реальном приложении берется из Firebase)
final userProgressProvider = StateProvider<UserProgress>((ref) {
  // TODO: Загружать из Firebase/Firestore
  return const UserProgress(
    totalDistance: 127,
    trashCollected: 3,
    routesCompleted: 7,
    nightsInYurts: 1,
    sunrisePhotos: 2,
    horseRides: 1,  
    campfires: 2,
    sharedLocations: 4,
  );
});

// Провайдер для всех достижений
final achievementsProvider = Provider<List<Achievement>>((ref) {
  final progress = ref.watch(userProgressProvider);
  return AchievementsFactory.getAllAchievements(progress);
});

// Провайдер для группировки достижений по статусу
final groupedAchievementsProvider =
    Provider<Map<AchievementStatus, List<Achievement>>>((ref) {
  final achievements = ref.watch(achievementsProvider);
  return {
    AchievementStatus.completed:
        achievements.where((a) => a.isCompleted).toList(),
    AchievementStatus.inProgress:
        achievements.where((a) => a.isInProgress).toList(),
    AchievementStatus.locked: achievements.where((a) => a.isLocked).toList(),
  };
});

// Провайдер для статистики (сколько получено наград)
final achievementsStatsProvider = Provider<AchievementStats>((ref) {
  final achievements = ref.watch(achievementsProvider);
  final completed = achievements.where((a) => a.isCompleted).length;
  final totalRewards =
      achievements.where((a) => a.isCompleted && a.reward != null).length;
  final totalXp = achievements
      .where((a) => a.isCompleted && a.reward?.type == RewardType.experience)
      .fold(0, (sum, a) => sum + (a.reward?.value as int? ?? 0));

  return AchievementStats(
    totalAchievements: achievements.length,
    completedCount: completed,
    totalRewards: totalRewards,
    totalXp: totalXp,
    completionRate: achievements.isEmpty ? 0 : completed / achievements.length,
  );
});

class AchievementStats {
  final int totalAchievements;
  final int completedCount;
  final int totalRewards;
  final int totalXp;
  final double completionRate;

  const AchievementStats({
    required this.totalAchievements,
    required this.completedCount,
    required this.totalRewards,
    required this.totalXp,
    required this.completionRate,
  });

  int get percentComplete => (completionRate * 100).round();
}

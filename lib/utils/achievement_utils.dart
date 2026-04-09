import 'package:jolu_trip/data/models/badge_model.dart';

class AchievementUtils {
  // Обновление прогресса на основе действий пользователя
  static UserProgress updateProgressByAction(
    UserProgress currentProgress,
    String actionType,
    int value,
  ) {
    switch (actionType) {
      case 'distance':
        return currentProgress.copyWith(
          totalDistance: currentProgress.totalDistance + value,
        );
      case 'trash':
        return currentProgress.copyWith(
          trashCollected: currentProgress.trashCollected + value,
        );
      case 'route':
        return currentProgress.copyWith(
          routesCompleted: currentProgress.routesCompleted + 1,
        );
      case 'yurt':
        return currentProgress.copyWith(
          nightsInYurts: currentProgress.nightsInYurts + 1,
        );
      case 'sunrise':
        return currentProgress.copyWith(
          sunrisePhotos: currentProgress.sunrisePhotos + 1,
        );
      case 'horse':
        return currentProgress.copyWith(
          horseRides: currentProgress.horseRides + 1,
        );
      case 'campfire':
        return currentProgress.copyWith(
          campfires: currentProgress.campfires + 1,
        );
      case 'share':
        return currentProgress.copyWith(
          sharedLocations: currentProgress.sharedLocations + 1,
        );
      default:
        return currentProgress;
    }
  }

  // Проверка, какие достижения были завершены после обновления
  static List<Achievement> getNewlyCompletedAchievements(
    UserProgress oldProgress,
    UserProgress newProgress,
  ) {
    final oldAchievements = AchievementsFactory.getAllAchievements(oldProgress);
    final newAchievements = AchievementsFactory.getAllAchievements(newProgress);

    final newlyCompleted = <Achievement>[];

    for (int i = 0; i < oldAchievements.length; i++) {
      if (!oldAchievements[i].isCompleted && newAchievements[i].isCompleted) {
        newlyCompleted.add(newAchievements[i]);
      }
    }

    return newlyCompleted;
  }

  // Получить доступные купоны/скидки
  static List<Reward> getAvailableRewards(List<Achievement> achievements) {
    return achievements
        .where(
            (a) => a.isCompleted && a.reward != null && !a.reward!.isRedeemed)
        .map((a) => a.reward!)
        .toList();
  }
}

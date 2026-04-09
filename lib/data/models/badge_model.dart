import 'package:flutter/material.dart';

enum AchievementStatus { locked, inProgress, completed }

enum AchievementTier {
  bronze(Color(0xFFCD7F32), 'Бронза', Icons.emoji_events_outlined),
  silver(Color(0xFFC0C0C0), 'Серебро', Icons.emoji_events_outlined),
  gold(Color(0xFFFFD700), 'Золото', Icons.emoji_events_outlined),
  platinum(Color(0xFFE5E4E2), 'Платина', Icons.emoji_events_outlined),
  legendary(Color(0xFFFF6B35), 'Легенда', Icons.emoji_events_rounded);

  final Color color;
  final String label;
  final IconData icon;
  const AchievementTier(this.color, this.label, this.icon);
}

enum RewardType {
  discount,
  coupon,
  experience,
  virtualBadge,
}

class Reward {
  final String id;
  final String title;
  final String description;
  final RewardType type;
  final dynamic value; // процент скидки, ID купона и т.д.
  final String? code;
  final DateTime? validUntil;
  final bool isRedeemed;

  const Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.value,
    this.code,
    this.validUntil,
    this.isRedeemed = false,
  });

  String getFormattedValue(BuildContext context) {
    switch (type) {
      case RewardType.discount:
        return '${value}% скидка';
      case RewardType.coupon:
        return code ?? 'Купон';
      case RewardType.experience:
        return '+$value XP';
      case RewardType.virtualBadge:
        return 'Эксклюзивный значок';
    }
  }
}

class AchievementPhoto {
  final String id;
  final String url;
  final DateTime uploadedAt;
  final String? caption;

  const AchievementPhoto({
    required this.id,
    required this.url,
    required this.uploadedAt,
    this.caption,
  });
}

class UserProgress {
  final int totalDistance; // км
  final int trashCollected; // кг
  final int routesCompleted;
  final int nightsInYurts;
  final int sunrisePhotos;
  final int sharedLocations;
  final int horseRides;
  final int campfires;

  const UserProgress({
    this.totalDistance = 0,
    this.trashCollected = 0,
    this.routesCompleted = 0,
    this.nightsInYurts = 0,
    this.sunrisePhotos = 0,
    this.sharedLocations = 0,
    this.horseRides = 0,
    this.campfires = 0,
  });

  UserProgress copyWith({
    int? totalDistance,
    int? trashCollected,
    int? routesCompleted,
    int? nightsInYurts,
    int? sunrisePhotos,
    int? sharedLocations,
    int? horseRides,
    int? campfires,
  }) {
    return UserProgress(
      totalDistance: totalDistance ?? this.totalDistance,
      trashCollected: trashCollected ?? this.trashCollected,
      routesCompleted: routesCompleted ?? this.routesCompleted,
      nightsInYurts: nightsInYurts ?? this.nightsInYurts,
      sunrisePhotos: sunrisePhotos ?? this.sunrisePhotos,
      sharedLocations: sharedLocations ?? this.sharedLocations,
      horseRides: horseRides ?? this.horseRides,
      campfires: campfires ?? this.campfires,
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String fullDescription;
  final IconData icon;
  final AchievementTier tier;
  final List<String> requirements;
  final Reward? reward;
  final String? trackingMetric; // 'distance', 'trash', 'routes' и т.д.
  final int targetValue;
  final int currentValue;
  final DateTime? completedAt;
  final List<AchievementPhoto> photos;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.fullDescription,
    required this.icon,
    required this.tier,
    this.requirements = const [],
    this.reward,
    this.trackingMetric,
    this.targetValue = 1,
    this.currentValue = 0,
    this.completedAt,
    this.photos = const [],
  });

  AchievementStatus get status {
    if (completedAt != null) return AchievementStatus.completed;
    if (currentValue > 0) return AchievementStatus.inProgress;
    return AchievementStatus.locked;
  }

  bool get isCompleted => status == AchievementStatus.completed;
  bool get isInProgress => status == AchievementStatus.inProgress;
  bool get isLocked => status == AchievementStatus.locked;

  double get progressRatio => targetValue > 0 
      ? (currentValue / targetValue).clamp(0.0, 1.0) 
      : 0.0;
  int get percent => (progressRatio * 100).round();

  String get progressText => '$currentValue/$targetValue';

  String getFormattedProgress() {
    if (trackingMetric == 'distance') return '$currentValue/$targetValue км';
    if (trackingMetric == 'trash') return '$currentValue/$targetValue кг';
    return progressText;
  }
}

// Фабрика достижений
class AchievementsFactory {
  static Achievement distanceAchievement({int km = 0}) => Achievement(
        id: 'distance_master',
        title: 'Путешественник',
        description: 'Преодолейте 150 км по Кыргызстану',
        fullDescription:
            'Каждый километр приближает вас к новым открытиям. Чем больше вы путешествуете, тем больше экономите на топливе!',
        icon: Icons.local_gas_station_rounded,
        tier: AchievementTier.silver,
        requirements: [
          'Включить отслеживание маршрута',
          'Проехать 150+ км',
          'Сделать фото в пути'
        ],
        reward: Reward(
          id: 'fuel_discount',
          title: 'Топливный бонус',
          description: 'Скидка на топливо в партнерских заправках',
          type: RewardType.discount,
          value: 10,
          code: 'FUEL150',
          validUntil: DateTime.now().add(const Duration(days: 90)),
        ),
        trackingMetric: 'distance',
        targetValue: 150,
        currentValue: km.clamp(0, 150),
      );

  static Achievement ecoAchievement({int kg = 0}) => Achievement(
        id: 'eco_hero',
        title: 'Хранитель природы',
        description: 'Соберите 5 кг мусора в горах',
        fullDescription:
            'Вы не просто путешественник — вы защитник природы! Каждый собранный килограмм делает Кыргызстан чище.',
        icon: Icons.eco_rounded,
        tier: AchievementTier.gold,
        requirements: [
          'Сфотографировать место до уборки',
          'Загрузить фото "после"',
          'Отметить локацию на карте'
        ],
        reward: Reward(
          id: 'eco_shop_discount',
          title: 'Эко-скидка',
          description: 'Скидка в магазине экотоваров',
          type: RewardType.discount,
          value: 15,
          code: 'ECO15',
          validUntil: DateTime.now().add(const Duration(days: 60)),
        ),
        trackingMetric: 'trash',
        targetValue: 5,
        currentValue: kg.clamp(0, 5),
      );

  static Achievement routesAchievement({int routes = 0}) => Achievement(
        id: 'route_master',
        title: 'Покоритель маршрутов',
        description: 'Пройдите 10 пеших маршрутов',
        fullDescription:
            'Настоящий исследователь! Вы покорили десяток уникальных маршрутов разной сложности.',
        icon: Icons.hiking_rounded,
        tier: AchievementTier.platinum,
        requirements: [
          'Пройти маркированный маршрут',
          'Достичь высоты 3000м+',
          'Сделать панорамное фото'
        ],
        reward: Reward(
          id: 'gear_discount',
          title: 'Снаряжение со скидкой',
          description: 'Скидка на туристическое снаряжение',
          type: RewardType.discount,
          value: 20,
          code: 'HIKER20',
          validUntil: DateTime.now().add(const Duration(days: 120)),
        ),
        trackingMetric: 'routes',
        targetValue: 10,
        currentValue: routes.clamp(0, 10),
      );

  static Achievement yurtAchievement({int nights = 0}) => Achievement(
        id: 'nomad_spirit',
        title: 'Кочевник',
        description: 'Переночуйте 3 ночи в юртах',
        fullDescription:
            'Настоящий дух кочевой цивилизации! Звездное небо вместо крыши, тепло очага и гостеприимство.',
        icon: Icons.cabin_rounded,
        tier: AchievementTier.silver,
        requirements: [
          'Забронировать юрту через Jolu',
          'Сделать фото внутри/снаружи',
          'Пробыть минимум 8 часов'
        ],
        reward: Reward(
          id: 'yurt_discount',
          title: 'Юрта со скидкой',
          description: 'Скидка на следующее бронирование юрты',
          type: RewardType.discount,
          value: 25,
          code: 'NOMAD25',
          validUntil: DateTime.now().add(const Duration(days: 180)),
        ),
        trackingMetric: 'yurt_nights',
        targetValue: 3,
        currentValue: nights.clamp(0, 3),
      );

  static Achievement sunriseAchievement({int photos = 0}) => Achievement(
        id: 'sunrise_chaser',
        title: 'Охотник за рассветами',
        description: 'Сделайте 5 фото на рассвете',
        fullDescription:
            'Рассвет в горах — магическое время. Вы не боитесь раннего подъема ради красоты!',
        icon: Icons.wb_sunny_rounded,
        tier: AchievementTier.gold,
        requirements: [
          'Фото сделано до 6:00 утра',
          'На фото видны горные вершины',
          'Естественное освещение'
        ],
        reward: Reward(
          id: 'photo_workshop',
          title: 'Мастер-класс по фотографии',
          description: 'Бесплатный мастер-класс от профессионального фотографа',
          type: RewardType.experience,
          value: 500,
        ),
        trackingMetric: 'sunrise_photos',
        targetValue: 5,
        currentValue: photos.clamp(0, 5),
      );

  static Achievement horseAchievement({int rides = 0}) => Achievement(
        id: 'horse_friend',
        title: 'Друг коней',
        description: 'Совершите 3 конные прогулки',
        fullDescription:
            '"Ат — кыргыздын канаты" — лошадь — крылья кыргыза. Вы почувствовали настоящий кочевой дух!',
        icon: Icons.pets_rounded,
        tier: AchievementTier.bronze,
        requirements: [
          'Забронировать прогулку через приложение',
          'Сделать фото с лошадью',
          'Прогулка минимум 1 час'
        ],
        reward: Reward(
          id: 'horse_discount',
          title: 'Конная прогулка со скидкой',
          description: 'Скидка 20% на следующую конную прогулку',
          type: RewardType.discount,
          value: 20,
          code: 'HORSE20',
        ),
        trackingMetric: 'horse_rides',
        targetValue: 3,
        currentValue: rides.clamp(0, 3),
      );

  static Achievement campfireAchievement({int campfires = 0}) => Achievement(
        id: 'fire_keeper',
        title: 'Мастер костра',
        description: 'Разведите костер в 5 разных местах',
        fullDescription:
            'Треск дров, звезды над головой, тепло огня и песни под гитару — настоящая романтика походов!',
        icon: Icons.local_fire_department_rounded,
        tier: AchievementTier.silver,
        requirements: [
          'Ночевка на природе',
          'Фото костра с геометкой',
          'Приготовить ужин на костре'
        ],
        reward: Reward(
          id: 'camping_set',
          title: 'Набор туриста',
          description: 'Скидка на костровое снаряжение',
          type: RewardType.discount,
          value: 15,
          code: 'CAMP15',
        ),
        trackingMetric: 'campfires',
        targetValue: 5,
        currentValue: campfires.clamp(0, 5),
      );

  static Achievement shareAchievement({int shares = 0}) => Achievement(
        id: 'local_guide',
        title: 'Локальный гид',
        description: 'Поделитесь 10 локациями',
        fullDescription:
            'Вы не жадина! Делитесь находками с другими путешественниками и помогайте открывать Кыргызстан.',
        icon: Icons.share_rounded,
        tier: AchievementTier.bronze,
        requirements: [
          'Поделиться локацией через приложение',
          'Друг перешел по вашей ссылке',
          'Добавить комментарий к локации'
        ],
        reward: Reward(
          id: 'guide_badge',
          title: 'Знак "Локальный гид"',
          description: 'Эксклюзивный виртуальный значок в профиль',
          type: RewardType.virtualBadge,
          value: 'guide_badge',
        ),
        trackingMetric: 'shares',
        targetValue: 10,
        currentValue: shares.clamp(0, 10),
      );

  static List<Achievement> getAllAchievements(UserProgress progress) {
    return [
      distanceAchievement(km: progress.totalDistance),
      ecoAchievement(kg: progress.trashCollected),
      routesAchievement(routes: progress.routesCompleted),
      yurtAchievement(nights: progress.nightsInYurts),
      sunriseAchievement(photos: progress.sunrisePhotos),
      horseAchievement(rides: progress.horseRides),
      campfireAchievement(campfires: progress.campfires),
      shareAchievement(shares: progress.sharedLocations),
    ];
  }

  static List<Achievement> getSampleAchievements() {
    return getAllAchievements(const UserProgress(
      totalDistance: 127,
      trashCollected: 3,
      routesCompleted: 7,
      nightsInYurts: 1,
      sunrisePhotos: 2,
      horseRides: 1,
      campfires: 2,
      sharedLocations: 4,
    ));
  }
}
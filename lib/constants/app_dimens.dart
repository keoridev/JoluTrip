import 'package:flutter/material.dart';

class AppDimens {
  // ===== БАЗОВЫЙ РАЗМЕР =====
  static const double baseUnit = 8.0;

  // ===== ОТСТУПЫ (SPACING) =====
  static const double spaceXXS = 4.0;
  static const double spaceXS = 8.0;
  static const double spaceS = 12.0;
  static const double spaceM = 16.0; // Стандарт для отступов от краев экрана
  static const double spaceL = 24.0; // Между логическими блоками
  static const double spaceXL = 32.0; // Перед большими заголовками
  static const double spaceXXL = 48.0;

  // ===== РАДИУСЫ СКРУГЛЕНИЯ (Более мягкие для тревела) =====
  static const double radiusS = 8.0; // Маленькие элементы (теги, чипсы)
  static const double radiusM = 16.0; // Кнопки и инфо-плашки
  static const double radiusL = 24.0; // СТАНДАРТ для карточек локаций и гидов
  static const double radiusXL = 32.0; // Для верхних блоков (Header)
  static const double radiusRound = 999.0;

  // ===== РАЗМЕРЫ ВИДЖЕТОВ NOMAD GUIDE =====
  static const double guideAvatarSize = 56.0; // Круглый аватар гида в списке
  static const double guideVideoThumbHeight = 200.0; // Высота превью видео гида
  static const double categoryIconSize =
      64.0; // Наши круглые иконки фильтров (горы, авто)

  static const double iconSizeS = 20.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;

  // Высота кнопок
  static const double buttonHeightM = 52.0;
  static const double buttonHeightL = 60.0; // Основная кнопка "WhatsApp"

  // ===== ГЕОМЕТРИЯ ЭКРАНА =====
  static const double bottomNavHeight =
      84.0; // Чуть выше стандартного для красоты
  static const double cardElevation =
      0.0; // В темной теме лучше использовать границы, а не тени

  // ===== ГОТОВЫЕ ПАДДИНГИ =====
  // Отступ по умолчанию для всех экранов (Safe Area)
  static const EdgeInsets screenPadding = EdgeInsets.all(spaceM);

  // Для горизонтальных списков (например, фильтры авто)
  static const EdgeInsets horizontalListPadding = EdgeInsets.symmetric(
    horizontal: spaceM,
  );

  // Паддинг внутри карточки места
  static const EdgeInsets cardContentPadding = EdgeInsets.all(spaceM);

  // Специфический отступ для текста поверх видео (Discovery Screen)
  static const EdgeInsets videoOverlayPadding = EdgeInsets.only(
    left: spaceM,
    right: spaceM,
    bottom: spaceXXL + spaceM, // Учитываем высоту Bottom Bar
  );
}

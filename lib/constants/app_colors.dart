import 'package:flutter/material.dart';

class AppColors {
  // НОВЫЕ ПРИРОДНЫЕ ЦВЕТА: Дружелюбность и надежность

  // Основной цвет (акценты, кнопки): "Горный Озерный" (спокойный, глубокий сине-зеленый)
  static const Color primary = Color(0xFF00796B);
  // Вторичный цвет (бейджи, детали): "Песчаный Каньон" (теплый бежевый)
  static const Color accent = Color(0xFFD7CCC8);

  // ТЕМНАЯ ТЕМА (Основная для видео)
  static const Color textPrimaryDark = Color(0xFFF5F5F7);
  static const Color textSecondaryDark = Color(0xFFA1A1AA);
  // Скаффолд: "Глубокий Сланец" (очень темный серый, теплый оттенок)
  static const Color bgDark = Color(0xFF1A1D21);
  static const Color cardDark = Color(0xFF252930);

  // СВЕТЛАЯ ТЕМА (Для админки/профиля)
  static const Color textPrimaryLight = Color(0xFF1D1D1F);
  static const Color textSecondaryLight = Color(0xFF6E6E73);
  static const Color bgLight = Color(0xFFF5F5F7);
  static const Color cardLight = Colors.white;

  static const Color error = Color(0xFFEF5350);

  // --- Настройка тем ---
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgDark,
    cardColor: cardDark,
    primaryColor: primary,
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: accent,
      surface: cardDark,
      background: bgDark,
    ),
    useMaterial3: true,
    // Шрифты: Чистый Inter или Montserrat
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textPrimaryDark, fontFamily: 'Inter'),
      bodyMedium: TextStyle(color: textSecondaryDark, fontFamily: 'Inter'),
      headlineSmall:
          TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: bgLight,
    cardColor: cardLight,
    primaryColor: primary,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: accent,
      surface: cardLight,
      background: bgLight,
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textPrimaryLight, fontFamily: 'Inter'),
      bodyMedium: TextStyle(color: textSecondaryLight, fontFamily: 'Inter'),
      headlineSmall:
          TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
    ),
  );
}

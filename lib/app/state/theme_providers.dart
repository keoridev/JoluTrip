import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

final themeControllerProvider = Provider<ThemeController>((ref) {
  return ThemeController(ref);
});

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.dark;

  void setThemeMode(ThemeMode mode) => state = mode;
}

class ThemeController {
  ThemeController(this._ref);

  final Ref _ref;

  void setThemeMode(ThemeMode mode) {
    _ref.read(themeModeProvider.notifier).setThemeMode(mode);
  }

  void toggleTheme(bool isDark) {
    setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  bool isDarkMode(BuildContext context) {
    final themeMode = _ref.read(themeModeProvider);
    if (themeMode == ThemeMode.dark) return true;
    if (themeMode == ThemeMode.light) return false;
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.dark;
});

final themeControllerProvider = Provider((ref) {
  return ThemeController(ref: ref);
});

class ThemeController {
  final Ref ref;

  ThemeController({required this.ref});

  void toggleTheme(bool isDark) {

    ref.read(themeModeProvider.notifier).state =
        isDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool isDarkMode(BuildContext context) {
    final themeMode = ref.read(themeModeProvider);
    if (themeMode == ThemeMode.dark) return true;
    if (themeMode == ThemeMode.light) return false;
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';
import 'package:jolu_trip/providers/profile_provider.dart';
import 'package:jolu_trip/widgets/profile/profile_header.dart';
import 'package:jolu_trip/widgets/profile/profile_menu_card.dart';
import 'package:jolu_trip/widgets/profile/profile_settings_tile.dart';
import 'package:jolu_trip/widgets/profile/unauthorized_profile_content.dart';
import 'package:jolu_trip/widgets/achievements/achievements_section.dart'; // 👈 ДОБАВИТЬ ЭТОТ ИМПОРТ

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => _LoadingScreen(isDark: isDark),
      error: (err, _) => _ErrorScreen(error: err, isDark: isDark, l10n: l10n),
      data: (user) => user == null
          ? _UnauthorizedScreen(isDark: isDark, l10n: l10n)
          : _AuthorizedScreen(user: user, isDark: isDark, l10n: l10n),
    );
  }
}

// Загрузка
class _LoadingScreen extends StatelessWidget {
  final bool isDark;
  const _LoadingScreen({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// Ошибка
class _ErrorScreen extends StatelessWidget {
  final Object error;
  final bool isDark;
  final AppLocalizations l10n;

  const _ErrorScreen({
    required this.error, 
    required this.isDark, 
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppDimens.spaceM),
            Text(
              '${l10n.errorPrefix} $error', 
              style: AppTextStyles.bodyLarge.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Не авторизован
class _UnauthorizedScreen extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l10n;

  const _UnauthorizedScreen({required this.isDark, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: UnauthorizedProfileContent(isDark: isDark, l10n: l10n),
      ),
    );
  }
}

// Авторизован
class _AuthorizedScreen extends ConsumerWidget {
  final User user;
  final bool isDark;
  final AppLocalizations l10n;

  const _AuthorizedScreen({
    required this.user, 
    required this.isDark, 
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        elevation: 0,
        title: Text(
          l10n.profile,
          style: AppTextStyles.headlineMedium.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            onPressed: () => ref.read(profileRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppDimens.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Профиль
            ProfileHeader(user: user, isDark: isDark, l10n: l10n),
            const SizedBox(height: AppDimens.spaceXL),

            // 👇👇👇 ДОБАВИТЬ СЕКЦИЮ ДОСТИЖЕНИЙ 👇👇👇
            AchievementsSection(isDark: isDark),
            const SizedBox(height: AppDimens.spaceXL),
            // 👆👆👆 КОНЕЦ СЕКЦИИ ДОСТИЖЕНИЙ 👆👆👆

            // Меню
            _buildMenu(context, ref),
            const SizedBox(height: AppDimens.spaceXL),

            // Настройки
            SectionTitle(title: l10n.settings, isDark: isDark),
            const SizedBox(height: AppDimens.spaceM),
            ProfileSettingsTile(),
            const SizedBox(height: AppDimens.spaceXXL),

            // Версия
            Center(
              child: Text(
                l10n.version,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _FavoritesCard(userId: user.uid, isDark: isDark, l10n: l10n),
        const SizedBox(height: AppDimens.spaceM),
        ProfileMenuCard(
          icon: Icons.map_outlined,
          title: l10n.myRoutes,
          subtitle: l10n.createYourPath,
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
          isDark: isDark,
        ),
      ],
    );
  }
}

// Избранное с Riverpod
class _FavoritesCard extends ConsumerWidget {
  final String userId;
  final bool isDark;
  final AppLocalizations l10n;

  const _FavoritesCard({
    required this.userId, 
    required this.isDark, 
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesStreamProvider(userId));

    return favoritesAsync.when(
      data: (favs) => ProfileMenuCard(
        icon: Icons.favorite_rounded,
        title: l10n.favorites,
        subtitle: '${l10n.savedLocations}: ${favs.length}',
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, '/favorites'),
        isDark: isDark,
      ),
      loading: () => ProfileMenuCard(
        icon: Icons.favorite_rounded,
        title: l10n.favorites,
        subtitle: l10n.loading,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
        isDark: isDark,
      ),
      error: (_, __) => ProfileMenuCard(
        icon: Icons.favorite_rounded,
        title: l10n.favorites,
        subtitle: l10n.loadingError,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
        isDark: isDark,
      ),
    );
  }
}

// Простой заголовок секции (локальный)
class SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;

  const SectionTitle({super.key, required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceL),
      child: Text(
        title,
        style: AppTextStyles.headlineMedium.copyWith(
          color:
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
    );
  }
}
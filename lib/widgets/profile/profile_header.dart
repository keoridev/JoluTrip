import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';

class ProfileHeader extends StatelessWidget {
  final User user;
  final bool isDark;
  final AppLocalizations l10n;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.isDark,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = user.displayName ?? l10n.traveler;
    final email = user.email ?? '';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';

    return Row(
      children: [
        // Аватар
        _Avatar(
          photoUrl: user.photoURL,
          initial: initial,
          isDark: isDark,
        ),
        const SizedBox(width: AppDimens.spaceM),
        // Инфо
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              if (email.isNotEmpty)
                Text(
                  email,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? photoUrl;
  final String initial;
  final bool isDark;

  const _Avatar({this.photoUrl, required this.initial, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: AppDimens.radiusXL,
        backgroundColor: AppColors.primary,
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
        child: photoUrl == null
            ? Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }
}
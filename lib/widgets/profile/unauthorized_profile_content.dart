import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';

class UnauthorizedProfileContent extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l10n;

  const UnauthorizedProfileContent({
    super.key,
    required this.isDark,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimens.screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Icon(
              Icons.account_circle_outlined,
              size: 100,
              color: AppColors.primary.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: AppTextStyles.headlineLarge.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
            child: Text(
              l10n.personalAccount,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppDimens.spaceM),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: AppTextStyles.bodyLarge.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            child: Text(
              l10n.loginToPlanning,
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: AppDimens.buttonHeightM,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusM),
                ),
                elevation: 0,
              ),
              onPressed: () => Navigator.pushNamed(context, '/auth'),
              child: Text(l10n.login, style: AppTextStyles.buttonLarge),
            ),
          ),
          const SizedBox(height: AppDimens.spaceM),
          TextButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/auth',
              arguments: {'mode': 'register'},
            ),
            child: Text(
              l10n.createNewProfile,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],
      ),
    );
  }
}

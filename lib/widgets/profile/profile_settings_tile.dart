import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';
import 'package:jolu_trip/providers/locale_provider.dart';

class ProfileSettingsTile extends ConsumerWidget {
  const ProfileSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    final languages = [
      _LanguageData(code: 'en', label: 'English', flag: '🇺🇸'),
      _LanguageData(code: 'ru', label: 'Русский', flag: '🇷🇺'),
      _LanguageData(code: 'ky', label: 'Кыргызча', flag: '🇰🇬'),
    ];

    final current = languages.firstWhere((l) => l.code == currentLocale.languageCode);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceL),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          onTap: () => _showLanguagePicker(context, ref, languages, currentLocale),
          child: Padding(
            padding: AppDimens.cardContentPadding,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimens.spaceS),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimens.radiusS),
                  ),
                  child: const Icon(Icons.language, color: AppColors.primary),
                ),
                const SizedBox(width: AppDimens.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.language,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        current.label,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref, List<_LanguageData> languages, Locale current) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radiusXL)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: AppDimens.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppDimens.spaceL),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ...languages.map((lang) => ListTile(
                leading: Text(lang.flag, style: const TextStyle(fontSize: 24)),
                title: Text(
                  lang.label,
                  style: TextStyle(
                    fontWeight: lang.code == current.languageCode ? FontWeight.bold : FontWeight.normal,
                    color: lang.code == current.languageCode ? AppColors.primary : null,
                  ),
                ),
                trailing: lang.code == current.languageCode
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(Locale(lang.code));
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageData {
  final String code;
  final String label;
  final String flag;

  const _LanguageData({required this.code, required this.label, required this.flag});
}
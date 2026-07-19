import 'package:flutter/material.dart';
import 'package:pip_word_vault/l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../main.dart'; // To access appLocaleNotifier

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: AppColors.outlineVariant, height: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.settings, style: AppTypography.headlineMediumMobile.copyWith(color: AppColors.secondary)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.appLanguage, style: AppTypography.headlineMediumMobile.copyWith(color: AppColors.primary)),
            const SizedBox(height: 16),
            ValueListenableBuilder<Locale>(
              valueListenable: appLocaleNotifier,
              builder: (context, locale, _) {
                return Column(
                  children: [
                    RadioListTile<String>(
                      title: Text(l10n.english, style: AppTypography.bodyLarge),
                      value: 'en',
                      groupValue: locale.languageCode,
                      onChanged: (value) {
                        if (value != null) setAppLocale(value);
                      },
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      title: Text(l10n.arabic, style: AppTypography.bodyLarge),
                      value: 'ar',
                      groupValue: locale.languageCode,
                      onChanged: (value) {
                        if (value != null) setAppLocale(value);
                      },
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

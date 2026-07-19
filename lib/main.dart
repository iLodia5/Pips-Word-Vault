import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pip_word_vault/l10n/app_localizations.dart';
import 'screens/welcome_screen.dart';
import 'layout/main_layout.dart';
import 'theme/colors.dart';

// Global state for app locale
late ValueNotifier<Locale> appLocaleNotifier;

void setAppLocale(String languageCode) async {
  appLocaleNotifier.value = Locale(languageCode);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('languageCode', languageCode);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;
  
  String? savedLang = prefs.getString('languageCode');
  if (savedLang == null) {
    // Detect device language on first open
    final deviceLocale = PlatformDispatcher.instance.locale;
    savedLang = deviceLocale.languageCode == 'ar' ? 'ar' : 'en';
    await prefs.setString('languageCode', savedLang);
  }
  
  appLocaleNotifier = ValueNotifier<Locale>(Locale(savedLang));

  runApp(PipWordVaultApp(hasSeenWelcome: hasSeenWelcome));
}

class PipWordVaultApp extends StatelessWidget {
  final bool hasSeenWelcome;

  const PipWordVaultApp({super.key, required this.hasSeenWelcome});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocaleNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          title: "Pip's Word Vault",
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            useMaterial3: true,
          ),
          home: hasSeenWelcome ? const MainLayout() : const WelcomeScreen(),
        );
      },
    );
  }
}

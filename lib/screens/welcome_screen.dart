import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../layout/main_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pip_word_vault/l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcomeScreen(finalResult).gif',
              fit: BoxFit.cover,
            ),
          ),
          // Gradients
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.surface.withOpacity(0.4),
                    Colors.transparent,
                    Colors.transparent,
                    AppColors.surfaceDim.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App Title
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF301400), width: 2),
                      boxShadow: const [
                        BoxShadow(color: Color(0xFF301400), offset: Offset(0, 6)),
                      ],
                    ),
                    child: Localizations.localeOf(context).languageCode == 'ar' 
                      ? Text(
                          l10n.wordVault.replaceFirst(' ', '\n'),
                          textAlign: TextAlign.center,
                          style: AppTypography.displayLarge.copyWith(
                            height: 1.0,
                            color: AppColors.primaryFixed,
                          ),
                        )
                      : RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTypography.displayLarge.copyWith(
                              height: 1.0,
                              letterSpacing: -0.5,
                            ),
                            children: const [
                              TextSpan(text: 'W', style: TextStyle(color: AppColors.primaryFixed)),
                              TextSpan(text: 'O', style: TextStyle(color: AppColors.secondaryContainer)),
                              TextSpan(text: 'R', style: TextStyle(color: AppColors.tertiaryContainer)),
                              TextSpan(text: 'D', style: TextStyle(color: AppColors.surfaceBright)),
                              TextSpan(text: '\n'),
                              TextSpan(text: 'V', style: TextStyle(color: AppColors.tertiaryContainer)),
                              TextSpan(text: 'A', style: TextStyle(color: AppColors.primaryFixed)),
                              TextSpan(text: 'U', style: TextStyle(color: AppColors.surfaceBright)),
                              TextSpan(text: 'L', style: TextStyle(color: AppColors.secondaryContainer)),
                              TextSpan(text: 'T', style: TextStyle(color: AppColors.primaryFixed)),
                            ],
                          ),
                        ),
                  ),
                  
                  // Description & Pip Image
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0x33301400), width: 2),
                        ),
                        child: Text(
                          l10n.welcomeDescription,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.onSecondaryFixed),
                        ),
                      ),
                      Positioned(
                        bottom: -32,
                        left: -16,
                        width: 160,
                        child: Image.asset(
                          'assets/images/Pip-4.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),

                  // Start Button
                  GestureDetector(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('hasSeenWelcome', true);
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const MainLayout()),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF301400), width: 2),
                        boxShadow: const [
                          BoxShadow(color: Color(0xFF301400), offset: Offset(0, 6)),
                        ],
                      ),
                      child: Text(
                        l10n.start,
                        textAlign: TextAlign.center,
                        style: AppTypography.displayLarge.copyWith(
                          color: AppColors.onSecondary,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

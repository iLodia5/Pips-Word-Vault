import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import 'dart:math';
import 'package:pip_word_vault/l10n/app_localizations.dart';
import '../models/word.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Word> words;
  final VoidCallback onGiftWord;
  final VoidCallback onViewAll;
  final void Function(Word) onRemoveWord;
  final VoidCallback? onGoToVault;

  const HomeScreen({
    super.key,
    required this.words,
    required this.onGiftWord,
    required this.onViewAll,
    required this.onRemoveWord,
    this.onGoToVault,
  });

  @override
  Widget build(BuildContext context) {
    // Only take the newest 5 words for recently carved
    final recentWords = words.take(5).toList();
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
          icon: const Icon(Icons.pets, color: AppColors.primary),
          onPressed: onGoToVault,
        ),
        title: Text(l10n.wordVault, style: AppTypography.headlineMediumMobile.copyWith(color: AppColors.secondary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.secondary),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hero Section
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset(
                'assets/images/Pip_2.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 60, color: AppColors.outlineVariant),
              ),
            ),
            const SizedBox(height: 16),
            Text(l10n.appTitle, style: AppTypography.displayLarge),
            const SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTypography.bodyLarge.copyWith(color: AppColors.onSurfaceVariant),
                children: [
                  TextSpan(text: l10n.youHaveGiftedPip),
                  TextSpan(text: "${words.length}", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
                  TextSpan(text: l10n.wordsSoFarReady),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Gift a Word Button
            GestureDetector(
              onTap: onGiftWord,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                  border: const Border(bottom: BorderSide(color: Color(0xFF653D1E), width: 4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_box, color: AppColors.onSecondary),
                    const SizedBox(width: 8),
                    Text(
                      l10n.giftAWord,
                      style: AppTypography.labelBold.copyWith(color: AppColors.onSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            // Recently Carved
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(l10n.recentlyCarved, style: AppTypography.headlineSmall),
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(l10n.viewAll, style: AppTypography.labelBold.copyWith(color: AppColors.tertiary)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: recentWords.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  if (index == recentWords.length) {
                    return GestureDetector(
                      onTap: onViewAll,
                      child: Container(
                        width: 140,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBright,
                          borderRadius: const BorderRadius.all(Radius.circular(14)),
                          border: Border.all(color: AppColors.outline, width: 2),
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_forward, color: AppColors.outline, size: 32),
                        ),
                      ),
                    );
                  }
                  final word = recentWords[index];
                  return _buildWordCard(word.english, word.arabic, word.types.join('/'), word.hasBookmark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordCard(String english, String arabic, String type, bool hasBookmark) {
    return Transform.rotate(
      angle: (Random().nextDouble() - 0.5) * 0.05,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(14),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(10),
          ),
          border: Border.all(color: AppColors.outline, width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0xFFCBC6BB), offset: Offset(0, 2)),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (hasBookmark)
              Positioned(
                top: -16,
                right: -16,
                child: CustomPaint(
                  size: const Size(16, 16),
                  painter: BookmarkPainter(color: AppColors.tertiary.withOpacity(0.8)),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(english, style: AppTypography.headlineMediumMobile),
                const SizedBox(height: 8),
                Container(height: 2, width: double.infinity, color: AppColors.outlineVariant.withOpacity(0.3)),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(arabic, style: AppTypography.bodyMedium.copyWith(color: AppColors.secondary)),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.tertiary.withOpacity(0.2)),
                  ),
                  child: Text(
                    type.toUpperCase(),
                    style: AppTypography.labelBold.copyWith(fontSize: 10, color: AppColors.tertiary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BookmarkPainter extends CustomPainter {
  final Color color;
  BookmarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

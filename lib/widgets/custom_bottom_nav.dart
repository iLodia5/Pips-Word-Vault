import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import 'package:pip_word_vault/l10n/app_localizations.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: const Border(top: BorderSide(color: AppColors.secondary, width: 4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.2),
            offset: const Offset(0, -4),
          )
        ],
      ),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.account_balance_wallet_outlined, l10n.navVault),
          _buildNavItem(1, Icons.add_box_outlined, l10n.navAdd),
          _buildNavItem(2, Icons.search_outlined, l10n.navSearch),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = currentIndex == index;

    if (isActive) {
      return GestureDetector(
        onTap: () => onTap(index),
        child: Transform.translate(
          offset: const Offset(0, -4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.secondary, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66805533), // rgba(128,85,51,0.4)
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.onSecondaryContainer),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: AppTypography.labelBold.copyWith(
                    color: AppColors.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          width: 64,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.secondary),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.labelBold.copyWith(
                  fontSize: 10,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

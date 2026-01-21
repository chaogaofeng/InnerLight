import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// 3D-styled book cover widget
/// Supports different styles (gold, dark, light) and sizes (sm, lg)
class BookCover extends StatelessWidget {
  final String title;
  final String coverStyle; // 'gold' | 'dark' | 'light'
  final String size; // 'sm' | 'lg'

  const BookCover({
    super.key,
    required this.title,
    required this.coverStyle,
    this.size = 'sm',
  });

  @override
  Widget build(BuildContext context) {
    final isLarge = size == 'lg';
    final width = isLarge ? 100.0 : 60.0;
    final height = isLarge ? 140.0 : 85.0;

    // Color based on style
    Color bgColor;
    Color accentColor;
    switch (coverStyle) {
      case 'gold':
        bgColor = const Color(0xFFD4AF37);
        accentColor = const Color(0xFFFFE55C);
        break;
      case 'dark':
        bgColor = const Color(0xFF3E3832);
        accentColor = const Color(0xFFA6937C);
        break;
      case 'light':
      default:
        bgColor = AppColors.zenPaper;
        accentColor = AppColors.zenBrown;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: AppColors.withOpacity(Colors.black, 0.15),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Spine effect
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.withOpacity(Colors.black, 0.2),
                    AppColors.withOpacity(Colors.black, 0.05),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
            ),
          ),

          // Border decoration
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.withOpacity(accentColor, 0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Corner accent
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              width: isLarge ? 20 : 12,
              height: isLarge ? 20 : 12,
              decoration: BoxDecoration(
                color: AppColors.withOpacity(accentColor, 0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

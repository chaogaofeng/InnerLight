import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Book list item for library view
class BookListItem extends StatelessWidget {
  final String title;
  final String author;
  final String desc;
  final int progress;
  final bool isLast;
  final VoidCallback onTap;

  const BookListItem({
    super.key,
    required this.title,
    required this.author,
    required this.desc,
    required this.progress,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isStarted = progress > 0;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: AppColors.withOpacity(AppColors.zenBrown, 0.05),
                  ),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Title (Left) & Author (Right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.notoSerifBold(16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.withOpacity(AppColors.zenSubtle, 0.8),
                    fontFamily: 'NotoSerif',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Row 2: Desc (Left) & Progress/Action (Right)
            Row(
              children: [
                Expanded(
                  child: Text(
                    desc,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.withOpacity(AppColors.zenSubtle, 0.6),
                      height: 1.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 16),
                if (isStarted) ...[
                  // Progress bar
                  Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: progress / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.zenBrown,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 24,
                    child: Text(
                      '$progress%',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'RobotoMono',
                        color: AppColors.withOpacity(AppColors.zenBrown, 0.8),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ] else
                  Icon(
                    Icons.chevron_right,
                    size: 14,
                    color: AppColors.withOpacity(AppColors.zenBrown, 0.3),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

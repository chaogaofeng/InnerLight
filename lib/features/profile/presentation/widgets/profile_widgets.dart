import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// User profile hero section with avatar and info
class UserHero extends StatelessWidget {
  final String name;
  final String title;
  final Color avatarColor;

  const UserHero({
    super.key,
    required this.name,
    required this.title,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          // Avatar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.withOpacity(AppColors.zenBrown, 0.2),
                width: 2,
              ),
              color: AppColors.zenBg,
            ),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: avatarColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: AppColors.withOpacity(AppColors.zenBrown, 0.4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: AppTextStyles.notoSerifBold(24)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.zenBrown,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.stars,
                            size: 10,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('法腊：128天', style: AppTextStyles.caption),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F1EB),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
                        ),
                      ),
                      child: const Text(
                        '已订阅',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.zenBrown,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Merit statistics display with three columns
class MeritStats extends StatelessWidget {
  final Map<String, int> stats;

  const MeritStats({super.key, required this.stats});

  Widget _buildItem(String value, String label, String subLabel) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTextStyles.notoSerifBold(20)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.zenSubtle,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subLabel,
            style: TextStyle(
              fontSize: 9,
              color: AppColors.withOpacity(AppColors.zenBrown, 0.6),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.zenBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.withOpacity(Colors.black, 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildItem(stats['days'].toString(), '坚持', '连续修行'),
          Container(
            width: 1,
            height: 32,
            color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
          ),
          _buildItem(stats['merit'].toString(), '功德', '累计次数'),
          Container(
            width: 1,
            height: 32,
            color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
          ),
          _buildItem(stats['incense'].toString(), '供养', '敬香/供灯'),
        ],
      ),
    );
  }
}

/// Menu item data class
class MenuItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final String? badge;
  final String? value;

  MenuItem(this.label, this.icon, this.onTap, {this.badge, this.value});
}

/// Menu section with optional title and list of items
class MenuSection extends StatelessWidget {
  final String? title;
  final List<MenuItem> items;

  const MenuSection({super.key, this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(36, 24, 24, 8),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.zenSubtle,
                letterSpacing: 1,
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.zenBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.withOpacity(AppColors.zenBrown, 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.withOpacity(Colors.black, 0.01),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items.map((item) {
              final isLast = item == items.last;
              return InkWell(
                onTap: item.onTap,
                borderRadius: isLast
                    ? const BorderRadius.vertical(bottom: Radius.circular(16))
                    : (items.first == item
                          ? const BorderRadius.vertical(
                              top: Radius.circular(16),
                            )
                          : BorderRadius.zero),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : Border(
                            bottom: BorderSide(
                              color: AppColors.withOpacity(
                                AppColors.zenBrown,
                                0.05,
                              ),
                            ),
                          ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.withOpacity(
                            AppColors.zenBrown,
                            0.05,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.icon,
                          size: 16,
                          color: AppColors.withOpacity(AppColors.zenBrown, 0.7),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.zenInk,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (item.badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item.badge!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (item.value != null)
                        Text(
                          item.value!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.zenSubtle,
                          ),
                        ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: AppColors.zenSubtle,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

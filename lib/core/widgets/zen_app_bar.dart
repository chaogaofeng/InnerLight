import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Standardized AppBar for the Zen app
/// Can be used across all features (profile, ceremony, practice, etc.)
class ZenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? action;

  const ZenAppBar({super.key, required this.title, this.onBack, this.action});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.zenBg,
      elevation: 0,
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.zenInk),
              onPressed: onBack,
            )
          : null,
      title: Text(title, style: AppTextStyles.appBarTitle),
      centerTitle: true,
      actions: action != null ? [action!, const SizedBox(width: 8)] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

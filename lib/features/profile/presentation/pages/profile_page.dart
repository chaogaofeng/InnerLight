import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/zen_app_bar.dart';
import '../widgets/profile_widgets.dart';
import 'legal_page.dart';
import 'share_page.dart';
import 'display_settings_page.dart';
import 'reminder_page.dart';
import 'my_events_page.dart';
import 'subscription_page.dart';
import 'history_page.dart';
import 'my_invites_page.dart';
import 'profile_edit_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Mock Data
  final Map<String, dynamic> _userProfile = {
    'name': '善护念',
    'title': '在家居士',
    'avatarColor': AppColors.zenPaper,
  };

  final Map<String, int> _stats = {
    'days': 5,
    'merit': 218, // Fish + Beads
    'incense': 12,
  };

  void _handleNavigate(String route) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('功能开发中: $route'),
        duration: const Duration(milliseconds: 500),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.zenBrown,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zenBg,
      appBar: ZenAppBar(
        title: '我的',
        action: IconButton(
          icon: const Icon(Icons.settings_outlined, color: AppColors.zenInk),
          onPressed: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileEditPage(
                  initialName: _userProfile['name'],
                  initialTitle: _userProfile['title'],
                  initialColor: _userProfile['avatarColor'],
                ),
              ),
            );

            if (result != null && result is Map<String, dynamic>) {
              if (!mounted) return;
              setState(() {
                _userProfile['name'] = result['name'];
                _userProfile['title'] = result['title'];
                _userProfile['avatarColor'] = result['avatarColor'];
              });

              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: const Text('个人设置已更新'),
                  backgroundColor: AppColors.zenBrown,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            children: [
              // 1. User Hero
              UserHero(
                name: _userProfile['name'],
                title: _userProfile['title'],
                avatarColor: _userProfile['avatarColor'],
              ),

              // 2. Merit Stats
              MeritStats(stats: _stats),

              // 3. Daily Quote
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.zenBrown,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.withOpacity(AppColors.zenBrown, 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: Icon(
                          Icons.description,
                          size: 80,
                          color: AppColors.withOpacity(Colors.white, 0.05),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '今日发愿',
                            style: AppTextStyles.notoSansRegular(
                              10,
                              color: AppColors.withOpacity(Colors.white, 0.6),
                            ).copyWith(letterSpacing: 2),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '"众生无边誓愿度，烦恼无尽誓愿断。"',
                            style: AppTextStyles.notoSerifBold(
                              16,
                              color: Colors.white,
                            ).copyWith(height: 1.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Menu Groups
              MenuSection(
                items: [
                  MenuItem(
                    '我的法会',
                    Icons.notifications_none,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyEventsPage()),
                    ),
                    badge: '1',
                  ),
                  MenuItem(
                    '善捐订阅',
                    Icons.bookmark_border,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SubscriptionPage(),
                      ),
                    ),
                  ),
                  MenuItem(
                    '修行记录',
                    Icons.history,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryPage()),
                    ),
                  ),
                  MenuItem(
                    '我的邀请',
                    Icons.person_add_alt_1_outlined,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyInvitesPage()),
                    ),
                  ),
                ],
              ),

              MenuSection(
                title: '设置与更多',
                items: [
                  MenuItem(
                    '每日提醒',
                    Icons.auto_awesome_outlined,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReminderPage()),
                    ),
                    value: '06:00',
                  ),
                  MenuItem(
                    '显示设置',
                    Icons.dark_mode_outlined,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DisplaySettingsPage(),
                      ),
                    ),
                  ),
                  MenuItem(
                    '分享应用',
                    Icons.share_outlined,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SharePage()),
                    ),
                  ),
                  MenuItem(
                    '平台服务协议',
                    Icons.description_outlined,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const LegalPage(type: LegalType.service),
                      ),
                    ),
                  ),
                  MenuItem(
                    '用户隐私协议',
                    Icons.privacy_tip_outlined,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const LegalPage(type: LegalType.privacy),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 5. Version & Logout
              Column(
                children: [
                  Text(
                    'v1.0.0 · Zen Life',
                    style: AppTextStyles.robotoMono(
                      10,
                      color: AppColors.withOpacity(AppColors.zenSubtle, 0.4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _handleNavigate('logout'),
                    icon: const Icon(
                      Icons.logout,
                      size: 14,
                      color: AppColors.zenBrown,
                    ),
                    label: const Text(
                      '退出登录',
                      style: TextStyle(fontSize: 12, color: AppColors.zenBrown),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.withOpacity(
                        AppColors.zenBrown,
                        0.05,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

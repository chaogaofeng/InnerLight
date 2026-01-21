import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/zen_app_bar.dart';
import '../../../practice/data/mock_data.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Event> _registeredEvents;
  late List<Event> _collectedEvents;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _registeredEvents = mockEvents.take(2).toList();
    _collectedEvents = mockEvents.skip(2).take(2).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zenBg,
      appBar: ZenAppBar(title: '我的法会', onBack: () => Navigator.pop(context)),
      body: Column(
        children: [
          // Tabs
          Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.withOpacity(AppColors.zenPaper, 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.withOpacity(AppColors.zenBrown, 0.05),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.withOpacity(Colors.black, 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: AppColors.zenBrown,
              unselectedLabelColor: AppColors.zenSubtle,
              labelStyle: AppTextStyles.notoSansBold(12, letterSpacing: 1),
              tabs: const [
                Tab(text: '我的报名'),
                Tab(text: '我收藏的'),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEventList(_registeredEvents, isRegistered: true),
                _buildEventList(_collectedEvents, isRegistered: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList(List<Event> events, {required bool isRegistered}) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.zenPaper,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isRegistered ? Icons.inbox_outlined : Icons.favorite_border,
                size: 32,
                color: AppColors.withOpacity(AppColors.zenBrown, 0.4),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isRegistered ? '暂无报名记录' : '暂无收藏内容',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.withOpacity(AppColors.zenSubtle, 0.8),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: events.length + 1,
      itemBuilder: (context, index) {
        // Stats Summary
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 4),
            child: Text(
              '共 ${events.length} 项相关活动',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.zenSubtle,
                letterSpacing: 0.5,
              ),
            ),
          );
        }

        final event = events[index - 1];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.zenLightBeige,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.withOpacity(AppColors.zenBrown, 0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.withOpacity(AppColors.zenBrown, 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Badge
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isRegistered
                          ? AppColors.zenDarkBrown
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.withOpacity(
                          AppColors.zenDarkBrown,
                          isRegistered ? 0 : 0.2,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isRegistered ? '已报' : '收藏',
                          style: TextStyle(
                            fontSize: 10,
                            color: isRegistered
                                ? AppColors.withOpacity(Colors.white, 0.9)
                                : AppColors.zenDarkBrown,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Icon(
                          Icons.confirmation_number_outlined,
                          size: 16,
                          color: isRegistered
                              ? AppColors.withOpacity(Colors.white, 0.9)
                              : AppColors.zenDarkBrown,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: AppTextStyles.notoSerifBold(
                            16,
                          ).copyWith(height: 1.2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 13,
                              color: AppColors.zenSubtle,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                event.time,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF8a8a8a),
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: AppColors.zenSubtle,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                event.temple,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF8a8a8a),
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Arrow
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AppColors.zenAccent,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

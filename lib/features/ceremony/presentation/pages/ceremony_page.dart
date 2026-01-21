import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../features/practice/data/mock_data.dart';
import '../widgets/search_drawer.dart';
import 'ceremony_detail_page.dart';

class CeremonyPage extends StatefulWidget {
  const CeremonyPage({super.key});

  @override
  State<CeremonyPage> createState() => _CeremonyPageState();
}

class _CeremonyPageState extends State<CeremonyPage> {
  String _activeCategory = 'all';
  SearchCriteria _searchCriteria = const SearchCriteria();

  List<Event> get _filteredEvents {
    return mockEvents.where((e) {
      // 1. Category Filter
      if (_activeCategory != 'all' && e.formType != _activeCategory) {
        return false;
      }

      // 2. Keyword Filter
      if (_searchCriteria.keyword.isNotEmpty) {
        final k = _searchCriteria.keyword.toLowerCase();
        final matches =
            e.title.toLowerCase().contains(k) ||
            e.description.toLowerCase().contains(k) ||
            e.temple.toLowerCase().contains(k);
        if (!matches) return false;
      }

      // 3. Location Filter
      if (_searchCriteria.location.isNotEmpty) {
        if (!e.temple.contains(_searchCriteria.location)) return false;
      }

      // 4. Date Filter (Simple mock implementation)
      if (_searchCriteria.startDate.isNotEmpty ||
          _searchCriteria.endDate.isNotEmpty) {
        // Just checking if time string contains '每日' or similar for now as mock data doesn't have real dates
        // In real app, parse e.time or have a date field
        final isDaily = e.time.contains('每日') || e.time.contains('常年');
        if (!isDaily) return false;
      }

      return true;
    }).toList();
  }

  void _openSearchDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFDFCF8), // zen-bg
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SearchDrawer(
        initialCriteria: _searchCriteria,
        onSearch: (criteria) {
          setState(() => _searchCriteria = criteria);
        },
      ),
    );
  }

  void _clearSearch() {
    setState(() => _searchCriteria = const SearchCriteria());
  }

  @override
  Widget build(BuildContext context) {
    // Current date
    final now = DateTime.now();
    final dateStr = '${now.month}月${now.day}日';
    const weekDays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final weekDay = weekDays[now.weekday - 1];

    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF8), // zen-bg
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Center(
                child: Text(
                  '法讯',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
              ),
            ),

            // Hero Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$dateStr · $weekDay',
                        style: GoogleFonts.notoSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '护持三宝 广种福田',
                        style: GoogleFonts.maShanZheng(
                          fontSize: 28,
                          height: 1.2,
                          color: const Color(0xFF2C2C2C),
                        ),
                      ),
                    ],
                  ),
                  // Zen Stamp
                  Transform.rotate(
                    angle: 0.2,
                    child: Opacity(
                      opacity: 0.2,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF8B5A2B),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF8B5A2B)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '禅悦',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.maShanZheng(
                              fontSize: 24,
                              color: const Color(0xFF8B5A2B),
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  ...eventCategories.map((cat) {
                    final isActive = _activeCategory == cat.id;
                    return GestureDetector(
                      onTap: () => setState(() => _activeCategory = cat.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF8B5A2B)
                              : Colors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isActive
                                ? const Color(0xFF8B5A2B)
                                : const Color(
                                    0xFF8B5A2B,
                                  ).withValues(alpha: 0.1),
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF8B5A2B,
                                    ).withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          cat.label,
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            color: isActive
                                ? Colors.white
                                : const Color(
                                    0xFF2C2C2C,
                                  ).withValues(alpha: 0.6),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    );
                  }),
                  Container(
                    width: 1,
                    height: 24,
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  IconButton(
                    onPressed: _openSearchDrawer,
                    icon: Icon(
                      Icons.tune,
                      size: 20,
                      color: !_searchCriteria.isEmpty
                          ? const Color(0xFF8B5A2B)
                          : const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            if (!_searchCriteria.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Row(
                  children: [
                    Text(
                      '筛选结果:',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF2C2C2C).withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_searchCriteria.keyword.isNotEmpty)
                      _buildChip('Key: ${_searchCriteria.keyword}'),
                    if (_searchCriteria.location.isNotEmpty)
                      _buildChip('Loc: ${_searchCriteria.location}'),
                    const Spacer(),
                    GestureDetector(
                      onTap: _clearSearch,
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFFBA1A1A),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Events List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: _filteredEvents.length + 1, // +1 for footer
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == _filteredEvents.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 32),
                      child: Center(
                        child: Text(
                          '—— 已显示全部 ——',
                          style: TextStyle(
                            fontSize: 10,
                            color: const Color(
                              0xFF2C2C2C,
                            ).withValues(alpha: 0.3),
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    );
                  }

                  final event = _filteredEvents[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CeremonyDetailPage(event: event),
                        ),
                      );
                    },
                    child: _EventCard(event: event),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, color: Color(0xFF8B5A2B)),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Event event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFCF8), // zen-paper
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Icon
          Positioned(
            right: -24,
            bottom: -24,
            child: Icon(
              event.icon,
              size: 120,
              color: const Color(0xFF8B5A2B).withValues(alpha: 0.05),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F7F3),
                  border: Border.all(
                    color: const Color(0xFFBA1A1A).withValues(alpha: 0.1),
                  ), // zen-accent
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  event.status,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFBA1A1A),
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Text(
                event.title,
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                event.temple,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9E9E9E), // zen-subtle
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    event.time,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8B5A2B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.chevron_right,
              color: Color(0xFF9E9E9E),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

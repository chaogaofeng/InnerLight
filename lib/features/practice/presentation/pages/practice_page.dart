import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock_data.dart';
import '../../domain/entities/practice_tool.dart';
import 'practice_tools_page.dart';
import 'bead_practice_page.dart';
import 'wooden_fish_practice_page.dart';
import 'bell_practice_page.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  // Default enabled tools
  List<String> _enabledToolIds = ['beads', 'bell', 'fish'];

  Future<void> _openToolsManager() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PracticeToolsPage(enabledToolIds: _enabledToolIds),
      ),
    );

    if (result != null && result is List<String>) {
      setState(() {
        _enabledToolIds = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Handled by MainScreen
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeroSection(),
                    _buildToolsSection(),
                    _buildContemplationCard(),
                    _buildHistorySection(),
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        '更多修行内容，将在合适的时候展开',
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xFF2C2C2C).withValues(alpha: 0.4),
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Text(
          '今日修行',
          style: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C2C2C),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    final now = DateTime.now();
    final day = now.day;
    final month = now.month;
    // Simple placeholder weekday, real app would use DateFormat('EEEE', 'zh_CN')
    const weekday = '星期三';

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$month月$day日 · $weekday',
                style: GoogleFonts.notoSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '今日修行',
                style: GoogleFonts.maShanZheng(
                  fontSize: 28,
                  height: 1.2,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '今日尚未开始修行',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF2C2C2C).withValues(alpha: 0.6),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          // Stamp
          Transform.rotate(
            angle: 0.2,
            child: Opacity(
              opacity: 0.2,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF8B5A2B), width: 2),
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
                    '精进',
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
    );
  }

  Widget _buildToolsSection() {
    final enabledTools = allPracticeTools
        .where((t) => _enabledToolIds.contains(t.id))
        .toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 12),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color(0xFF8B5A2B), width: 3),
                ),
              ),
              child: Text(
                '修行工具',
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
            ),
            IconButton(
              onPressed: _openToolsManager,
              icon: const Icon(Icons.add, color: Color(0xFF8B5A2B)),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                padding: const EdgeInsets.all(8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (enabledTools.isEmpty)
          GestureDetector(
            onTap: _openToolsManager,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF8B5A2B).withValues(alpha: 0.2),
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              // Dashed border is complex in Flutter natively without Path, using solid light border for now or custom painter
              // Leaving as solid light border for simplicity
              child: Center(
                child: Text(
                  '暂无启用工具，点击添加',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF2C2C2C).withValues(alpha: 0.4),
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          )
        else
          ...enabledTools.map((tool) => _buildToolCard(tool)),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildToolCard(PracticeTool tool) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color(0xFFF9F7F3).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            switch (tool.id) {
              case 'beads':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BeadPracticePage()),
                );
                break;
              case 'fish':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WoodenFishPracticePage(),
                  ),
                );
                break;
              case 'bell':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BellPracticePage()),
                );
                break;
              default:
                // Show toast or placeholder
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('该功能即将上线')));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDFCF8), // Zen Bg
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                    ),
                  ),
                  child: Icon(
                    tool.icon,
                    size: 24,
                    color: const Color(0xFF8B5A2B),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tool.title,
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tool.desc,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF2C2C2C).withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContemplationCard() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 12),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color(0xFF8B5A2B), width: 3),
                ),
              ),
              child: Text(
                '今日观照',
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F7F3).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            '今天，是否觉察到自己的情绪起伏？',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerif(
              fontSize: 16,
              color: const Color(0xFF2C2C2C).withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 12),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color(0xFF8B5A2B), width: 3),
                ),
              ),
              child: Text(
                '最近修行',
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chevron_right, color: Color(0xFF2C2C2C)),
              color: const Color(0xFF2C2C2C).withValues(alpha: 0.4),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildHistoryItem(
          Icons.menu_book,
          '金刚经诵读',
          '昨日',
          '2023-07-08',
          '诵读 1 遍',
        ),
        _buildHistoryItem(
          Icons.local_fire_department_outlined,
          '慈心禅',
          '前日',
          '2023-07-04',
          '静坐 30 分钟',
        ),
      ],
    );
  }

  Widget _buildHistoryItem(
    IconData icon,
    String title,
    String dateLabel,
    String date,
    String action,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F7F3).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF8B5A2B).withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFDFCF8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 18,
              color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5A2B).withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        dateLabel,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF8B5A2B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 10,
                        color: const Color(0xFF2C2C2C).withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 2,
                      height: 2,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      action,
                      style: TextStyle(
                        fontSize: 10,
                        color: const Color(0xFF2C2C2C).withValues(alpha: 0.4),
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

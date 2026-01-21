// import 'dart:async'; // Unused
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Handled by MainScreen or Background wrapper
      body: Stack(
        children: [
          // Background Noise/Texture (Replicated from UI.tsx)
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              // In a real app, use an Image.asset for the noise texture or a CustomPainter
              child: Container(color: const Color(0xFFF3F0E9)),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const GreetingHeader(),
                        const AlmanacWidget(),
                        const DailyIncenseWidget(),
                        _buildSectionHeader('每日修行', Icons.filter_vintage, '全部'),
                        const QuickActionGrid(),
                        const SizedBox(height: 32),
                        const ContinueReadingCard(),
                        const SizedBox(height: 24),
                        const FeaturedEventCard(),
                        const SizedBox(height: 32),
                        _buildSectionHeader(
                          '修行指引',
                          Icons.import_contacts,
                          null,
                        ),
                        const DiscoverySection(),
                        const SizedBox(height: 40),
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 1,
                                height: 32,
                                color: const Color(0xFF8B5A2B),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '万法唯心造',
                                style: GoogleFonts.notoSerif(
                                  fontSize: 12,
                                  letterSpacing: 4,
                                  color: const Color(
                                    0xFF2C2C2C,
                                  ).withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Fake Back button for visual spacing or Menu
          const SizedBox(width: 40),
          Text(
            '禅 · 生活',
            style: GoogleFonts.notoSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2C2C2C).withValues(alpha: 0.9),
              letterSpacing: 2,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            color: const Color(0xFF2C2C2C).withValues(alpha: 0.4),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, String? action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 4, right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF8B5A2B)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),
          if (action != null)
            Text(
              action,
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }
}

// --- Greeting Header ---
class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 5) return '夜深，静心';
    if (hour < 9) return '晨安，吉祥';
    if (hour < 12) return '日安，精进';
    if (hour < 18) return '午后，自在';
    return '晚安，安住';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: GoogleFonts.notoSerif(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C2C2C),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '愿您今日六时吉祥，法喜充满。',
                style: GoogleFonts.notoSans(
                  fontSize: 10,
                  color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  Icons.share,
                  size: 14,
                  color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '分享',
                style: TextStyle(
                  fontSize: 9,
                  color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Almanac Widget ---
class AlmanacWidget extends StatelessWidget {
  const AlmanacWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFCF8),
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
      child: Row(
        children: [
          // Left Date
          Container(
            padding: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Column(
              children: [
                // Vertical text simulation
                Text(
                  '农历二月十九',
                  style: GoogleFonts.notoSans(
                    fontSize: 10,
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateTime.now().day}',
                  style: GoogleFonts.notoSerif(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
                Text(
                  '星期${_getWeekday()}',
                  style: GoogleFonts.notoSans(
                    fontSize: 10,
                    color: const Color(0xFF8B5A2B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '宜',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF8B5A2B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '静坐 · 诵经 · 施食',
                      style: TextStyle(
                        fontSize: 10,
                        color: const Color(0xFF2C2C2C).withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '“心无挂碍，无挂碍故，无有恐怖。”',
                  style: GoogleFonts.notoSerif(
                    fontSize: 14,
                    color: const Color(0xFF2C2C2C).withValues(alpha: 0.9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '—— 心经',
                      style: TextStyle(
                        fontSize: 10,
                        color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '日签',
                        style: TextStyle(
                          fontSize: 9,
                          color: const Color(0xFF8B5A2B).withValues(alpha: 0.5),
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

  String _getWeekday() {
    // Basic placeholder, in real app use intl or custom logic
    return '三';
  }
}

// --- Daily Incense Widget ---
class DailyIncenseWidget extends StatefulWidget {
  const DailyIncenseWidget({super.key});

  @override
  State<DailyIncenseWidget> createState() => _DailyIncenseWidgetState();
}

class _DailyIncenseWidgetState extends State<DailyIncenseWidget>
    with TickerProviderStateMixin {
  bool _isLit = false;
  late AnimationController _smokeController;
  late AnimationController _glowController;
  late AnimationController _floatController;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _smokeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Check local storage simulation (optional, keeping simple for now)
  }

  @override
  void dispose() {
    _smokeController.dispose();
    _glowController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _lightIncense() {
    if (_isLit) return;
    setState(() {
      _isLit = true;
      _showSuccess = true;
    });
    _smokeController.repeat();
    _floatController.forward().then((_) {
      // Hide success message after animation
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) setState(() => _showSuccess = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _lightIncense,
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Card Background
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A3B32), Color(0xFF3E3025)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),

            // Texture
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: Container(color: Colors.white), // Simplified texture
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text Area
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _isLit ? '今日已供香' : '日课供香',
                            style: GoogleFonts.notoSerif(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFF2EFE9),
                              letterSpacing: 2,
                            ),
                          ),
                          if (_isLit) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFF2EFE9,
                                ).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '功德 +1',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFFF2EFE9),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isLit ? '心香一瓣，供养十方。' : '点亮心灯，开启今日修行。',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFFF2EFE9).withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),

                  // Incense Burner Visuals
                  SizedBox(
                    width: 60,
                    height: 80,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        // Burner Body
                        Container(
                          width: 32,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFFA6937C),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        // Incense Stick
                        Positioned(
                          bottom: 20,
                          child: Container(
                            width: 2,
                            height: 24,
                            color: const Color(0xFFD4C5B0),
                          ),
                        ),

                        // Lit Interactions
                        if (_isLit) ...[
                          // Burning Tip
                          Positioned(
                            bottom: 44, // 20 (bottom) + 24 (stick height)
                            child: AnimatedBuilder(
                              animation: _glowController,
                              builder: (ctx, child) {
                                return Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(
                                      alpha: 0.8 + 0.2 * _glowController.value,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withValues(
                                          alpha: 0.6,
                                        ),
                                        blurRadius:
                                            4 + 4 * _glowController.value,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          // Smoke Animation
                          Positioned(
                            bottom: 48,
                            child: AnimatedBuilder(
                              animation: _smokeController,
                              builder: (context, child) {
                                return CustomPaint(
                                  painter: SmokePainter(_smokeController.value),
                                  size: const Size(20, 40),
                                );
                              },
                            ),
                          ),
                        ] else ...[
                          // "Click me" indicator
                          Positioned(
                            top: 0,
                            right: 0,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 1.0, end: 1.2),
                              duration: const Duration(milliseconds: 1000),
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                );
                              },
                              onEnd:
                                  () {}, // Could loop explicitly if needed, TweenAnimationBuilder doesn't loop easily without state, keeping simple
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Floating Success Text
            if (_showSuccess)
              Positioned(
                top: 0,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -20 * _floatController.value),
                      child: Opacity(
                        opacity: 1 - _floatController.value,
                        child: Text(
                          '愿吉祥如意',
                          style: GoogleFonts.notoSerif(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF2EFE9),
                            shadows: [
                              const Shadow(
                                blurRadius: 4,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Simple Smoke Painter
class SmokePainter extends CustomPainter {
  final double animationValue;
  SmokePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // Simulate rising smoke with sine waves
    // Keeping it simple: draw a few circles moving up
    // In a real app, use a particle system

    // Circle 1
    double y1 = size.height - (size.height * (animationValue % 1.0));
    canvas.drawCircle(
      Offset(size.width / 2 + 5 * (y1 / size.height), y1),
      2 + (1 - y1 / size.height) * 4,
      paint,
    );

    // Circle 2 (Offset)
    double progress2 = (animationValue + 0.5) % 1.0;
    double y2 = size.height - (size.height * progress2);
    canvas.drawCircle(
      Offset(size.width / 2 - 5 * (y2 / size.height), y2),
      2 + (1 - y2 / size.height) * 4,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant SmokePainter oldDelegate) => true;
}

// --- Quick Action Grid ---
class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem('木鱼', Icons.spa), // Replaced Wind with similar
        _buildActionItem('念珠', Icons.circle_outlined),
        _buildActionItem('静钟', Icons.notifications_none),
        _buildActionItem('供灯', Icons.local_fire_department_outlined),
      ],
    );
  }

  Widget _buildActionItem(String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.01),
                blurRadius: 4,
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFF8B5A2B)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF8B5A2B)),
        ),
      ],
    );
  }
}

// --- Continue Reading Card ---
class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F7F3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.menu_book,
                    size: 16,
                    color: Color(0xFF8B5A2B),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '今日阅藏',
                    style: GoogleFonts.notoSans(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: Color(0xFF8B5A2B),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFC5A065),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  '心经',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ), // vertical text hard in flutter basic
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '般若波罗蜜多心经',
                      style: GoogleFonts.notoSerif(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '观自在菩萨，行深般若波罗蜜多时...',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.45,
                      backgroundColor: const Color(
                        0xFF8B5A2B,
                      ).withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF8B5A2B),
                      ),
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '已读至 第一品',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          '45%',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Featured Event Card ---
class FeaturedEventCard extends StatelessWidget {
  const FeaturedEventCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA6937C), Color(0xFF8C857B)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '近期法会',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: const Icon(
              Icons.arrow_outward,
              color: Colors.white70,
              size: 18,
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '万佛名忏大法会',
                  style: GoogleFonts.notoSerif(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: Colors.white70),
                    SizedBox(width: 4),
                    Text(
                      '三月十五 · 09:00',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '|  普陀山',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
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

// --- Discovery Section ---
class DiscoverySection extends StatelessWidget {
  const DiscoverySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _buildCard('初学者指南', '如何开始第一次禅修？', const Color(0xFFE8E4D9)),
          const SizedBox(width: 12),
          _buildCard('木鱼的功德', '敲击声中的清净义理', const Color(0xFFE0E7E9)),
          const SizedBox(width: 12),
          _buildCard('本周共修', '千人在线金刚经念诵', const Color(0xFFE9E0E0)),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, Color color) {
    return Container(
      width: 160,
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white60,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.question_mark,
              size: 12,
              color: Color(0xFF2C2C2C),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.black.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

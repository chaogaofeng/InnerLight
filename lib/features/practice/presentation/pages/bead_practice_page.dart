import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/audio_manager.dart';

class BeadPracticePage extends StatefulWidget {
  const BeadPracticePage({super.key});

  @override
  State<BeadPracticePage> createState() => _BeadPracticePageState();
}

class _BeadPracticePageState extends State<BeadPracticePage>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  bool _soundEnabled = true;
  bool _isAnimating = false;
  late AnimationController _controller;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Simulate loading from local storage
    _count = 0;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Slide down and back up
    _slideAnimation = Tween<double>(
      begin: 0,
      end: 50,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _isAnimating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBeadClick() {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _count++;
    });

    _controller.forward();
    HapticFeedback.lightImpact();

    // Play sound
    if (_soundEnabled) {
      AudioManager().play('bead');
    }
  }

  void _handleReset() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('重新开始'),
        content: const Text('确认重置今日计数？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _count = 0);
              Navigator.pop(ctx);
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF8), // Zen Bg
      body: Stack(
        children: [
          // Background Elements
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Center(
                child: Container(
                  width: 2,
                  color: const Color(0xFF8B5A2B).withValues(alpha: 0.2),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF2C2C2C),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '虚拟念珠',
                            style: GoogleFonts.notoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2C2C2C),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Balance back button
                    ],
                  ),
                ),

                // Controls Row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _handleReset,
                        icon: const Icon(Icons.refresh),
                        color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                      ),
                      Text(
                        '今日功德',
                        style: GoogleFonts.notoSerif(
                          fontSize: 12,
                          letterSpacing: 2,
                          color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            setState(() => _soundEnabled = !_soundEnabled),
                        icon: Icon(
                          _soundEnabled ? Icons.volume_up : Icons.volume_off,
                        ),
                        color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                ),

                // Counter
                Column(
                  children: [
                    Text(
                      '$_count',
                      style: GoogleFonts.notoSerif(
                        fontSize: 64,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                    Text(
                      '累计持诵',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF2C2C2C).withValues(alpha: 0.4),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),

                // Main Bead Area
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // String
                        Container(
                          width: 4,
                          height: 400, // Long enough string
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                                const Color(0xFF8B5A2B).withValues(alpha: 0.4),
                                const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        // The Bead
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: GestureDetector(
                                onTap: _handleBeadClick,
                                child: Container(
                                  width: 192,
                                  height: 192,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF8B7355),
                                        Color(0xFF5D4F43),
                                        Color(0xFF2C241B),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF2C241B,
                                        ).withValues(alpha: 0.4),
                                        offset: const Offset(0, 20),
                                        blurRadius: 40,
                                        spreadRadius: -10,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Highlight Ring
                                      Positioned(
                                        top: 16,
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.05,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Shine
                                      Positioned(
                                        top: 32,
                                        right: 32,
                                        child: Container(
                                          width: 64,
                                          height: 64,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withValues(
                                              alpha: 0.1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Center Hole
                                      Center(
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1A1510),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.8,
                                                ),
                                                blurRadius: 4,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // +1 Animation
                        if (_isAnimating)
                          Positioned(
                            top: -50,
                            right: -20,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 700),
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: 1 - value,
                                  child: Transform.translate(
                                    offset: Offset(0, -50 * value),
                                    child: Text(
                                      '+1',
                                      style: GoogleFonts.notoSans(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF8B5A2B),
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
                ),

                // Footer
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    children: [
                      Text(
                        '静心凝神',
                        style: GoogleFonts.notoSerif(
                          fontSize: 20,
                          color: const Color(0xFF2C2C2C).withValues(alpha: 0.6),
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '念念清净',
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xFF2C2C2C).withValues(alpha: 0.4),
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

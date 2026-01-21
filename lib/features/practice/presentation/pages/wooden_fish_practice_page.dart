import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/audio_manager.dart';

class WoodenFishPracticePage extends StatefulWidget {
  const WoodenFishPracticePage({super.key});

  @override
  State<WoodenFishPracticePage> createState() => _WoodenFishPracticePageState();
}

class _WoodenFishPracticePageState extends State<WoodenFishPracticePage> {
  int _count = 0;
  bool _soundEnabled = true;
  bool _isAuto = false;
  double _tempo = 60; // BPM
  bool _isAnimating = false;
  Timer? _animTimer;
  Timer? _autoTimer;

  // The simplified version of the wooden fish SVG string from React
  // Note: Flutter SVG parser might be strict, keeping it clean.
  final String _fishSvg = '''
<svg width="280" height="260" viewBox="0 0 300 280" fill="none" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <radialGradient id="woodBody" cx="0" cy="0" r="1" gradientUnits="userSpaceOnUse" gradientTransform="translate(110 80) rotate(90) scale(200)">
      <stop stop-color="#8B5E3C" />
      <stop offset="0.4" stop-color="#5D3A29" />
      <stop offset="1" stop-color="#2A1B12" />
    </radialGradient>
    <linearGradient id="handleGrad" x1="240" y1="120" x2="280" y2="120" gradientUnits="userSpaceOnUse">
       <stop stop-color="#4A2E20"/>
       <stop offset="1" stop-color="#2A1B12"/>
    </linearGradient>
  </defs>
  <ellipse cx="150" cy="240" rx="100" ry="20" fill="black" fill-opacity="0.2" />
  <g transform-origin="center">
    <path d="M220 120 C240 100, 280 100, 270 140 C260 170, 230 160, 220 150" fill="url(#handleGrad)" stroke="#1a0f0a" stroke-width="1"/>
    <path d="M30 140 C30 60, 90 20, 160 30 C 210 38, 240 80, 230 140 C 220 200, 170 240, 100 230 C 50 220, 30 190, 30 140 Z" 
          fill="url(#woodBody)" 
          stroke="#1a0f0a" 
          stroke-width="1"
    />
    <path d="M40 140 Q 90 130, 180 145 Q 185 155, 180 165 Q 90 155, 40 160 Q 30 150, 40 140 Z" 
          fill="#150b06" 
          stroke="#2A1B12" 
          stroke-width="2"
    />
    <path d="M70 70 Q 100 60, 130 80" fill="none" stroke="#3E271B" stroke-width="3" stroke-linecap="round" />
    <path d="M60 100 Q 90 90, 120 110" fill="none" stroke="#3E271B" stroke-width="3" stroke-linecap="round" />
    <path d="M80 200 Q 120 210, 160 190" fill="none" stroke="#3E271B" stroke-width="3" stroke-linecap="round" opacity="0.6" />
  </g>
</svg>
''';

  @override
  void dispose() {
    _autoTimer?.cancel();
    _animTimer?.cancel();
    super.dispose();
  }

  void _triggerKnock({bool auto = false}) {
    setState(() {
      _count++;
      _isAnimating = true;
    });

    if (_soundEnabled) {
      AudioManager().play('fish');
    }

    // Impact feedback only on manual tap to save battery/sanity
    if (!auto) {
      HapticFeedback.mediumImpact();
    }

    // Reset animation flag
    _animTimer?.cancel();
    _animTimer = Timer(const Duration(milliseconds: 80), () {
      if (mounted) setState(() => _isAnimating = false);
    });
  }

  void _toggleAuto() {
    setState(() {
      _isAuto = !_isAuto;
      if (_isAuto) {
        _startAutoTimer();
      } else {
        _autoTimer?.cancel();
      }
    });
  }

  void _startAutoTimer() {
    _autoTimer?.cancel();
    final intervalMs = (60 / _tempo * 1000).round();
    _autoTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      _triggerKnock(auto: true);
    });
  }

  void _updateTempo(double value) {
    setState(() {
      _tempo = value;
    });
    if (_isAuto) {
      _startAutoTimer();
    }
  }

  void _handleReset() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('重置'),
        content: const Text('确认重置今日功德数？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _count = 0;
                _isAuto = false;
                _autoTimer?.cancel();
              });
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
      backgroundColor: const Color(0xFFFDFCF8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF2C2C2C),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    '线上木鱼',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance
                ],
              ),
            ),

            // Stats & Controls
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '今日功德',
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        '$_count',
                        style: GoogleFonts.notoSerif(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2C2C2C),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            setState(() => _soundEnabled = !_soundEnabled),
                        icon: Icon(
                          _soundEnabled ? Icons.volume_up : Icons.volume_off,
                        ),
                        color: const Color(0xFF8B5A2B),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF8B5A2B,
                          ).withValues(alpha: 0.1),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _handleReset,
                        icon: const Icon(Icons.refresh),
                        color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Fish Area
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () => _triggerKnock(auto: false),
                      child: AnimatedScale(
                        scale: _isAnimating ? 0.95 : 1.0,
                        duration: const Duration(milliseconds: 50),
                        child: SvgPicture.string(
                          _fishSvg,
                          width: 280,
                          height: 260,
                        ),
                      ),
                    ),

                    // Text Float
                    if (_isAnimating)
                      Positioned(
                        top: -40,
                        child: TweenAnimationBuilder<double>(
                          key: ValueKey(
                            _count,
                          ), // New key for each count to restart animation
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 700),
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: 1 - value,
                              child: Transform.translate(
                                offset: Offset(0, -30 * value),
                                child: Text(
                                  '功德 +1',
                                  style: GoogleFonts.notoSerif(
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

            // Bottom Control Panel
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F7F3).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
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
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isAuto
                                  ? Colors.green
                                  : const Color(
                                      0xFF8B5A2B,
                                    ).withValues(alpha: 0.3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '自动敲击',
                            style: GoogleFonts.notoSans(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2C2C2C),
                            ),
                          ),
                        ],
                      ),
                      FilledButton.icon(
                        onPressed: _toggleAuto,
                        icon: Icon(
                          _isAuto ? Icons.pause : Icons.play_arrow,
                          size: 16,
                        ),
                        label: Text(_isAuto ? '暂停' : '开始'),
                        style: FilledButton.styleFrom(
                          backgroundColor: _isAuto
                              ? const Color(0xFF8B5A2B)
                              : const Color(0xFFFDFCF8),
                          foregroundColor: _isAuto
                              ? Colors.white
                              : const Color(0xFF8B5A2B),
                          side: _isAuto
                              ? null
                              : const BorderSide(color: Color(0xFF8B5A2B)),
                        ),
                      ),
                    ],
                  ),

                  AnimatedOpacity(
                    opacity: _isAuto ? 1.0 : 0.4,
                    duration: const Duration(milliseconds: 300),
                    child: IgnorePointer(
                      ignoring: !_isAuto,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '舒缓',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${_tempo.round()} BPM',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B5A2B),
                                ),
                              ),
                              const Text(
                                '急促',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color(0xFF8B5A2B),
                              inactiveTrackColor: const Color(
                                0xFF8B5A2B,
                              ).withValues(alpha: 0.2),
                              thumbColor: const Color(0xFF8B5A2B),
                            ),
                            child: Slider(
                              value: _tempo,
                              min: 30,
                              max: 180,
                              divisions: 30,
                              onChanged: _updateTempo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

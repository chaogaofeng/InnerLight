import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/audio_manager.dart';

class BellPracticePage extends StatefulWidget {
  const BellPracticePage({super.key});

  @override
  State<BellPracticePage> createState() => _BellPracticePageState();
}

class _BellPracticePageState extends State<BellPracticePage>
    with TickerProviderStateMixin {
  String _status = 'idle'; // idle, running, finished
  String _mode = 'fixed'; // fixed, free
  int _selectedDuration = 10;
  int _timeLeft = 600;
  int _elapsed = 0;
  Timer? _timer;

  Timer? _rhythmTimer; // For 10s interval bell

  // Animation for Bell Shake
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  final String _bellSvg = '''
<svg width="180" height="200" viewBox="0 0 220 240" fill="none" xmlns="http://www.w3.org/2000/svg">
  <defs>
      <linearGradient id="bronzeGradient" x1="0" y1="0" x2="220" y2="0" gradientUnits="userSpaceOnUse">
          <stop offset="0" stop-color="#5D4F43" />
          <stop offset="0.2" stop-color="#8C7B65" />
          <stop offset="0.5" stop-color="#A6937C" />
          <stop offset="0.8" stop-color="#5D4F43" />
          <stop offset="1" stop-color="#2C2825" />
      </linearGradient>
  </defs>
  <path d="M95 10 C95 5, 125 5, 125 10 L125 30 L95 30 Z" fill="#4A3B32" stroke="#2C2825" stroke-width="2" />
  <path 
      d="M110 30 
        C 150 30, 180 60, 190 150 
        C 192 180, 205 190, 215 200 
        L 5 200 
        C 15 190, 28 180, 30 150 
        C 40 60, 70 30, 110 30 Z" 
      fill="url(#bronzeGradient)"
      stroke="#2C2825"
      stroke-width="1"
  />
  <path d="M35 120 Q 110 130, 185 120" fill="none" stroke="#3E2E24" stroke-width="2" opacity="0.6" />
  <path d="M45 80 Q 110 85, 175 80" fill="none" stroke="#3E2E24" stroke-width="2" opacity="0.6" />
  <path d="M5 200 Q 110 215, 215 200" fill="none" stroke="#2C2825" stroke-width="3" />
  <circle cx="110" cy="200" r="15" fill="#1a1510" />
  <circle cx="110" cy="205" r="8" fill="#5D4F43" />
</svg>
''';

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rhythmTimer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 0.05), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.05, end: -0.05), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -0.05, end: 0), weight: 1),
    ]).animate(_shakeController);

    _shakeController.forward(from: 0);
  }

  void _strikeBell() {
    _triggerShake();
    HapticFeedback.heavyImpact();
    AudioManager().play('bell');
  }

  void _start() {
    _strikeBell();
    setState(() {
      _status = 'running';
      _elapsed = 0;
      if (_mode == 'fixed') {
        _timeLeft = _selectedDuration * 60;
      }
    });

    // Countdown / Elapsed Timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_mode == 'free') {
          _elapsed++;
        } else {
          if (_timeLeft <= 0) {
            _finish();
          } else {
            _timeLeft--;
          }
        }
      });
    });

    // Rhythm Bell (Every 10s)
    _rhythmTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // Only play if not just started (avoid double strike)
      if (_mode == 'free' && _elapsed > 1) {
        _strikeBell();
      } else if (_mode == 'fixed' &&
          _timeLeft > 1 &&
          _timeLeft < _selectedDuration * 60) {
        _strikeBell();
      }
    });
  }

  void _stop() {
    _timer?.cancel();
    _rhythmTimer?.cancel();
    // Play soft stop sound (same bell for now)
    _strikeBell();

    setState(() {
      _status = 'idle';
      // Reset times
      if (_mode == 'fixed') {
        _timeLeft = _selectedDuration * 60;
      } else {
        _elapsed = 0;
      }
    });
  }

  void _finish() {
    _timer?.cancel();
    _rhythmTimer?.cancel();
    _strikeBell();
    setState(() => _status = 'finished');
  }

  void _selectDuration(dynamic min) {
    setState(() {
      if (min == 'free') {
        _mode = 'free';
        _timeLeft = 0;
      } else {
        _mode = 'fixed';
        _selectedDuration = min;
        _timeLeft = min * 60;
      }
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds / 60).floor().toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
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
                    '静心钟',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hint
                  AnimatedOpacity(
                    opacity: _status == 'running' ? 0 : 1,
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      '闻钟声，烦恼轻',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Bell Visual
                  GestureDetector(
                    onTap: _strikeBell,
                    child: RotationTransition(
                      turns: _shakeAnimation,
                      child: SvgPicture.string(
                        _bellSvg,
                        width: 180,
                        height: 200,
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Timer / Status
                  SizedBox(
                    height: 120,
                    child: Center(
                      child: _status == 'running'
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _mode == 'fixed'
                                      ? _formatTime(_timeLeft)
                                      : _formatTime(_elapsed),
                                  style: GoogleFonts.notoSerif(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w300,
                                    color: const Color(0xFF2C2C2C),
                                    letterSpacing: 4,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.air,
                                      size: 12,
                                      color: Color(0xFF8B5A2B),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '安住当下',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: const Color(
                                          0xFF2C2C2C,
                                        ).withValues(alpha: 0.4),
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : _status == 'finished'
                          ? Column(
                              children: [
                                Text(
                                  '功德圆满',
                                  style: GoogleFonts.notoSerif(
                                    fontSize: 24,
                                    letterSpacing: 4,
                                    color: const Color(0xFF2C2C2C),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _status = 'idle'),
                                  child: const Text(
                                    '返回',
                                    style: TextStyle(color: Color(0xFF8B5A2B)),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              _mode == 'fixed'
                                  ? '定时 $_selectedDuration 分钟'
                                  : '自由静坐',
                              style: GoogleFonts.notoSerif(
                                fontSize: 16,
                                letterSpacing: 2,
                                color: const Color(
                                  0xFF2C2C2C,
                                ).withValues(alpha: 0.8),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Controls
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Column(
                children: [
                  // Duration Selector
                  AnimatedOpacity(
                    opacity: _status == 'idle' ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F7F3),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [5, 10, 20, 'free'].map((opt) {
                          final isSelected = opt == 'free'
                              ? _mode == 'free'
                              : _selectedDuration == opt && _mode == 'fixed';
                          return GestureDetector(
                            onTap: () => _selectDuration(opt),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Text(
                                opt == 'free' ? '自由' : '$opt',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? const Color(0xFF8B5A2B)
                                      : const Color(
                                          0xFF2C2C2C,
                                        ).withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Start Button
                  if (_status != 'finished')
                    GestureDetector(
                      onTap: _status == 'running' ? _stop : _start,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _status == 'running'
                              ? Colors.transparent
                              : const Color(0xFF8B5A2B),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: _status == 'running'
                                ? const Color(0xFF8B5A2B).withValues(alpha: 0.2)
                                : Colors.transparent,
                          ),
                          boxShadow: _status == 'running'
                              ? null
                              : [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF8B5A2B,
                                    ).withValues(alpha: 0.3),
                                    offset: const Offset(0, 4),
                                    blurRadius: 12,
                                  ),
                                ],
                        ),
                        child: Text(
                          _status == 'running' ? '结束' : '开始静心',
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 4,
                            color: _status == 'running'
                                ? const Color(0xFF8B5A2B)
                                : Colors.white,
                          ),
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

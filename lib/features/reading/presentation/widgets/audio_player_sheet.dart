import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AudioPlayerSheet extends StatefulWidget {
  final String audioUrl;
  final String title;
  final String author;

  const AudioPlayerSheet({
    super.key,
    required this.audioUrl,
    required this.title,
    required this.author,
  });

  @override
  State<AudioPlayerSheet> createState() => _AudioPlayerSheetState();
}

class _AudioPlayerSheetState extends State<AudioPlayerSheet> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    // Listen to state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    // Listen to position changes
    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    // Initial load
    try {
      await _audioPlayer.setSourceUrl(widget.audioUrl);
    } catch (e) {
      debugPrint('Error loading audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.zenPaper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.zenSubtle.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Title & Author
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.zenInk,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.author,
            style: const TextStyle(fontSize: 14, color: AppColors.zenSubtle),
          ),
          const SizedBox(height: 32),

          // Progress Slider
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.zenBrown,
                  inactiveTrackColor: AppColors.zenBrown.withValues(alpha: 0.2),
                  thumbColor: AppColors.zenBrown,
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 14,
                  ),
                ),
                child: Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.toDouble().clamp(
                    0,
                    _duration.inSeconds.toDouble(),
                  ),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await _audioPlayer.seek(position);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.zenSubtle,
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.zenSubtle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10_rounded),
                iconSize: 32,
                color: AppColors.zenBrown,
                onPressed: () {
                  final newPos = _position - const Duration(seconds: 10);
                  _audioPlayer.seek(
                    newPos < Duration.zero ? Duration.zero : newPos,
                  );
                },
              ),
              const SizedBox(width: 32),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.zenBrown,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.zenBrown.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                  iconSize: 36,
                  color: Colors.white,
                  onPressed: () {
                    if (_isPlaying) {
                      _audioPlayer.pause();
                    } else {
                      _audioPlayer.resume();
                    }
                  },
                ),
              ),
              const SizedBox(width: 32),
              IconButton(
                icon: const Icon(Icons.forward_10_rounded),
                iconSize: 32,
                color: AppColors.zenBrown,
                onPressed: () {
                  final newPos = _position + const Duration(seconds: 10);
                  _audioPlayer.seek(newPos > _duration ? _duration : newPos);
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

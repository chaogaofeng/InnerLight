import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/book.dart';
import '../widgets/content_drawer.dart';
import '../widgets/audio_player_sheet.dart';
import '../widgets/video_player_modal.dart';

// --- Constants & Mock Data ---

class ReaderTheme {
  final String id;
  final Color bg;
  final Color headerBg;
  final Color footerBg;
  final Color text;
  final Color accent;
  final Color bubbleUser;
  final Color bubbleAI;
  final String label;

  const ReaderTheme({
    required this.id,
    required this.bg,
    required this.headerBg,
    required this.footerBg,
    required this.text,
    required this.accent,
    required this.bubbleUser,
    required this.bubbleAI,
    required this.label,
  });
}

final Map<String, ReaderTheme> readerThemes = {
  'light': ReaderTheme(
    id: 'light',
    bg: const Color(0xFFF9F7F3),
    headerBg: const Color(0xFFF9F7F3).withValues(alpha: 0.95),
    footerBg: const Color(0xFFF9F7F3).withValues(alpha: 0.95),
    text: const Color(0xFF383838),
    accent: const Color(0xFF8C7B65),
    bubbleUser: const Color(0xFF8C7B65),
    bubbleAI: Colors.white,
    label: '素白',
  ),
  'sepia': ReaderTheme(
    id: 'sepia',
    bg: const Color(0xFFEFEDE7),
    headerBg: const Color(0xFFEFEDE7).withValues(alpha: 0.95),
    footerBg: const Color(0xFFEFEDE7).withValues(alpha: 0.95),
    text: const Color(0xFF5D4F43),
    accent: const Color(0xFF8C7B65),
    bubbleUser: const Color(0xFF8C7B65),
    bubbleAI: const Color(0xFFFDFCF8),
    label: '羊皮',
  ),
  'green': ReaderTheme(
    id: 'green',
    bg: const Color(0xFFE6EFE9),
    headerBg: const Color(0xFFE6EFE9).withValues(alpha: 0.95),
    footerBg: const Color(0xFFE6EFE9).withValues(alpha: 0.95),
    text: const Color(0xFF2E3B33),
    accent: const Color(0xFF5C7A68),
    bubbleUser: const Color(0xFF5C7A68),
    bubbleAI: Colors.white,
    label: '护眼',
  ),
  'dark': ReaderTheme(
    id: 'dark',
    bg: const Color(0xFF1C1C1E),
    headerBg: const Color(0xFF1C1C1E).withValues(alpha: 0.95),
    footerBg: const Color(0xFF1C1C1E).withValues(alpha: 0.95),
    text: const Color(0xFFA1A1AA),
    accent: const Color(0xFF71717A),
    bubbleUser: const Color(0xFF52525B),
    bubbleAI: const Color(0xFF27272A),
    label: '夜间',
  ),
};

const mockAnnotations = [
  {
    'id': 1,
    'master': '僧肇法师',
    'title': '注维摩诘经',
    'content': '大乘部，该经也是般若经类的精要之作，阐述了五蕴皆空、色空不二的般若智慧。一切诸法，皆由因缘和合而生，无有自性，故曰空。',
  },
  {
    'id': 2,
    'master': '憨山大师',
    'title': '心经直指',
    'content': '般若者，乃诸佛之母，众生之慧命也。照见五蕴皆空，则度一切苦厄。五蕴身心，原本是妄，由于妄执，故受轮回。若能照破，则当下解脱。',
  },
];

const mockChatMessages = [
  {'id': 1, 'role': 'ai', 'text': '施主好，我是您的AI书童“慧能”。阅读中若有不明之处，或想探讨经文义理，皆可问我。'},
];

class BookReaderPage extends StatefulWidget {
  final Book book;

  const BookReaderPage({super.key, required this.book});

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  // UI State
  bool _showControls = false;

  // Settings State
  double _fontSize = 20.0;
  String _themeKey = 'sepia';
  double _brightness = 0.5;

  // Scroll State
  double _scrollProgress = 0.0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initBrightness();
    _scrollController.addListener(_onScroll);
    // Mimic initial progress from React
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _scrollProgress = 17.0;
        });
      }
    });
  }

  Future<void> _initBrightness() async {
    try {
      final currentBrightness = await ScreenBrightness().application;
      setState(() {
        _brightness = currentBrightness;
      });
    } catch (e) {
      debugPrint('Failed to get brightness: $e');
      // Default to 0.5 if we can't get current brightness
      setState(() {
        _brightness = 0.5;
      });
    }
  }

  Future<void> _setBrightness(double value) async {
    // Optimistically update UI state first
    setState(() {
      _brightness = value;
    });

    try {
      await ScreenBrightness().setApplicationScreenBrightness(value);
    } catch (e) {
      // Just log failure, don't revert UI as we have an overlay
      debugPrint('Failed to set brightness: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll > 0) {
      setState(() {
        _scrollProgress = (currentScroll / maxScroll) * 100;
      });
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _onAction(String actionId) {
    switch (actionId) {
      case 'ai':
        _showAIDrawer();
        break;
      case 'audio':
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => AudioPlayerSheet(
            audioUrl:
                widget.book.audioUrl ??
                'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', // Fallback for demo
            title: widget.book.title,
            author: widget.book.author,
          ),
        );
        break;
      case 'video':
        showDialog(
          context: context,
          builder: (context) => VideoPlayerModal(
            videoUrl:
                widget.book.videoUrl ??
                'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', // Fallback for demo
          ),
        );
        break;
      case 'toc':
        _showTOCDrawer();
        break;
      case 'settings':
        _showSettingsDrawer();
        break;
    }
  }

  ReaderTheme get _currentTheme => readerThemes[_themeKey]!;

  @override
  Widget build(BuildContext context) {
    final theme = _currentTheme;
    final paragraphs = widget.book.chapters[0].contentOriginal
        .split('\n')
        .where((p) => p.trim().isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: theme.bg,
      body: Stack(
        children: [
          // Texture Overlay (placeholder for now)

          // Main Reading Area
          GestureDetector(
            onTap: _toggleControls,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    '正文',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSerif',
                      letterSpacing: 4,
                      color: theme.accent.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  ...paragraphs.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final p = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: p.substring(0, p.length ~/ 2)),
                            if (idx == 0)
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: _buildInlineAnnotation(
                                  5,
                                  _showAnnotationsDrawer,
                                ),
                              ),
                            if (idx == 2)
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: _buildInlineAnnotation(
                                  7,
                                  _showAnnotationsDrawer,
                                ),
                              ),
                            TextSpan(text: p.substring(p.length ~/ 2)),
                          ],
                        ),
                        style: TextStyle(
                          fontSize: _fontSize,
                          height: 2.2,
                          fontFamily: 'NotoSerif',
                          color: theme.text,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    );
                  }),
                  const SizedBox(height: 64),
                  Opacity(
                    opacity: 0.3,
                    child: Text(
                      'End',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'NotoSerif', // Mock calligraphy
                        color: theme.text,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Brightness Overlay
          IgnorePointer(
            ignoring: true,
            child: Container(
              color: Colors.black.withValues(
                alpha: (1.0 - _brightness).clamp(
                  0.0,
                  0.7,
                ), // Cap darkness at 70%
              ),
            ),
          ),

          // Header
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: _showControls ? 0 : -80,
            left: 0,
            right: 0,
            child: _buildHeader(theme),
          ),

          // Minimal Status Bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: !_showControls ? 0 : -60,
            left: 0,
            right: 0,
            child: _buildMinimalStatusBar(theme),
          ),

          // Full Control Panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _showControls ? 0 : -300,
            left: 0,
            right: 0,
            child: _buildFullControlPanel(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineAnnotation(int count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFCF8),
          border: Border.all(
            color: const Color(0xFF8C7B65).withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8C7B65).withValues(alpha: 0.1),
              offset: const Offset(1, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF8C7B65),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ReaderTheme theme) {
    return Container(
      height: 80,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: theme.headerBg,
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 20, color: theme.text),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              Text(
                '第 1 章',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1,
                  color: theme.text.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.book.chapters[0].title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.text,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.menu, color: theme.text),
            onPressed: _toggleControls,
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalStatusBar(ReaderTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '12:00', // Mock time
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1,
              color: theme.text.withValues(alpha: 0.6),
            ),
          ),
          Row(
            children: [
              Text(
                '${_scrollProgress.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: theme.text.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.battery_std,
                size: 14,
                color: theme.text.withValues(alpha: 0.6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFullControlPanel(ReaderTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.footerBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -5),
            blurRadius: 20,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.wb_sunny_outlined,
                            size: 14,
                            color: theme.text.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: theme.accent,
                                inactiveTrackColor: Colors.black.withValues(
                                  alpha: 0.1,
                                ),
                                thumbColor: theme.accent,
                                trackHeight: 4.0,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6.0,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 14.0,
                                ),
                              ),
                              child: Slider(
                                value: _brightness,
                                onChanged: _setBrightness,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.wb_sunny,
                            size: 18,
                            color: theme.text.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: _showSettingsDrawer,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.text_fields, size: 14, color: theme.text),
                          const SizedBox(width: 8),
                          Text(
                            '字号',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.black.withValues(alpha: 0.05)),

            // Main Functions
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(Icons.list, '目录', 'toc', theme),
                  _buildActionButton(Icons.headphones, '听书', 'audio', theme),
                  _buildActionButton(
                    Icons.ondemand_video,
                    '视频',
                    'video',
                    theme,
                  ),
                  _buildActionButton(Icons.smart_toy, 'AI书童', 'ai', theme),
                  _buildActionButton(Icons.settings, '设置', 'settings', theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    String id,
    ReaderTheme theme,
  ) {
    return GestureDetector(
      onTap: () => _onAction(id),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: theme.text.withValues(alpha: 0.8)),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1,
              color: theme.text.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  // --- Drawer Methods ---

  void _showTOCDrawer() {
    ContentDrawer.show(
      context: context,
      title: '目录',
      icon: Icons.list,
      child: Column(
        children: widget.book.chapters
            .map(
              (chapter) => ListTile(
                title: Text(
                  chapter.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _showControls = false;
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showAnnotationsDrawer() {
    ContentDrawer.show(
      context: context,
      title: '注解',
      icon: Icons.message,
      child: Column(
        children: mockAnnotations
            .map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: AppColors.zenBrown.withValues(alpha: 0.1),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['master'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.zenBrown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['content'] as String,
                      style: const TextStyle(height: 1.6),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void _showSettingsDrawer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return ContentDrawer(
              title: '阅读设置',
              icon: Icons.settings,
              heightFactor: 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Font Size
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '字号',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.zenSubtle,
                        ),
                      ),
                      Text(
                        '${_fontSize.toInt()}px',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.zenSubtle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.zenPaper.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Text('A', style: TextStyle(fontSize: 12)),
                        Expanded(
                          child: Slider(
                            value: _fontSize,
                            min: 16,
                            max: 32,
                            divisions: 8,
                            activeColor: AppColors.zenBrown,
                            inactiveColor: AppColors.zenBrown.withValues(
                              alpha: 0.2,
                            ),
                            onChanged: (val) {
                              setModalState(
                                () => _fontSize = val,
                              ); // Update local modal/slider
                              setState(
                                () => _fontSize = val,
                              ); // Update parent page
                            },
                          ),
                        ),
                        const Text('A', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Themes
                  const Text(
                    '背景',
                    style: TextStyle(fontSize: 12, color: AppColors.zenSubtle),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: readerThemes.entries.map((entry) {
                      final t = entry.value;
                      final isSelected = _themeKey == entry.key;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() => _themeKey = entry.key);
                          setState(() => _themeKey = entry.key);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: t.bg,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.zenBrown
                                      : Colors.black.withValues(alpha: 0.05),
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.zenBrown.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              t.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.zenBrown
                                    : AppColors.zenSubtle,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.zenBrown.withValues(
                          alpha: 0.1,
                        ),
                        foregroundColor: AppColors.zenBrown,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '退出阅读',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAIDrawer() {
    // AI Drawer with internal state
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AIChatDrawerContent(),
    );
  }
}

class AIChatDrawerContent extends StatefulWidget {
  const AIChatDrawerContent({super.key});

  @override
  State<AIChatDrawerContent> createState() => _AIChatDrawerContentState();
}

class _AIChatDrawerContentState extends State<AIChatDrawerContent> {
  List<Map<String, dynamic>> messages = List.from(mockChatMessages);
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    if (_controller.text.isEmpty) return;

    setState(() {
      messages.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'role': 'user',
        'text': _controller.text,
      });
      _controller.clear();
    });

    // Mock Reply
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          messages.add({
            'id': DateTime.now().millisecondsSinceEpoch,
            'role': 'ai',
            'text': '师兄所言甚是。经云：凡所有相，皆是虚妄。若见诸相非相，即见如来。',
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentDrawer(
      title: 'AI 书童 - 慧能',
      icon: Icons.smart_toy,
      heightFactor: 0.85,
      scrollable: false,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: messages
                  .map(
                    (msg) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: msg['role'] == 'user'
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (msg['role'] == 'ai')
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.zenPaper,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.zenBrown.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              child: const Icon(
                                Icons.smart_toy,
                                size: 16,
                                color: AppColors.zenBrown,
                              ),
                            ),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: msg['role'] == 'user'
                                    ? AppColors.zenBrown
                                    : AppColors.zenPaper.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                msg['text'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: msg['role'] == 'user'
                                      ? Colors.white
                                      : AppColors.zenInk,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Input Area
          Container(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.zenPaper.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: AppColors.zenBrown.withValues(alpha: 0.1),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '向慧能提问...',
                        hintStyle: TextStyle(color: AppColors.zenSubtle),
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _handleSend,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.zenBrown.withValues(alpha: 0.1),
                    child: const Icon(
                      Icons.send,
                      size: 20,
                      color: AppColors.zenBrown,
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
}

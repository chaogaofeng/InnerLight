import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplaySettingsPage extends StatefulWidget {
  const DisplaySettingsPage({super.key});

  @override
  State<DisplaySettingsPage> createState() => _DisplaySettingsPageState();
}

class _DisplaySettingsPageState extends State<DisplaySettingsPage> {
  String _theme = 'paper'; // light, dark, paper
  double _textSize = 1.0; // 0-4 scale
  bool _isTraditional = false;

  Map<String, dynamic> get _currentTheme {
    switch (_theme) {
      case 'dark':
        return {
          'bg': const Color(0xFF1C1C1E),
          'border': const Color(0xFFFFFFFF).withValues(alpha: 0.1),
          'textTitle': const Color(0xFFE5E5E5), // gray-200
          'textBody': const Color(0xFF9E9E9E), // gray-400
        };
      case 'light':
        return {
          'bg': Colors.white,
          'border': const Color(0xFF8B5A2B).withValues(alpha: 0.1),
          'textTitle': const Color(0xFF2C2C2C), // zen-ink
          'textBody': const Color(0xFF2C2C2C).withValues(alpha: 0.7),
        };
      case 'paper':
      default:
        return {
          'bg': const Color(0xFFF2EFE9),
          'border': const Color(0xFF8B5A2B).withValues(alpha: 0.2),
          'textTitle': const Color(0xFF2C2C2C), // zen-ink
          'textBody': const Color(0xFF2C2C2C).withValues(alpha: 0.7),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = _currentTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF8), // zen-bg
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFCF8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '显示设置',
          style: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Preview Card
              _buildSectionHeader('预览'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  color: themeData['bg'],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: themeData['border']),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isTraditional ? '菩提本無樹' : '菩提本无树',
                      style: GoogleFonts.notoSerif(
                        fontSize: 18 + (_textSize * 2), // 1.125rem base + scale
                        fontWeight: FontWeight.bold,
                        color: themeData['textTitle'],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isTraditional
                          ? '明鏡亦非臺。本來無一物，何處惹塵埃。'
                          : '明镜亦非台。本来无一物，何处惹尘埃。',
                      style: GoogleFonts.notoSerif(
                        fontSize: 14 + (_textSize * 2), // 0.875rem base + scale
                        color: themeData['textBody'],
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Appearance / Theme
              _buildSectionHeader('外观模式'),
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: Row(
                  children: [
                    _buildThemeOption(
                      id: 'light',
                      label: '浅色',
                      icon: Icons.wb_sunny_outlined,
                      bgColor: Colors.white,
                      borderColor: Colors.grey[200]!,
                      textColor: Colors.grey[800]!,
                    ),
                    const SizedBox(width: 12),
                    _buildThemeOption(
                      id: 'dark',
                      label: '深色',
                      icon: Icons.dark_mode_outlined,
                      bgColor: const Color(0xFF1C1C1E),
                      borderColor: Colors.grey[700]!,
                      textColor: Colors.grey[200]!,
                    ),
                    const SizedBox(width: 12),
                    _buildThemeOption(
                      id: 'paper',
                      label: '护眼',
                      icon: Icons.monitor,
                      bgColor: const Color(0xFFF2EFE9),
                      borderColor: const Color(0xFFD9D2C5),
                      textColor: const Color(0xFF5D4F43),
                    ),
                  ],
                ),
              ),

              // 3. Text Size
              _buildSectionHeader('字体大小'),
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      'A',
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: const Color(0xFF8B5A2B),
                          inactiveTrackColor: const Color(
                            0xFF8B5A2B,
                          ).withValues(alpha: 0.1),
                          thumbColor: const Color(0xFF8B5A2B),
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                          ),
                          overlayColor: const Color(
                            0xFF8B5A2B,
                          ).withValues(alpha: 0.1),
                        ),
                        child: Slider(
                          value: _textSize,
                          min: 0,
                          max: 4,
                          divisions: 4,
                          onChanged: (value) {
                            setState(() {
                              _textSize = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Text(
                      'A',
                      style: GoogleFonts.notoSans(
                        fontSize: 20,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Language
              _buildSectionHeader('语言文字'),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isTraditional = !_isTraditional;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFDFCF8), // zen-paper
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.language,
                              size: 18,
                              color: _isTraditional
                                  ? const Color(0xFF8B5A2B)
                                  : const Color(
                                      0xFF8B5A2B,
                                    ).withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '繁体中文模式',
                              style: GoogleFonts.notoSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2C2C2C),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 44,
                            height: 24,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: _isTraditional
                                  ? const Color(0xFF8B5A2B)
                                  : const Color(
                                      0xFF8B5A2B,
                                    ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Align(
                              alignment: _isTraditional
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '启用后，应用内文字将尽可能转换为繁体显示。',
                  style: GoogleFonts.notoSans(
                    fontSize: 10,
                    color: const Color(0xFF9E9E9E).withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.notoSans(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF9E9E9E).withValues(alpha: 0.7),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String id,
    required String label,
    required IconData icon,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    final isSelected = _theme == id;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _theme = id;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF8B5A2B).withValues(alpha: 0.05)
                : const Color(0xFFFDFCF8).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF8B5A2B) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 2),
                  ],
                ),
                child: Icon(icon, size: 16, color: textColor),
              ),
              Text(
                label,
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF8B5A2B)
                      : const Color(0xFF9E9E9E),
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                  ), // Placeholder for dot if needed
                  child: Container(
                    // Dot functionality usually absolute in React, simplied here
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

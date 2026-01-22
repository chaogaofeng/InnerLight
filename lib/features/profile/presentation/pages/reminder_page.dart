import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  bool _isEnabled = true;
  TimeOfDay _time = const TimeOfDay(hour: 6, minute: 0);
  final List<int> _selectedDays = [0, 1, 2, 3, 4, 5, 6]; // 0 = Sun, 1 = Mon ...
  String _sound = 'bell';

  final List<String> _days = ['日', '一', '二', '三', '四', '五', '六'];
  final List<Map<String, String>> _sounds = [
    {'id': 'bell', 'label': '晨钟'},
    {'id': 'fish', 'label': '木鱼'},
    {'id': 'bird', 'label': '鸟鸣'},
  ];

  void _toggleDay(int index) {
    setState(() {
      if (_selectedDays.contains(index)) {
        _selectedDays.remove(index);
      } else {
        _selectedDays.add(index);
        _selectedDays.sort();
      }
    });
  }

  Future<void> _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B5A2B), // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Color(0xFF2C2C2C), // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF8B5A2B), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  void _handleSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('设置已保存'),
        duration: Duration(milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF8B5A2B),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
          '每日提醒',
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
              // 1. Top Switch Card
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '开启提醒',
                          style: GoogleFonts.notoSerif(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2C2C2C),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '每日按时提醒修行，精进不懈',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(
                              0xFF9E9E9E,
                            ).withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isEnabled,
                      onChanged: (value) {
                        setState(() {
                          _isEnabled = value;
                        });
                      },
                      activeThumbColor: const Color(0xFF8B5A2B),
                      activeTrackColor: const Color(
                        0xFF8B5A2B,
                      ).withValues(alpha: 0.2),
                    ),
                  ],
                ),
              ),

              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isEnabled ? 1.0 : 0.4,
                child: IgnorePointer(
                  ignoring: !_isEnabled,
                  child: Column(
                    children: [
                      // 2. Time Picker Visual
                      GestureDetector(
                        onTap: _selectTime,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 48),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '${_time.hourOfPeriod.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
                                    style: GoogleFonts.notoSerif(
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF2C2C2C),
                                      letterSpacing: 4,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _time.period == DayPeriod.am ? 'AM' : 'PM',
                                    style: GoogleFonts.notoSans(
                                      fontSize: 16,
                                      color: const Color(0xFF9E9E9E),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 200,
                                height: 1,
                                color: const Color(
                                  0xFF8B5A2B,
                                ).withValues(alpha: 0.1),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 3. Days Selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Color(0xFF8B5A2B),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '重复设置',
                                style: GoogleFonts.notoSerif(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2C2C2C),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(_days.length, (index) {
                              final isSelected = _selectedDays.contains(index);
                              return InkWell(
                                onTap: () => _toggleDay(index),
                                borderRadius: BorderRadius.circular(20),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? const Color(0xFF8B5A2B)
                                        : const Color(0xFFF2EFE9),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF8B5A2B,
                                              ).withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : null,
                                    border: Border.all(
                                      color: const Color(
                                        0xFF8B5A2B,
                                      ).withValues(alpha: isSelected ? 0 : 0.1),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _days[index],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF9E9E9E),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // 4. Sound Selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.volume_up_outlined,
                                size: 16,
                                color: Color(0xFF8B5A2B),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '提示音效',
                                style: GoogleFonts.notoSerif(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2C2C2C),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: _sounds.map((sound) {
                              final isSelected = _sound == sound['id'];
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _sound = sound['id']!;
                                  });
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(
                                            0xFFF2EFE9,
                                          ).withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF8B5A2B)
                                          : const Color(
                                              0xFF8B5A2B,
                                            ).withValues(alpha: 0.05),
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.02,
                                              ),
                                              blurRadius: 4,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isSelected
                                                  ? const Color(
                                                      0xFF8B5A2B,
                                                    ).withValues(alpha: 0.1)
                                                  : Colors.transparent,
                                            ),
                                            child: Icon(
                                              Icons.music_note,
                                              size: 16,
                                              color: isSelected
                                                  ? const Color(0xFF8B5A2B)
                                                  : const Color(0xFF9E9E9E),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            sound['label']!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: isSelected
                                                  ? const Color(0xFF2C2C2C)
                                                  : const Color(0xFF9E9E9E),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (isSelected)
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFF8B5A2B),
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                        )
                                      else
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(
                                                0xFF9E9E9E,
                                              ).withValues(alpha: 0.2),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // 5. Quote Preview
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2EFE9).withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(
                              0xFF8B5A2B,
                            ).withValues(alpha: 0.05),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '提醒文案预览',
                              style: TextStyle(
                                fontSize: 10,
                                color: const Color(
                                  0xFF8B5A2B,
                                ).withValues(alpha: 0.6),
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '“是日已过，命亦随减。\n如少水鱼，斯有何乐。”',
                              style: GoogleFonts.notoSerif(
                                fontSize: 14,
                                color: const Color(0xFF2C2C2C),
                                height: 1.8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 6. Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5A2B),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: const Color(
                              0xFF8B5A2B,
                            ).withValues(alpha: 0.2),
                          ),
                          child: const Text(
                            '保存设置',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
